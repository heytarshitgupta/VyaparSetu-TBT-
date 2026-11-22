import 'package:test/test.dart';
import 'package:vyaparsetu_ai_server/src/pricing/pricing_engine.dart';

void main() {
  final engine = PricingEngine.instance;

  test('recommendation keeps the price inside the cost and market band', () {
    final recommendation = engine.recommend(
      name: 'Desi Jaggery (Gur)',
      category: 'Food & Homemade Products',
      description:
          'Pure handmade organic desi jaggery block, no chemicals, traditional '
          'punjabi method.',
    );

    expect(recommendation.breakEvenRupees, greaterThan(0));
    expect(
      recommendation.recommendedRupees,
      greaterThanOrEqualTo(recommendation.breakEvenRupees),
    );
    expect(
      recommendation.lowRupees,
      lessThanOrEqualTo(recommendation.recommendedRupees),
    );
    expect(
      recommendation.highRupees,
      greaterThanOrEqualTo(recommendation.recommendedRupees),
    );
    expect(recommendation.comparablesUsed, greaterThan(0));
    expect(recommendation.matchedProfile, isNotEmpty);
    expect(recommendation.reasons, isNotEmpty);
  });

  test('premium craft carries a higher cost floor than a food item', () {
    final jaggery = engine.recommend(
      name: 'Desi Jaggery',
      category: 'Food',
      description: 'organic gur handmade',
    );
    final pashmina = engine.recommend(
      name: 'Pashmina-blend Stole',
      category: 'Clothing & Embroidery',
      description: 'handwoven pashmina blend stole premium',
    );

    expect(pashmina.breakEvenRupees, greaterThan(jaggery.breakEvenRupees));
  });

  test('bulk recommendation does not fall below the break-even floor', () {
    final retail = engine.recommend(
      name: 'Handwoven Cotton Khadi Kurta',
      category: 'Handloom & Textiles',
      description: 'pure breathable handwoven cotton khadi kurta',
    );
    final bulk = engine.recommend(
      name: 'Handwoven Cotton Khadi Kurta',
      category: 'Handloom & Textiles',
      description: 'pure breathable handwoven cotton khadi kurta',
      isBulk: true,
    );

    expect(
      bulk.recommendedRupees,
      greaterThanOrEqualTo(bulk.breakEvenRupees),
    );
    expect(bulk.recommendedRupees, lessThanOrEqualTo(retail.recommendedRupees));
    expect(bulk.tier, contains('Wholesale'));
  });

  test('live catalogue prices move the band', () {
    final withoutCatalog = engine.recommend(
      name: 'Terracotta Water Pitcher',
      category: 'Handicrafts',
      description: 'natural red clay water dispenser',
    );
    final withCatalog = engine.recommend(
      name: 'Terracotta Water Pitcher',
      category: 'Handicrafts',
      description: 'natural red clay water dispenser',
      catalogPrices: const [900, 950, 1000, 1050, 1100],
    );

    expect(
      withCatalog.marketCeilingRupees,
      greaterThan(withoutCatalog.marketCeilingRupees),
    );
    expect(
      withCatalog.comparablesUsed,
      greaterThan(withoutCatalog.comparablesUsed),
    );
  });

  test('buyer budget caps the recommendation without going under cost', () {
    final recommendation = engine.recommend(
      name: 'Desi Jaggery',
      category: 'Food',
      description: 'organic gur handmade no chemicals',
      buyerBudgetPerUnit: 150,
    );

    expect(
      recommendation.recommendedRupees,
      greaterThanOrEqualTo(recommendation.breakEvenRupees),
    );
    expect(recommendation.recommendedRupees, lessThanOrEqualTo(150));
  });

  test('a budget below the cost floor never produces a loss-making price', () {
    final recommendation = engine.recommend(
      name: 'Brass Utensils',
      category: 'Metal Craft',
      description: 'traditional brass bartan heavy gauge',
      buyerBudgetPerUnit: 100,
    );

    expect(
      recommendation.recommendedRupees,
      greaterThanOrEqualTo(recommendation.breakEvenRupees),
    );
  });

  test('segment mapping keeps metal out of the generic craft segment', () {
    expect(PricingEngine.segmentFor('Metal Craft', ''), 'Manufacturing');
    expect(PricingEngine.segmentFor('Handloom & Textiles', ''), 'Handloom');
    expect(
      PricingEngine.segmentFor('Food & Homemade Products', ''),
      'Food',
    );
    expect(PricingEngine.segmentFor('Woodwork', ''), 'Handicraft');
  });
}
