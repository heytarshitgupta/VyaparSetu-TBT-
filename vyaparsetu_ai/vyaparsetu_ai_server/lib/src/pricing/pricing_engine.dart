import 'dart:convert';
import 'dart:math' as math;

import 'pricing_dataset.dart';

/// A transparent price recommendation for one listing.
///
/// Every number is explainable: the cost floor comes from a matched artisan
/// cost profile plus the real WPI index, and the market band comes from
/// comparable prices (benchmark rows plus live catalogue listings).
class PriceRecommendation {
  const PriceRecommendation({
    required this.breakEvenRupees,
    required this.recommendedRupees,
    required this.lowRupees,
    required this.highRupees,
    required this.marketCeilingRupees,
    required this.tier,
    required this.confidence,
    required this.comparablesUsed,
    required this.matchedProfile,
    required this.wpiMultiplier,
    required this.wpiPeriod,
    required this.reasons,
  });

  final double breakEvenRupees;
  final double recommendedRupees;
  final double lowRupees;
  final double highRupees;
  final double marketCeilingRupees;
  final String tier;

  /// `high`, `medium` or `low`, based on how many comparables backed the band.
  final String confidence;
  final int comparablesUsed;
  final String matchedProfile;
  final double wpiMultiplier;
  final String wpiPeriod;
  final List<String> reasons;

  Map<String, String> toJsonMap(String productId) => {
    'product_id': productId,
    'pricing_tier': tier,
    'break_even_floor': breakEvenRupees.toStringAsFixed(2),
    'recommended_price': recommendedRupees.toStringAsFixed(2),
    'market_ceiling': marketCeilingRupees.toStringAsFixed(2),
    'price_low': lowRupees.toStringAsFixed(2),
    'price_high': highRupees.toStringAsFixed(2),
    'confidence': confidence,
    'comparables_used': '$comparablesUsed',
    'matched_profile': matchedProfile,
    'wpi_multiplier': wpiMultiplier.toStringAsFixed(4),
    'wpi_period': wpiPeriod,
    'ai_guidance': reasons.join(' '),
  };
}

class _CostProfile {
  const _CostProfile({
    required this.name,
    required this.segment,
    required this.wpiGroup,
    required this.baseMaterialCost,
    required this.materialQty,
    required this.laborHours,
    required this.hourlyWage,
    required this.packaging,
    required this.targetMargin,
  });

  final String name;
  final String segment;
  final String wpiGroup;
  final double baseMaterialCost;
  final double materialQty;
  final double laborHours;
  final double hourlyWage;
  final double packaging;
  final double targetMargin;
}

class _Comparable {
  const _Comparable({
    required this.tokens,
    required this.segment,
    required this.price,
  });

  final Set<String> tokens;
  final String segment;
  final double price;
}

class _Band {
  const _Band({
    required this.centre,
    required this.spread,
    required this.count,
  });

  final double centre;
  final double spread;
  final int count;
}

/// Comparable-based pricing engine backed by `pricing_dataset.dart`.
class PricingEngine {
  PricingEngine._(this._profiles, this._comparables, this._wpi, this.wpiPeriod);

  static final PricingEngine instance = PricingEngine._parse();

  /// Order matters: metal must be checked before the generic craft keyword.
  static const _segmentRules = <String, List<String>>{
    'Food': [
      'food',
      'homemade',
      'spice',
      'pickle',
      'honey',
      'oil',
      'jaggery',
      'gur',
    ],
    'Manufacturing': [
      'metal',
      'brass',
      'copper',
      'bronze',
      'dhokra',
      'machine',
      'tool',
      'steel',
      'iron',
    ],
    'Handloom': [
      'handloom',
      'textile',
      'cloth',
      'embroidery',
      'apparel',
      'leather',
      'silk',
      'khadi',
      'pashmina',
      'shawl',
    ],
    'Handicraft': [
      'handicraft',
      'wood',
      'pottery',
      'ceramic',
      'terracotta',
      'clay',
      'decor',
      'craft',
      'jute',
      'bamboo',
    ],
  };

  static final _tokenPattern = RegExp(r'\b\w\w+\b');

  final List<_CostProfile> _profiles;
  final List<_Comparable> _comparables;
  final Map<String, double> _wpi;
  final String wpiPeriod;

  static PricingEngine _parse() {
    final data = jsonDecode(pricingDatasetJson) as Map<String, dynamic>;

    final profiles = <_CostProfile>[];
    for (final raw in (data['cost_profiles'] as List).cast<Map>()) {
      final name = raw['name'] as String;
      profiles.add(
        _CostProfile(
          name: name,
          segment: _segmentFor(name, name),
          wpiGroup: raw['wpi_group'] as String,
          baseMaterialCost: (raw['base_material_cost'] as num).toDouble(),
          materialQty: (raw['material_qty'] as num).toDouble(),
          laborHours: (raw['labor_hours'] as num).toDouble(),
          hourlyWage: (raw['hourly_wage'] as num).toDouble(),
          packaging: (raw['packaging'] as num).toDouble(),
          targetMargin: (raw['target_margin'] as num).toDouble(),
        ),
      );
    }

    final comparables = <_Comparable>[];
    for (final raw in (data['comparables'] as List).cast<Map>()) {
      final text = raw['text'] as String;
      comparables.add(
        _Comparable(
          tokens: _tokensOf(text),
          segment: raw['segment'] as String,
          price: (raw['price'] as num).toDouble(),
        ),
      );
    }

    final wpi = <String, double>{};
    for (final entry in (data['wpi'] as Map).entries) {
      wpi[entry.key as String] = (entry.value as num).toDouble();
    }

    return PricingEngine._(
      profiles,
      comparables,
      wpi,
      (data['wpi_period'] as String?) ?? 'unknown',
    );
  }

  /// Returns a recommendation in rupees.
  ///
  /// [catalogPrices] are live listing prices in rupees for the same category;
  /// they let the band track the real marketplace instead of only the
  /// illustrative benchmark.
  PriceRecommendation recommend({
    required String name,
    required String category,
    String description = '',
    bool isBulk = false,
    List<double> catalogPrices = const [],
    double? buyerBudgetPerUnit,
  }) {
    final text = '$name $category $description';
    final tokens = _tokensOf(text);
    final segment = _segmentFor(
      category,
      description.isEmpty ? name : description,
    );
    final profile = _bestProfile(tokens, segment);

    final wpiMultiplier = _wpiFor(profile.wpiGroup);
    final materialCost =
        profile.baseMaterialCost * profile.materialQty * wpiMultiplier;
    final laborCost = profile.laborHours * profile.hourlyWage;
    final breakEven = materialCost + laborCost + profile.packaging;
    final desiredFloor = breakEven * (1 + profile.targetMargin);

    final band = _marketBand(tokens, segment, catalogPrices);
    final ceiling = band.centre > 0 ? band.centre : desiredFloor * 1.35;
    final comparablesUsed = band.count;

    double recommended;
    String tier;
    final reasons = <String>[];

    final hardFloor = breakEven * 1.02;

    if (isBulk) {
      recommended = math.max(breakEven * 1.10, ceiling * 0.80);
      tier = 'B2B Wholesale Tier';
      reasons.add(
        'Bulk tier: margin held just above the break-even floor so a large '
        'order stays profitable.',
      );
    } else {
      recommended = desiredFloor;
      tier = 'B2C Retail Tier';
      reasons.add(
        'Retail tier: cost floor plus the target margin for this craft.',
      );
    }

    if (ceiling >= hardFloor) {
      recommended = recommended.clamp(hardFloor, ceiling);
    } else {
      // The market band sits below what it costs to make. Do not recommend a
      // loss-making price; flag it instead.
      recommended = math.max(recommended, hardFloor);
      reasons.add(
        'Comparable prices are below your cost floor. Position this as a '
        'premium or niche listing instead of competing on price.',
      );
    }

    if (buyerBudgetPerUnit != null && buyerBudgetPerUnit > 0) {
      final budgetCeiling = math.max(buyerBudgetPerUnit, hardFloor);
      if (recommended > budgetCeiling) {
        recommended = budgetCeiling;
        reasons.add(
          'Capped at the open buyer budget of '
          '₹${_rupees(buyerBudgetPerUnit)} per unit.',
        );
      }
    }

    final low = math.max(breakEven, recommended * 0.92);
    final high = math.max(recommended, math.min(ceiling, recommended * 1.12));

    reasons.insert(
      0,
      'Cost floor ₹${_rupees(breakEven)}: material '
      '₹${_rupees(materialCost)} (WPI ${wpiMultiplier.toStringAsFixed(2)}x), '
      'labour ₹${_rupees(laborCost)}, packaging '
      '₹${_rupees(profile.packaging)}.',
    );
    reasons.insert(1, 'Matched cost profile: ${profile.name}.');
    reasons.add(
      comparablesUsed > 0
          ? 'Market band from $comparablesUsed comparable '
                '${comparablesUsed == 1 ? 'listing' : 'listings'} '
                '(${band.spread > 0.35 ? 'wide' : 'tight'} spread).'
          : 'No close comparables yet, so the band uses a conservative '
                'markup over your cost floor.',
    );

    return PriceRecommendation(
      breakEvenRupees: breakEven,
      recommendedRupees: recommended,
      lowRupees: low,
      highRupees: high,
      marketCeilingRupees: ceiling,
      tier: tier,
      confidence: _confidence(comparablesUsed, band.spread),
      comparablesUsed: comparablesUsed,
      matchedProfile: profile.name,
      wpiMultiplier: wpiMultiplier,
      wpiPeriod: wpiPeriod,
      reasons: reasons,
    );
  }

  /// Public mapping used by the endpoint to group live listings by segment.
  static String segmentFor(String category, String description) =>
      _segmentFor(category, description);

  _CostProfile _bestProfile(Set<String> tokens, String segment) {
    _CostProfile? best;
    var bestScore = 0;
    var bestCoverage = 0.0;

    for (final profile in _profiles) {
      if (profile.segment != segment) continue;
      final profileTokens = _tokensOf(profile.name);
      final shared = profileTokens.intersection(tokens).length;
      if (shared == 0) continue;
      final coverage = shared / profileTokens.length;
      if (shared > bestScore ||
          (shared == bestScore && coverage > bestCoverage)) {
        best = profile;
        bestScore = shared;
        bestCoverage = coverage;
      }
    }

    if (best != null) return best;

    // Nothing matched inside the segment: fall back to a segment default.
    final defaults = _defaults[segment] ?? _defaults['Handicraft']!;
    return _CostProfile(
      name: '${segment.toLowerCase()} default profile',
      segment: segment,
      wpiGroup: defaults.wpiGroup,
      baseMaterialCost: defaults.baseMaterialCost,
      materialQty: defaults.materialQty,
      laborHours: defaults.laborHours,
      hourlyWage: defaults.hourlyWage,
      packaging: defaults.packaging,
      targetMargin: defaults.targetMargin,
    );
  }

  static const _defaults = <String, _CostProfile>{
    'Food': _CostProfile(
      name: 'food default profile',
      segment: 'Food',
      wpiGroup: 'Manufacture Of Food Products',
      baseMaterialCost: 60,
      materialQty: 1.0,
      laborHours: 1.0,
      hourlyWage: 45,
      packaging: 20,
      targetMargin: 0.25,
    ),
    'Handloom': _CostProfile(
      name: 'handloom default profile',
      segment: 'Handloom',
      wpiGroup: 'Manufacture Of Textiles',
      baseMaterialCost: 180,
      materialQty: 1.5,
      laborHours: 3.5,
      hourlyWage: 55,
      packaging: 30,
      targetMargin: 0.30,
    ),
    'Handicraft': _CostProfile(
      name: 'handicraft default profile',
      segment: 'Handicraft',
      wpiGroup: 'Manufacture Of Other Non-Metallic Mineral Products',
      baseMaterialCost: 150,
      materialQty: 1.5,
      laborHours: 3.0,
      hourlyWage: 50,
      packaging: 30,
      targetMargin: 0.30,
    ),
    'Manufacturing': _CostProfile(
      name: 'metal default profile',
      segment: 'Manufacturing',
      wpiGroup:
          'Manufacture Of Fabricated Metal Products, Except Machinery And Equipment',
      baseMaterialCost: 200,
      materialQty: 2.0,
      laborHours: 2.0,
      hourlyWage: 75,
      packaging: 15,
      targetMargin: 0.20,
    ),
  };

  _Band _marketBand(
    Set<String> tokens,
    String segment,
    List<double> catalogPrices,
  ) {
    final scored = <({double similarity, double price})>[];
    for (final comparable in _comparables) {
      if (comparable.segment != segment) continue;
      final similarity = _cosine(tokens, comparable.tokens);
      if (similarity <= 0) continue;
      scored.add((similarity: similarity, price: comparable.price));
    }
    scored.sort((a, b) => b.similarity.compareTo(a.similarity));
    final top = scored.take(5).toList();

    double benchmarkCentre = 0;
    double benchmarkSpread = 0;
    if (top.isNotEmpty) {
      var weightSum = 0.0;
      var weightedPrice = 0.0;
      for (final item in top) {
        final weight = math.max(item.similarity, 0.05);
        weightSum += weight;
        weightedPrice += weight * item.price;
      }
      benchmarkCentre = weightedPrice / weightSum;
      var variance = 0.0;
      for (final item in top) {
        final weight = math.max(item.similarity, 0.05);
        variance += weight * math.pow(item.price - benchmarkCentre, 2);
      }
      variance /= weightSum;
      benchmarkSpread = math.sqrt(variance) / benchmarkCentre;
    }

    if (catalogPrices.isEmpty) {
      return _Band(
        centre: benchmarkCentre,
        spread: benchmarkSpread,
        count: top.length,
      );
    }

    final sorted = [...catalogPrices]..sort();
    final liveMedian = _median(sorted);
    final liveSpread = sorted.length > 1
        ? (sorted.last - sorted.first) / liveMedian
        : 0.0;

    if (top.isEmpty) {
      return _Band(
        centre: liveMedian,
        spread: liveSpread,
        count: sorted.length,
      );
    }

    // Trust live listings more as their count grows; until then blend.
    final liveWeight = sorted.length >= 5 ? 0.6 : 0.5;
    final centre = liveWeight * liveMedian + (1 - liveWeight) * benchmarkCentre;
    final spread = math.max(liveSpread, benchmarkSpread);
    return _Band(
      centre: centre,
      spread: spread,
      count: top.length + sorted.length,
    );
  }

  double _wpiFor(String group) {
    final exact = _wpi[group];
    if (exact != null) return exact;

    for (final entry in _wpi.entries) {
      if (entry.key.startsWith(group) || group.startsWith(entry.key)) {
        return entry.value;
      }
    }
    for (final entry in _wpi.entries) {
      final short = group.split(' ').take(3).join(' ');
      if (entry.key.startsWith(short)) return entry.value;
    }
    return _wpi['All Commodities'] ?? 1.05;
  }

  String _confidence(int comparables, double spread) {
    var level = comparables >= 8
        ? 2
        : comparables >= 3
        ? 1
        : 0;
    if (spread > 0.45 && level > 0) level -= 1;
    return switch (level) {
      2 => 'high',
      1 => 'medium',
      _ => 'low',
    };
  }

  static String _segmentFor(String category, String description) {
    final haystack = '$category $description'.toLowerCase();
    for (final entry in _segmentRules.entries) {
      for (final keyword in entry.value) {
        if (haystack.contains(keyword)) return entry.key;
      }
    }
    return 'Handicraft';
  }

  static Set<String> _tokensOf(String text) =>
      _tokenPattern.allMatches(text.toLowerCase()).map((m) => m[0]!).toSet();

  static double _cosine(Set<String> a, Set<String> b) {
    if (a.isEmpty || b.isEmpty) return 0;
    var shared = 0;
    for (final token in a) {
      if (b.contains(token)) shared++;
    }
    if (shared == 0) return 0;
    return shared / math.sqrt(a.length * b.length);
  }

  static double _median(List<double> sorted) {
    final middle = sorted.length ~/ 2;
    if (sorted.length.isOdd) return sorted[middle];
    return (sorted[middle - 1] + sorted[middle]) / 2;
  }

  static String _rupees(double value) {
    final rounded = value.roundToDouble();
    return value == rounded
        ? rounded.toStringAsFixed(0)
        : value.toStringAsFixed(2);
  }
}
