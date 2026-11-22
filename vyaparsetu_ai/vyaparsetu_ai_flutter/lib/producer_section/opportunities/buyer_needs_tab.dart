import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/session_provider.dart';

final _buyerNeedsProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(serverClientProvider).marketplaceExtra.listRequirements(),
);

class BuyerNeedsTab extends ConsumerWidget {
  const BuyerNeedsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final needs = ref.watch(_buyerNeedsProvider);
    return Scaffold(
      body: needs.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: TextButton(
            onPressed: () => ref.invalidate(_buyerNeedsProvider),
            child: const Text('Retry buyer requirements'),
          ),
        ),
        data: (rows) => rows.isEmpty
            ? const Center(child: Text('No buyer requirements right now'))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: rows.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final row = rows[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            row.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          Text('${row.category} · ${row.quantity} units'),
                          if (row.description.isNotEmpty) Text(row.description),
                          const SizedBox(height: 12),
                          FilledButton(
                            onPressed: () => _respond(context, ref, row.id!),
                            child: const Text('Respond'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Future<void> _respond(
    BuildContext context,
    WidgetRef ref,
    int requirementId,
  ) async {
    final message = TextEditingController();
    final amount = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Respond to requirement'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: message,
              decoration: const InputDecoration(labelText: 'Message'),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amount,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(labelText: 'Quote total (₹)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Send'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final paise = double.tryParse(amount.text.trim());
    await ref
        .read(serverClientProvider)
        .marketplaceExtra
        .respondRequirement(
          requirementId: requirementId,
          message: message.text,
          quotedPaise: paise == null ? null : (paise * 100).round(),
        );
    ref.invalidate(_buyerNeedsProvider);
  }
}
