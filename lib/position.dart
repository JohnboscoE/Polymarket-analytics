import 'package:polymarket_analytics/sort_criteria.dart';
import 'package:polymarket_analytics/constants.dart';
import 'package:flutter/material.dart';

class Position {
  final String marketId;
  final String marketTitle;
  final String outcome;
  final double shares;
  final double costBasis;
  final double currentPrice;
  final DateTime resolutionDate;
  final String category;

  Position({
    required this.marketId,
    required this.marketTitle,
    required this.outcome,
    required this.shares,
    required this.costBasis,
    required this.currentPrice,
    required this.resolutionDate,
    required this.category,
  }) : assert(costBasis >= 0.0 && costBasis <= 1.0);

  // --- GETTERS REQUIRED BY UI COMPONENTS ---

  String get title => marketTitle;

  double get totalInvested => costBasis * shares;

  double get unrealizedPnlDollar => (currentPrice - costBasis) * shares;

  double get unrealizedPnl {
    return unrealizedPnlDollar;
  }

  // Calculated: P&L as a percentage of invested capital
  double get unrealizedPnlPercentage {
    final invested = totalInvested;
    if (invested == 0) return 0.0;
    return (unrealizedPnlDollar / invested) * 100;
  }

  Color get pnlColor => unrealizedPnlDollar >= 0 ? accentGreen : accentRed;

  // Factory constructor to create a Position object from a JSON map
  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      marketId: json['marketId'] as String,
      marketTitle: json['marketTitle'] as String,
      outcome: json['outcome'] as String,
      shares: (json['shares'] as num).toDouble(),
      costBasis: (json['costBasis'] as num).toDouble(),
      currentPrice: (json['currentPrice'] as num).toDouble(),
      resolutionDate: DateTime.parse(json['resolutionDate'] as String),
      category: json['category'] as String,
    );
  }
}
