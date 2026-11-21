import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vyaparsetu_ai_client/vyaparsetu_ai_client.dart';

import '../../providers/product_drafts_provider.dart';

class ProductDraftsScreen extends ConsumerStatefulWidget {
  const ProductDraftsScreen({super.key});

  @override
  ConsumerState<ProductDraftsScreen> createState() => _ProductDraftsScreenState();
}

class _ProductDraftsScreenState extends ConsumerState<ProductDraftsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _saving = false;
  String? _saveError;

  @override
  void dispose() {
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
      await ref.read(productDraftsProvider.notifier).createDraft(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
          );
      if (!mounted) return;
      _nameController.clear();
      _descriptionController.clear();
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

  @override
  Widget build(BuildContext context) {
    final draftsAsync = ref.watch(productDraftsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Products'),
      ),
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
                          enabled: !_saving,
                          decoration: const InputDecoration(
                            labelText: 'Description (optional)',
                            hintText: 'Enter optional description up to 2000 characters',
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
                          onPressed: _saving ? null : _saveDraft,
                          child: Text(_saving ? 'Saving…' : 'Save draft'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),
                  const Divider(),
                  const SizedBox(height: 20),
                  Text(
                    'Saved drafts',
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
                                  : 'Could not load product drafts.',
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
                              'No product drafts yet.',
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
                              title: Text(
                                draft.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: draft.description.isNotEmpty
                                  ? Text(draft.description)
                                  : null,
                              trailing: Chip(
                                label: Text(
                                  draft.status.name,
                                  style: const TextStyle(fontSize: 12),
                                ),
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
