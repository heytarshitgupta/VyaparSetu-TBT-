import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vyaparsetu_ai_client/vyaparsetu_ai_client.dart';

import '../../providers/session_provider.dart';
import 'trades_screen.dart';
import 'product_photo.dart';

final _catalogProvider = FutureProvider.autoDispose
    .family<List<Product>, String>(
      (ref, query) =>
          ref.watch(serverClientProvider).product.catalog(query: query),
    );

class MarketplaceScreen extends ConsumerStatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  ConsumerState<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends ConsumerState<MarketplaceScreen> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _submitSearch() {
    setState(() => _query = _search.text.trim());
    ref.invalidate(_catalogProvider(_query));
  }

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(_catalogProvider(_query));
    return Scaffold(
      appBar: AppBar(title: const Text('Marketplace')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              controller: _search,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _submitSearch(),
              decoration: InputDecoration(
                labelText: 'Search products',
                suffixIcon: IconButton(
                  tooltip: 'Search',
                  onPressed: _submitSearch,
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...catalog.when(
              loading: () => [const Center(child: CircularProgressIndicator())],
              error: (error, _) => [
                Text(
                  marketplaceError(error, 'Could not load the marketplace.'),
                ),
                TextButton(
                  onPressed: _submitSearch,
                  child: const Text('Try again'),
                ),
              ],
              data: (products) => [
                if (products.isEmpty) const Text('No matching products.'),
                for (final product in products)
                  Card(
                    child: ListTile(
                      title: Text(product.name),
                      subtitle: product.description.isEmpty
                          ? null
                          : Text(product.description),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => _QuoteRequestScreen(product: product),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuoteRequestScreen extends ConsumerStatefulWidget {
  const _QuoteRequestScreen({required this.product});
  final Product product;

  @override
  ConsumerState<_QuoteRequestScreen> createState() =>
      _QuoteRequestScreenState();
}

class _QuoteRequestScreenState extends ConsumerState<_QuoteRequestScreen> {
  final _form = GlobalKey<FormState>();
  final _quantity = TextEditingController(text: '1');
  final _requirements = TextEditingController();
  bool _sending = false;
  String? _error;

  @override
  void dispose() {
    _quantity.dispose();
    _requirements.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_sending || !_form.currentState!.validate()) return;
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      await ref
          .read(serverClientProvider)
          .trade
          .requestQuote(
            productId: widget.product.id!,
            quantity: int.parse(_quantity.text.trim()),
            requirements: _requirements.text,
          );
      if (!mounted) return;
      ref.invalidate(tradesProvider);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Quote request sent.')));
      Navigator.of(context).pop();
    } catch (error) {
      if (mounted) {
        setState(
          () => _error = marketplaceError(error, 'Could not send the request.'),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.product.name)),
    body: SafeArea(
      child: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ProductPhotoView(productId: widget.product.id!),
            if (widget.product.description.isNotEmpty)
              Text(widget.product.description),
            const SizedBox(height: 16),
            TextFormField(
              controller: _quantity,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              validator: (text) {
                final quantity = int.tryParse(text?.trim() ?? '');
                return quantity == null || quantity < 1 || quantity > 100000
                    ? 'Enter a quantity between 1 and 100,000.'
                    : null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _requirements,
              decoration: const InputDecoration(
                labelText: 'Requirements or delivery date',
              ),
              maxLength: 2000,
              maxLines: 3,
            ),
            if (_error != null) Text(_error!),
            FilledButton(
              onPressed: _sending ? null : _send,
              child: Text(_sending ? 'Sending…' : 'Request quote'),
            ),
          ],
        ),
      ),
    ),
  );
}
