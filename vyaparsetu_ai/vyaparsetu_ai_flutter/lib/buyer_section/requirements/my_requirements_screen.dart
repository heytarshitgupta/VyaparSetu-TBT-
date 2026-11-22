import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/routes/app_router.dart';
import '../../providers/session_provider.dart';
import '../../features/marketplace/trades_screen.dart' show marketplaceError;

final myRequirementsProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(serverClientProvider).marketplaceExtra.listRequirements(),
);

String _rupees(int paise) =>
    '₹${paise ~/ 100}.${(paise % 100).toString().padLeft(2, '0')}';

class MyRequirementsScreen extends ConsumerWidget {
  const MyRequirementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requirements = ref.watch(myRequirementsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Requirements'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () => ref.invalidate(myRequirementsProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.pushNamed(context, AppRouter.postRequirementRoute);
          ref.invalidate(myRequirementsProvider);
        },
        icon: const Icon(Icons.add),
        label: const Text('Post requirement'),
      ),
      body: SafeArea(
        child: requirements.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    marketplaceError(
                      error,
                      'Could not load your requirements.',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => ref.invalidate(myRequirementsProvider),
                    child: const Text('Try again'),
                  ),
                ],
              ),
            ),
          ),
          data: (rows) => rows.isEmpty
              ? const Center(
                  child: Text('You have not posted a requirement yet.'),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                  itemCount: rows.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final requirement = rows[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    requirement.title,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                ),
                                Chip(
                                  label: Text(requirement.status),
                                  visualDensity: VisualDensity.compact,
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${requirement.category} · '
                              '${requirement.quantity} units'
                              '${requirement.budgetPaise == null ? '' : ' · budget ${_rupees(requirement.budgetPaise!)}'}',
                            ),
                            if (requirement.description.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(requirement.description),
                            ],
                            if ((requirement.city ?? '').isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(
                                [requirement.city, requirement.state]
                                    .whereType<String>()
                                    .where((value) => value.isNotEmpty)
                                    .join(', '),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
