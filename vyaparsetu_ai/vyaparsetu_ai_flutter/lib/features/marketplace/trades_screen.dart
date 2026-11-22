import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vyaparsetu_ai_client/vyaparsetu_ai_client.dart';

import '../../providers/session_provider.dart';

final tradesProvider = FutureProvider.autoDispose<List<TradeRequest>>(
  (ref) => ref.watch(serverClientProvider).trade.listMine(),
);

String marketplaceError(Object error, String fallback) =>
    error is ProductDraftException ? error.message : fallback;

String _rupees(int paise) =>
    '₹${paise ~/ 100}.${(paise % 100).toString().padLeft(2, '0')}';

int? _paise(String text) {
  final value = text.trim();
  if (!RegExp(r'^\d{1,9}(\.\d{1,2})?$').hasMatch(value)) return null;
  final parts = value.split('.');
  final fraction = parts.length == 1 ? 0 : int.parse(parts[1].padRight(2, '0'));
  final total = int.parse(parts[0]) * 100 + fraction;
  return total >= 1 && total <= 10000000000 ? total : null;
}

class TradesScreen extends ConsumerStatefulWidget {
  const TradesScreen({
    required this.role,
    this.embedded = false,
    super.key,
  });
  final MarketplaceRole role;

  /// When true the screen is rendered inside another shell, which owns the
  /// app bar, so this screen only renders its content.
  final bool embedded;

  @override
  ConsumerState<TradesScreen> createState() => _TradesScreenState();
}

class _TradesScreenState extends ConsumerState<TradesScreen> {
  bool _busy = false;

  Future<void> _act(TradeRequest trade) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final endpoint = ref.read(serverClientProvider).trade;
      if (widget.role == MarketplaceRole.producer) {
        final total = await showDialog<int>(
          context: context,
          builder: (_) => const _QuoteDialog(),
        );
        if (total == null || !mounted) return;
        await endpoint.quote(requestId: trade.id!, totalPaise: total);
      } else {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Accept quote?'),
            content: Text(
              'Confirm an order for ${_rupees(trade.totalPaise!)}.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Confirm'),
              ),
            ],
          ),
        );
        if (confirmed != true || !mounted) return;
        await endpoint.accept(requestId: trade.id!);
      }
      if (mounted) ref.invalidate(tradesProvider);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            marketplaceError(error, 'Could not update the request.'),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final trades = ref.watch(tradesProvider);
    return Scaffold(
      appBar: widget.embedded
          ? null
          : AppBar(
              title: const Text('Quotes and orders'),
              actions: [
                IconButton(
                  tooltip: 'Refresh',
                  onPressed: () => ref.invalidate(tradesProvider),
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
      body: SafeArea(
        child: Column(
          children: [
            if (widget.embedded)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 12, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Quotes and orders',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Refresh',
                      onPressed: () => ref.invalidate(tradesProvider),
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: trades.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Text(
                    marketplaceError(
                      error,
                      'Could not load quotes and orders.',
                    ),
                  ),
                ),
                data: (rows) => ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    if (rows.isEmpty) const Text('No quotes or orders yet.'),
                    for (final trade in rows)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trade.productName,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text('Quantity: ${trade.quantity}'),
                              if (trade.requirements.isNotEmpty)
                                Text(trade.requirements),
                              Text(switch (trade.status) {
                                TradeStatus.requested => 'Awaiting quote',
                                TradeStatus.quoted => 'Quoted',
                                TradeStatus.accepted =>
                                  'Order #${trade.id} confirmed',
                              }),
                              if (trade.totalPaise case final total?)
                                Text(_rupees(total)),
                              if (widget.role == MarketplaceRole.producer &&
                                  trade.status == TradeStatus.requested)
                                TextButton(
                                  onPressed: _busy ? null : () => _act(trade),
                                  child: const Text('Send quote'),
                                ),
                              if (widget.role == MarketplaceRole.buyer &&
                                  trade.status == TradeStatus.quoted)
                                TextButton(
                                  onPressed: _busy ? null : () => _act(trade),
                                  child: const Text('Accept quote'),
                                ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuoteDialog extends StatefulWidget {
  const _QuoteDialog();
  @override
  State<_QuoteDialog> createState() => _QuoteDialogState();
}

class _QuoteDialogState extends State<_QuoteDialog> {
  final _form = GlobalKey<FormState>();
  final _amount = TextEditingController();

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Send quote'),
    content: Form(
      key: _form,
      child: TextFormField(
        autofocus: true,
        controller: _amount,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(labelText: 'Total in ₹'),
        validator: (value) => _paise(value ?? '') == null
            ? 'Enter a valid total with up to two decimal places.'
            : null,
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: () {
          if (_form.currentState!.validate()) {
            Navigator.pop(context, _paise(_amount.text));
          }
        },
        child: const Text('Send'),
      ),
    ],
  );
}
