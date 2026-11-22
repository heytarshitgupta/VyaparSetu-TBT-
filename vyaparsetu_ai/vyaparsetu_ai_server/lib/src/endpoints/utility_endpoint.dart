import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../pricing/pricing_engine.dart';

class UtilityEndpoint extends Endpoint {
  /// Fast suggested price in paise, from the same engine the full calculator
  /// uses. Kept for the one-tap suggestion in the add-product form.
  Future<int> suggestedPrice(
    Session session, {
    required String name,
    required String category,
  }) async {
    final recommendation = await _recommend(
      session,
      name: name,
      category: category,
      description: '',
    );
    return (recommendation.recommendedRupees * 100).round();
  }

  /// Full pricing recommendation.
  ///
  /// The cost floor is deterministic (matched artisan cost profile plus the
  /// real WPI index). The market band comes from comparable listings: the
  /// illustrative benchmark plus live catalogue prices in the same segment.
  /// Nothing here pretends to know a single "correct" price; it returns a
  /// band, a confidence level, and the reasons behind every number.
  Future<Map<String, String>> calculatePrice(
    Session session, {
    required String productId,
    required String category,
    required String description,
    bool isBulk = false,
  }) async {
    var name = '';
    var resolvedCategory = category;
    var resolvedDescription = description;

    final numericId = int.tryParse(productId);
    if (numericId != null) {
      try {
        final product = await Product.db.findById(session, numericId);
        if (product != null) {
          name = product.name;
          resolvedCategory = product.category?.isNotEmpty == true
              ? product.category!
              : category;
          resolvedDescription = product.description;
        }
      } catch (error) {
        session.log(
          'Pricing lookup for product $productId failed, using request data: '
          '$error',
          level: LogLevel.warning,
        );
      }
    }

    if (name.isEmpty) {
      name = description.isEmpty ? category : description;
    }

    final recommendation = await _recommend(
      session,
      name: name,
      category: resolvedCategory,
      description: resolvedDescription,
      isBulk: isBulk,
    );
    return recommendation.toJsonMap(productId);
  }

  Future<PriceRecommendation> _recommend(
    Session session, {
    required String name,
    required String category,
    required String description,
    bool isBulk = false,
  }) async {
    final segment = PricingEngine.segmentFor(category, description);
    final catalogPrices = await _catalogPrices(session, segment);

    return PricingEngine.instance.recommend(
      name: name,
      category: category,
      description: description,
      isBulk: isBulk,
      catalogPrices: catalogPrices,
    );
  }

  /// Live listing prices (rupees) in the same market segment, so the band
  /// follows the real marketplace instead of only the static benchmark.
  Future<List<double>> _catalogPrices(Session session, String segment) async {
    try {
      final rows = await Product.db.find(
        session,
        where: (product) => product.status.equals(ProductStatus.published),
        limit: 200,
      );
      final prices = <double>[];
      for (final row in rows) {
        final pricePaise = row.pricePaise;
        if (pricePaise == null || pricePaise <= 0) continue;
        final rowSegment = PricingEngine.segmentFor(
          row.category ?? '',
          row.description,
        );
        if (rowSegment != segment) continue;
        prices.add(pricePaise / 100);
      }
      return prices;
    } catch (error) {
      session.log(
        'Could not load catalogue prices for the market band: $error',
        level: LogLevel.warning,
      );
      return const [];
    }
  }

  /// AI Catalog generation with Gemini API or deterministic artisan template fallback
  Future<String> generateCatalogDescription(
    Session session, {
    required String name,
    required String category,
    String? voiceText,
  }) async {
    final craft = voiceText?.trim() ?? '';
    final apiKey =
        Platform.environment['GEMINI_API_KEY'] ??
        Platform.environment['LLM_API_KEY'] ??
        Serverpod.instance.getPassword('geminiApiKey') ??
        '';

    if (apiKey.trim().isNotEmpty) {
      try {
        final client = HttpClient();
        final uri = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${apiKey.trim()}',
        );
        final prompt =
            'You are an expert e-commerce copywriter for Indian rural artisans. '
            'Write an appealing 2-3 sentence e-commerce description for a handcrafted product.\n'
            'Product Name: $name\n'
            'Category: $category\n'
            'Artisan voice transcript: $craft\n'
            'Highlight regional craftsmanship, natural materials, and heritage value. Only return the description text.';

        final request = await client.postUrl(uri);
        request.headers.contentType = ContentType.json;
        final payload = jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt},
              ],
            },
          ],
        });
        request.write(payload);
        final response = await request.close().timeout(
          const Duration(seconds: 4),
        );

        if (response.statusCode == 200) {
          final responseBody = await response.transform(utf8.decoder).join();
          final decoded = jsonDecode(responseBody) as Map<String, dynamic>;
          final candidates = decoded['candidates'] as List?;
          if (candidates != null && candidates.isNotEmpty) {
            final content = candidates[0]['content'] as Map<String, dynamic>?;
            final parts = content?['parts'] as List?;
            if (parts != null && parts.isNotEmpty) {
              final text = parts[0]['text'] as String?;
              if (text != null && text.trim().isNotEmpty) {
                return text.trim();
              }
            }
          }
        }
      } catch (e) {
        session.log(
          'Gemini catalog generation API error, falling back to template: $e',
          level: LogLevel.warning,
        );
      }
    }

    // Deterministic high-quality template-based fallback
    if (craft.isNotEmpty) {
      return '$name is an authentic $category craft handmade with traditional artisan techniques. $craft. Expertly finished for durability, cultural heritage, and conscious gifting.';
    }
    return '$name is a thoughtfully crafted $category creation by an Indian rural artisan. Made with authentic regional techniques and pure raw materials. Ideal for home decor, personal use, and sustainable living.';
  }

  /// Port of improve-product-photo: returns photo safely (graceful fallback)
  Future<ByteData?> improvePhoto(
    Session session, {
    required ByteData? photo,
  }) async => photo;
}
