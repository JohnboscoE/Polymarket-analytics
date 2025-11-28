import 'package:polymarket_analytics/constants.dart';

class MarketTrending {
  final String id;
  final String title;
  final String category;
  final double volume24h;
  final double liquidityInflow;
  final double volume;

  MarketTrending({
    required this.id,
    required this.title,
    required this.category,
    required this.volume24h,
    required this.liquidityInflow,
    required this.volume,
  });


  String get formattedInflow {
    if (liquidityInflow > 1000000) {
      return '\$${(liquidityInflow / 1000000).toStringAsFixed(1)}M';
    } else if (liquidityInflow > 1000) {
      return '\$${(liquidityInflow / 1000).toStringAsFixed(0)}K';
    }
    return '\$${liquidityInflow.toStringAsFixed(0)}';
  }



  factory MarketTrending.fromJson(Map<String, dynamic> json) {

    final String title = json['question'] as String? ?? 'Unknown Market';

    final double volume = (json['volumeNum'] as num?)?.toDouble() ?? 0.0;

    final double volume24h = (json['volume24hr'] as num?)?.toDouble() ?? 0.0;

    final double liquidity = (json['liquidityNum'] as num?)?.toDouble() ?? 0.0;

    final String category = json['category'] as String? ?? 'N/A';

    final String id = json['id'] as String? ?? '';


    return MarketTrending(
      id: id,
      title: title,
      category: category,
      volume24h: volume24h,
      liquidityInflow: liquidity,
      volume: volume,
    );
  }
}
