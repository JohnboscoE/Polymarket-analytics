import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:polymarket_analytics/analytic_provider.dart';
import 'package:polymarket_analytics/constants.dart';
import 'package:polymarket_analytics/trader.dart';
import 'package:polymarket_analytics/market_trending.dart';

class MarketAnalysisScreen extends StatelessWidget {
  const MarketAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We wrap this with DefaultTabController to manage the tabs state
    return const DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: darkBackground,
        appBar: MarketAnalysisAppBar(),
        body: TabBarView(
          children: [
            // Tab 1: Highest Profitable Traders
            TopTradersList(),

            // Tab 2: Top Trending Markets / High Liquidity
            TrendingMarketsList(),
          ],
        ),
      ),
    );
  }
}

// --- App Bar Component ---

class MarketAnalysisAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MarketAnalysisAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(100.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: cardSurface,
      elevation: 4,
      title: const Text(
        'Market Insights',
        style: TextStyle(
          color: lightText,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottom: TabBar(
        indicatorColor: brandBlue,
        labelColor: brandBlue,
        unselectedLabelColor: lightText.withOpacity(0.7),
        indicatorSize: TabBarIndicatorSize.label,
        tabs: const [
          Tab(text: 'Top Traders'),
          Tab(text: 'Trending Markets'),
        ],
      ),
    );
  }
}

// --- Top Traders List Component ---

class TopTradersList extends StatelessWidget {
  const TopTradersList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AnalyticsProvider>();

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator(color: brandBlue));
    }

    return ListView.builder(
      itemCount: provider.topTraders.length,
      itemBuilder: (context, index) {
        final trader = provider.topTraders[index];
        return TraderTile(trader: trader, rank: index + 1);
      },
    );
  }
}

// --- Trending Markets List Component ---

class TrendingMarketsList extends StatelessWidget {
  const TrendingMarketsList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AnalyticsProvider>();

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator(color: brandBlue));
    }

    // Sort markets to explicitly show High Liquidity Inflow first (as requested)
    final sortedMarkets = List<MarketTrending>.from(provider.trendingMarkets)
      ..sort((a, b) => b.liquidityInflow.compareTo(a.liquidityInflow));

    return ListView.builder(
      itemCount: sortedMarkets.length,
      itemBuilder: (context, index) {
        final market = sortedMarkets[index];
        return MarketTrendingTile(market: market);
      },
    );
  }
}

// --- Trader Tile Component ---

class TraderTile extends StatelessWidget {
  final Trader trader;
  final int rank;

  const TraderTile({required this.trader, required this.rank, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardSurface,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Rank Badge
                CircleAvatar(
                  backgroundColor: brandBlue,
                  radius: 12,
                  child: Text(
                    '$rank',
                    style: const TextStyle(color: lightText, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                // Name
                Text(
                  trader.name,
                  style: const TextStyle(
                    color: lightText,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                // Portfolio Value
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${trader.portfolioValue.toStringAsFixed(0)}',
                      style: const TextStyle(color: lightText, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const Text(
                      'Portfolio Value',
                      style: TextStyle(color: lightText, fontSize: 10),
                    ),
                  ],
                )
              ],
            ),
            const Divider(color: brandBlue),
            // P&L and Markets
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${trader.profitAndLoss.toStringAsFixed(2)}',
                      style: TextStyle(color: trader.pnlColor, fontWeight: FontWeight.bold),
                    ),
                    const Text('Total P&L', style: TextStyle(color: lightText, fontSize: 10)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${trader.totalMarkets} Markets',
                      style: const TextStyle(color: lightText, fontWeight: FontWeight.bold),
                    ),
                    const Text('Total Markets', style: TextStyle(color: lightText, fontSize: 10)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Top Positions (brief display)
            Text(
              'Top Markets: ${trader.topPositions.join(', ')}',
              style: TextStyle(color: lightText.withOpacity(0.7), fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}


// --- Market Trending Tile Component ---

class MarketTrendingTile extends StatelessWidget {
  final MarketTrending market;

  const MarketTrendingTile({required this.market, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardSurface,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: Icon(Icons.trending_up, color: brandBlue),
        title: Text(
          market.title,
          style: const TextStyle(color: lightText, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              market.category,
              style: TextStyle(color: lightText.withOpacity(0.7), fontSize: 12),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.monetization_on, color: accentGreen, size: 14),
                const SizedBox(width: 4),
                Text(
                  'Liquidity Inflow: ${market.formattedInflow}',
                  style: const TextStyle(color: accentGreen, fontSize: 12),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.show_chart, color: lightText, size: 14),
                const SizedBox(width: 4),
                Text(
                  '24h Volume: \$${(market.volume24h / 1000).toStringAsFixed(0)}K',
                  style: TextStyle(color: lightText.withOpacity(0.9), fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: lightText, size: 16),
        onTap: () {
          // Implement navigation to market detail screen
          debugPrint('Tapped on market: ${market.title}');
        },
      ),
    );
  }
}
