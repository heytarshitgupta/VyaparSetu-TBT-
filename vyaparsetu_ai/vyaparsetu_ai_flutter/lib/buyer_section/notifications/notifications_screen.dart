import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/session_provider.dart';

final _notificationsProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(serverClientProvider).marketplaceExtra.notifications(),
);

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(_notificationsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: notifications.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Could not load notifications.'),
              TextButton(
                onPressed: () => ref.invalidate(_notificationsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (rows) => rows.isEmpty
            ? const Center(
                child: Text('You are all caught up!'),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: rows.length,
                itemBuilder: (context, index) {
                  final row = rows[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(
                        row.isRead
                            ? Icons.notifications_none
                            : Icons.notifications_active,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(row.title),
                      subtitle: Text(row.message),
                      onTap: row.isRead
                          ? null
                          : () async {
                              await ref
                                  .read(serverClientProvider)
                                  .marketplaceExtra
                                  .markNotificationRead(
                                    notificationId: row.id!,
                                  );
                              ref.invalidate(_notificationsProvider);
                            },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
