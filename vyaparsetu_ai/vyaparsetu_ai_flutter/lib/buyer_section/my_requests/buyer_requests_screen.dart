import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/session_provider.dart';
import '../post_requirement/post_requirement_screen.dart';

final _requirementsProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(serverClientProvider).marketplaceExtra.listRequirements(),
);

class BuyerRequestsScreen extends ConsumerWidget {
  const BuyerRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requirements = ref.watch(_requirementsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Requirements'),
        actions: [
          IconButton(
            tooltip: 'Post requirement',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const PostRequirementScreen(),
                ),
              );
              ref.invalidate(_requirementsProvider);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: requirements.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: TextButton(
            onPressed: () => ref.invalidate(_requirementsProvider),
            child: const Text('Retry loading requirements'),
          ),
        ),
        data: (rows) => rows.isEmpty
            ? const Center(
                child: Text('No requirements yet.'),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: rows.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final row = rows[index];
                  return Card(
                    child: ListTile(
                      title: Text(row.title),
                      subtitle: Text(
                        '${row.category} · ${row.quantity} units · ${row.status}',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
