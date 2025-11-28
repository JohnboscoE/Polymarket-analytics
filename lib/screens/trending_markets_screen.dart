import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../analytic_provider.dart';
import '../constants.dart';


class TrendingMarketsScreen extends StatelessWidget {
  const TrendingMarketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AnalyticsProvider>();

    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        title: const Text('🔥 Trending Markets', style: TextStyle(color: lightText)),
        backgroundColor: cardSurface,
      ),
      body: provider.trendingMarkets.isEmpty
          ? const Center(child: Text('No trending markets found.', style: TextStyle(color: lightText)))
          : ListView.builder(
        itemCount: provider.trendingMarkets.length,
        itemBuilder: (context, index) {
          final market = provider.trendingMarkets[index];
          return ListTile(
            title: Text(market.title, style: const TextStyle(color: lightText)),
            subtitle: Text('Volume: \$${market.volume.toStringAsFixed(0)}', style: TextStyle(color: lightText.withOpacity(0.7))),
          );
        },
      ),
    );
  }
}