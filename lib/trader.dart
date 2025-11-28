import 'package:polymarket_analytics/constants.dart';
import 'package:flutter/material.dart';

class Trader {
  final String id;
  final String name;
  final double profitAndLoss;
  final double portfolioValue;
  final int totalMarkets;
  final List<String> topPositions;
  final double pnl;

  Trader( {
    required this.id,
    required this.name,
    required this.profitAndLoss,
    required this.portfolioValue,
    required this.totalMarkets,
    required this.topPositions,
    required this.pnl,
  });

  Color get pnlColor => profitAndLoss >= 0 ? accentGreen : accentRed;

  factory Trader.fromJson(Map<String, dynamic> json) {
    return Trader(
      id: json['id'] as String,
      name: json['name'] as String,
      profitAndLoss: (json['profitAndLoss'] as num).toDouble(),
      portfolioValue: (json['portfolioValue'] as num).toDouble(),
      totalMarkets: json['totalMarkets'] as int,
      topPositions: List<String>.from(json['topPositions'] as List), pnl: (json['pnl'] as num).toDouble(),
    );
  }
}
