import 'package:flutter/material.dart';
import 'package:vyaparsetu_ai_client/vyaparsetu_ai_client.dart';

class ProfileSetupForm extends StatefulWidget {
  const ProfileSetupForm({super.key, required this.onSave});

  final Future<void> Function(String name, MarketplaceRole role) onSave;

  @override
  State<ProfileSetupForm> createState() => _ProfileSetupFormState();
}

class _ProfileSetupFormState extends State<ProfileSetupForm> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  MarketplaceRole? _role;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || !_form.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await widget.onSave(_name.text.trim(), _role!);
    } on ProfileException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Could not save your profile. Try again.');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Form(
    key: _form,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Set up your profile',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _name,
          enabled: !_saving,
          decoration: const InputDecoration(labelText: 'Display name'),
          textCapitalization: TextCapitalization.words,
          validator: (value) {
            final length = value?.trim().runes.length ?? 0;
            return length < 1 || length > 80
                ? 'Enter a name of 1 to 80 characters.'
                : null;
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<MarketplaceRole>(
          decoration: const InputDecoration(labelText: 'Marketplace role'),
          items: const [
            DropdownMenuItem(
              value: MarketplaceRole.buyer,
              child: Text('Buyer'),
            ),
            DropdownMenuItem(
              value: MarketplaceRole.producer,
              child: Text('Producer'),
            ),
          ],
          validator: (value) => value == null ? 'Choose a role.' : null,
          onChanged: _saving ? null : (value) => setState(() => _role = value),
        ),
        if (_error case final error?) ...[
          const SizedBox(height: 12),
          Text(
            error,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
        const SizedBox(height: 20),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: Text(_saving ? 'Saving…' : 'Save profile'),
        ),
      ],
    ),
  );
}
