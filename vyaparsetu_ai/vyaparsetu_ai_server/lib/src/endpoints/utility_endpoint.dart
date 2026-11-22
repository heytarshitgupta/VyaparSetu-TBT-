import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

class UtilityEndpoint extends Endpoint {
  /// Fast suggested price in paise based on artisan product categories and keywords
  Future<int> suggestedPrice(
    Session session, {
    required String name,
    required String category,
  }) async {
    final text = '$name $category'.toLowerCase();
    if (text.contains('pashmina') || text.contains('zari')) return 350000;
    if (text.contains('silk') || text.contains('phulkari')) return 125000;
    if (text.contains('brass') || text.contains('bell metal') || text.contains('bronze')) return 185000;
    if (text.contains('khadi') || text.contains('kurta') || text.contains('bedsheet')) return 85000;
    if (text.contains('wood') || text.contains('sheesham') || text.contains('channapatna')) return 65000;
    if (text.contains('pottery') || text.contains('terracotta') || text.contains('ceramic')) return 55000;
    if (text.contains('honey') || text.contains('oil')) return 45000;
    if (text.contains('jaggery') || text.contains('gur') || text.contains('pickle')) return 30000;
    if (text.contains('bamboo') || text.contains('jute')) return 45000;
    return 50000;
  }

  /// Full pricing engine calculation porting pricing_engine.py
  Future<Map<String, String>> calculatePrice(
    Session session, {
    required String productId,
    required String category,
    required String description,
    bool isBulk = false,
  }) async {
    // 1. WPI category inflation multiplier
    double wpiMultiplier = 1.05;
    final catLower = category.toLowerCase();
    if (catLower.contains('food')) {
      wpiMultiplier = 1.08;
    } else if (catLower.contains('textile') || catLower.contains('handloom')) {
      wpiMultiplier = 1.06;
    } else if (catLower.contains('metal') || catLower.contains('manufacturing')) {
      wpiMultiplier = 1.05;
    } else if (catLower.contains('craft') || catLower.contains('wood')) {
      wpiMultiplier = 1.07;
    }

    // 2. Base costs estimation from category / description keywords
    double baseMaterialCost = 100.0;
    double materialQty = 1.5;
    double laborHours = 2.0;
    double hourlyWage = 50.0;
    double packagingCost = 30.0;
    double targetMarginPct = 0.30;

    if (catLower.contains('food')) {
      baseMaterialCost = 80.0;
      materialQty = 1.2;
      laborHours = 1.0;
      hourlyWage = 45.0;
      packagingCost = 25.0;
      targetMarginPct = 0.25;
    } else if (catLower.contains('handloom') || catLower.contains('cloth') || catLower.contains('textile')) {
      baseMaterialCost = 180.0;
      materialQty = 2.0;
      laborHours = 4.5;
      hourlyWage = 55.0;
      packagingCost = 40.0;
      targetMarginPct = 0.35;
    } else if (catLower.contains('metal') || catLower.contains('brass')) {
      baseMaterialCost = 350.0;
      materialQty = 1.5;
      laborHours = 3.5;
      hourlyWage = 60.0;
      packagingCost = 50.0;
      targetMarginPct = 0.30;
    } else if (catLower.contains('pottery') || catLower.contains('handicraft')) {
      baseMaterialCost = 50.0;
      materialQty = 2.0;
      laborHours = 2.5;
      hourlyWage = 45.0;
      packagingCost = 35.0;
      targetMarginPct = 0.30;
    }

    // 3. Cost floor calculation
    final rawCost = baseMaterialCost * materialQty * wpiMultiplier;
    final laborCost = laborHours * hourlyWage;
    final breakEven = rawCost + laborCost + packagingCost;
    final desiredFloor = breakEven * (1 + targetMarginPct);

    // 4. Market ceiling estimate from retail benchmarks
    double marketCeiling = 800.0;
    final descLower = description.toLowerCase();
    if (descLower.contains('pashmina') || descLower.contains('silk')) {
      marketCeiling = 3200.0;
    } else if (descLower.contains('phulkari') || descLower.contains('brass')) {
      marketCeiling = 1800.0;
    } else if (descLower.contains('khadi') || descLower.contains('bedsheet') || descLower.contains('wood')) {
      marketCeiling = 950.0;
    } else if (descLower.contains('honey') || descLower.contains('oil') || descLower.contains('ghee')) {
      marketCeiling = 650.0;
    } else if (descLower.contains('terracotta') || descLower.contains('pickle') || descLower.contains('gur')) {
      marketCeiling = 450.0;
    }

    // 5. Tier & recommendation
    double optimalPrice;
    String pricingType;
    String advice;

    if (isBulk) {
      optimalPrice = breakEven * 1.15;
      if (optimalPrice < marketCeiling * 0.75) {
        optimalPrice = marketCeiling * 0.75;
      }
      pricingType = 'B2B Wholesale Tier (Aggregation Recommended)';
      advice = 'Bulk wholesale demand tier. Recommended margin preserves artisan break-even above ₹${breakEven.toStringAsFixed(2)}.';
    } else {
      optimalPrice = desiredFloor;
      if (optimalPrice > marketCeiling) {
        optimalPrice = marketCeiling;
      }
      if (optimalPrice < breakEven) {
        optimalPrice = breakEven * 1.05;
      }
      pricingType = 'B2C Retail Tier';
      advice = 'Break-even floor is ₹${breakEven.toStringAsFixed(2)}. Market ceiling benchmarks at ₹${marketCeiling.toStringAsFixed(2)}.';
    }

    return {
      'product_id': productId,
      'pricing_tier': pricingType,
      'break_even_floor': breakEven.toStringAsFixed(2),
      'recommended_price': optimalPrice.toStringAsFixed(2),
      'market_ceiling': marketCeiling.toStringAsFixed(2),
      'ai_guidance': advice,
    };
  }

  /// AI Catalog generation with Gemini API or deterministic artisan template fallback
  Future<String> generateCatalogDescription(
    Session session, {
    required String name,
    required String category,
    String? voiceText,
  }) async {
    final craft = voiceText?.trim() ?? '';
    final apiKey = Platform.environment['GEMINI_API_KEY'] ??
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
        final response = await request.close().timeout(const Duration(seconds: 4));

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
        session.log('Gemini catalog generation API error, falling back to template: $e', level: LogLevel.warning);
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
