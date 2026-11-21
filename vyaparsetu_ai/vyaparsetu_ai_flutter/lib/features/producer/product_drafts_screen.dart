import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../marketplace/product_photo.dart';

import 'package:vyaparsetu_ai_client/vyaparsetu_ai_client.dart';

import '../../providers/product_drafts_provider.dart';

class ProductDraftsScreen extends ConsumerStatefulWidget {
  const ProductDraftsScreen({super.key});

  @override
  ConsumerState<ProductDraftsScreen> createState() =>
      _ProductDraftsScreenState();
}

class _ProductDraftsScreenState extends ConsumerState<ProductDraftsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _speech = SpeechToText();
  Uint8List? _photo;
  bool _listening = false;
  bool _startingSpeech = false;
  bool _pickingPhoto = false;
  bool _saving = false;
  String? _saveError;
  int? _updatingProduct;

  @override
  void dispose() {
    _speech.cancel();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveDraft() async {
    if (_saving || !_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _saveError = null;
    });

    try {
      await ref
          .read(productDraftsProvider.notifier)
          .createDraft(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            photo: _photo == null ? null : ByteData.sublistView(_photo!),
          );
      if (!mounted) return;
      _nameController.clear();
      _descriptionController.clear();
      setState(() => _photo = null);
      _formKey.currentState?.reset();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Draft saved successfully.')),
      );
    } on ProductDraftException catch (e) {
      if (mounted) setState(() => _saveError = e.message);
    } catch (_) {
      if (mounted) {
        setState(() => _saveError = 'Could not save draft. Try again.');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickPhoto(ImageSource source) async {
    if (_pickingPhoto || _saving) return;
    setState(() {
      _pickingPhoto = true;
      _saveError = null;
    });
    try {
      final file = await ImagePicker().pickImage(
        source: source,
        maxWidth: 900,
        maxHeight: 900,
        imageQuality: 65,
      );
      if (file == null || !mounted) return;
      if (await file.length() > 240 * 1024) {
        if (mounted) {
          setState(() => _saveError = 'Choose a photo under 240 KB.');
        }
        return;
      }
      final bytes = await file.readAsBytes();
      if (mounted) setState(() => _photo = bytes);
    } catch (_) {
      if (mounted) {
        setState(
          () => _saveError = 'Could not open the camera or photo library.',
        );
      }
    } finally {
      if (mounted) setState(() => _pickingPhoto = false);
    }
  }

  Future<void> _dictate() async {
    if (_startingSpeech || _saving) return;
    if (_listening) {
      try {
        await _speech.stop();
      } catch (_) {
        if (mounted) setState(() => _saveError = 'Could not stop dictation.');
      } finally {
        if (mounted) setState(() => _listening = false);
      }
      return;
    }
    setState(() {
      _startingSpeech = true;
      _saveError = null;
    });
    try {
      final available = await _speech.initialize(
        onStatus: (status) {
          if (mounted && (status == 'done' || status == 'notListening')) {
            setState(() => _listening = false);
          }
        },
        onError: (_) {
          if (mounted) {
            setState(() {
              _listening = false;
              _saveError =
                  'Speech recognition stopped. You can type the description.';
            });
          }
        },
      );
      if (!mounted) return;
      if (!available) {
        setState(
          () => _saveError =
              'Speech recognition is unavailable. You can type the description.',
        );
        return;
      }
      final previous = _descriptionController.text.trim();
      setState(() => _listening = true);
      await _speech.listen(
        onResult: (result) {
          if (!mounted) return;
          final words = result.recognizedWords.trim();
          if (words.isEmpty) return;
          final text = previous.isEmpty ? words : '$previous $words';
          _descriptionController.value = TextEditingValue(
            text: text,
            selection: TextSelection.collapsed(offset: text.length),
          );
        },
      );
    } catch (_) {
      if (mounted) {
        setState(() {
          _listening = false;
          _saveError = 'Could not start speech recognition.';
        });
      }
    } finally {
      if (mounted) setState(() => _startingSpeech = false);
    }
  }

  Future<void> _togglePublication(Product product) async {
    if (_updatingProduct != null) return;
    setState(() => _updatingProduct = product.id);
    try {
      await ref
          .read(productDraftsProvider.notifier)
          .setPublished(product.id!, product.status != ProductStatus.published);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error is ProductDraftException
                ? error.message
                : 'Could not update this product. Try again.',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _updatingProduct = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final draftsAsync = ref.watch(productDraftsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Products')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'New draft',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          enabled: !_saving,
                          decoration: const InputDecoration(
                            labelText: 'Product name',
                            hintText: 'e.g. Copper Bottle',
                          ),
                          textCapitalization: TextCapitalization.words,
                          validator: (value) {
                            final length = value?.trim().runes.length ?? 0;
                            if (length < 1 || length > 120) {
                              return 'Enter a name of 1 to 120 characters.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _descriptionController,
                          enabled: !_saving && !_listening,
                          decoration: const InputDecoration(
                            labelText: 'Description (optional)',
                            hintText:
                                'Enter optional description up to 2000 characters',
                          ),
                          maxLines: 3,
                          validator: (value) {
                            final length = value?.trim().runes.length ?? 0;
                            if (length > 2000) {
                              return 'Use at most 2000 description characters.';
                            }
                            return null;
                          },
                        ),
                        Wrap(
                          children: [
                            TextButton.icon(
                              onPressed: _saving || _startingSpeech
                                  ? null
                                  : _dictate,
                              icon: Icon(_listening ? Icons.stop : Icons.mic),
                              label: Text(
                                _listening
                                    ? 'Stop dictation'
                                    : 'Dictate description',
                              ),
                            ),
                            TextButton.icon(
                              onPressed: _saving || _pickingPhoto
                                  ? null
                                  : () => _pickPhoto(ImageSource.camera),
                              icon: const Icon(Icons.photo_camera),
                              label: const Text('Take photo'),
                            ),
                            TextButton(
                              onPressed: _saving || _pickingPhoto
                                  ? null
                                  : () => _pickPhoto(ImageSource.gallery),
                              child: const Text('Choose photo'),
                            ),
                          ],
                        ),
                        if (_photo case final bytes?) ...[
                          Image.memory(
                            bytes,
                            height: 120,
                            errorBuilder: (_, _, _) =>
                                const Text('Photo preview unavailable'),
                          ),
                          TextButton(
                            onPressed: _saving
                                ? null
                                : () => setState(() => _photo = null),
                            child: const Text('Remove photo'),
                          ),
                        ],
                        if (_saveError != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            _saveError!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        FilledButton(
                          onPressed:
                              _saving ||
                                  _listening ||
                                  _startingSpeech ||
                                  _pickingPhoto
                              ? null
                              : _saveDraft,
                          child: Text(_saving ? 'Saving…' : 'Save draft'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),
                  const Divider(),
                  const SizedBox(height: 20),
                  Text(
                    'Saved products',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  draftsAsync.when(
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (error, _) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              error is ProductDraftException
                                  ? error.message
                                  : 'Could not load products.',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton(
                              onPressed: () =>
                                  ref.invalidate(productDraftsProvider),
                              child: const Text('Try again'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    data: (drafts) {
                      if (drafts.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: Text(
                              'No products yet.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: drafts.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final draft = drafts[index];
                          return Card(
                            child: ListTile(
                              onTap: draft.id == null
                                  ? null
                                  : () => showDialog<void>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(draft.name),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ProductPhotoView(
                                              productId: draft.id!,
                                            ),
                                            if (draft.description.isNotEmpty)
                                              Text(draft.description),
                                          ],
                                        ),
                                      ),
                                    ),
                              title: Text(
                                draft.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: draft.description.isNotEmpty
                                  ? Text(draft.description)
                                  : null,
                              trailing: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Chip(
                                    label: Text(switch (draft.status) {
                                      ProductStatus.draft => 'Draft',
                                      ProductStatus.published => 'Published',
                                      ProductStatus.hidden => 'Hidden',
                                    }),
                                  ),
                                  TextButton(
                                    onPressed:
                                        _updatingProduct != null ||
                                            draft.id == null
                                        ? null
                                        : () => _togglePublication(draft),
                                    child: Text(
                                      draft.status == ProductStatus.published
                                          ? 'Hide'
                                          : 'Publish',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
