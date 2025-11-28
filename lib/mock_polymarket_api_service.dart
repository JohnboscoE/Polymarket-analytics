import 'dart:math';

import 'package:polymarket_analytics/position.dart';

class MockPolymarketApiService {
  static final Random _random = Random();

  // Helper function to generate mock positions
  static List<Position> getMockPositions() {
    final now = DateTime.now();

    final List<Position> basePositions = [
      Position(
        marketId: 'm1',
        marketTitle: 'Will Trump win the 2024 US Election?',
        category: 'Politics',
        outcome: 'Yes',
        shares: 500,
        costBasis: 0.45,
        resolutionDate: now.add(const Duration(days: 45)),
        currentPrice: 0.62,
      ),
      Position(
        marketId: 'm2',
        marketTitle: 'Will Ethereum hit \$10,000 in Q4 2025?',
        category: 'Crypto',
        outcome: 'No',
        shares: 1500,
        costBasis: 0.88,
        resolutionDate: now.add(const Duration(days: 90)),
        currentPrice: 0.75, // Loss
      ),
      Position(
        marketId: 'm3',
        marketTitle: 'Will the Chiefs win the Super Bowl LXI?',
        category: 'Sports',
        outcome: 'Yes',
        shares: 800,
        costBasis: 0.15,
        resolutionDate: now.add(const Duration(days: 150)),
        currentPrice: 0.18, // Small Profit
      ),
      Position(
        marketId: 'm4',
        marketTitle: 'Will the Fed cut interest rates by Dec 2025?',
        category: 'Finance',
        outcome: 'No',
        shares: 200,
        costBasis: 0.22,
        resolutionDate: now.add(const Duration(days: 20)),
        currentPrice: 0.28, // Profit
      ),
      Position(
        marketId: 'm5',
        marketTitle: 'Will a new AI model surpass GPT-5 by March 2026?',
        category: 'Tech',
        outcome: 'Yes',
        shares: 1000,
        costBasis: 0.95,
        resolutionDate: now.add(const Duration(days: 180)),
        currentPrice: 0.80, // Loss
      ),
    ];

    return basePositions.map((p) {
      final priceVariance = (_random.nextDouble() - 0.5) * 0.15; // +/- 7.5 cents
      return Position(
        // Pass original data
        marketId: p.marketId,
        marketTitle: p.marketTitle,
        category: p.category,
        outcome: p.outcome,
        shares: p.shares,
        costBasis: p.costBasis,
        resolutionDate: p.resolutionDate,
        currentPrice: (p.costBasis + priceVariance).clamp(0.01, 1.0),
      );
    }).toList();
  }
}
