import 'package:flutter/material.dart';
import 'package:polymarket_analytics/position_tile.dart' hide PnlDisplay;
import 'package:provider/provider.dart';
import 'package:polymarket_analytics/analytic_provider.dart';
import 'package:polymarket_analytics/sort_button.dart';
import 'package:polymarket_analytics/constants.dart';
import 'package:polymarket_analytics/position.dart';
import 'package:polymarket_analytics/wallet_input_screen.dart'; // REQUIRED: For initial input
import 'package:polymarket_analytics/pnl_display.dart'; // REQUIRED: For P&L consistency

// This is the default portfolio view
class AnalyticsDashboard extends StatelessWidget {
  const AnalyticsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AnalyticsProvider>();

    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        title: const Text('My Portfolio Dashboard', style: TextStyle(color: lightText)),
        backgroundColor: cardSurface,
        actions: [
          if (provider.walletAddress != null && provider.walletAddress!.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.refresh, color: lightText),
              tooltip: 'Enter new wallet address',
              onPressed: () {
                provider.setWalletAddress('');
              },
            ),
        ],
      ),
      //  Conditional Screen Logic
      body: provider.walletAddress == null || provider.walletAddress!.isEmpty
          ? const WalletInputScreen() // Show input screen if no address is set
          : provider.isLoading
          ? const Center(child: CircularProgressIndicator(color: brandBlue))
          : const _PortfolioContent(), // Show dashboard content if loaded
    );
  }
}

// Widget to hold the actual portfolio content
class _PortfolioContent extends StatelessWidget {
  const _PortfolioContent();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AnalyticsProvider>();
    // Check if positions are empty after loading
    if (provider.sortedPositions.isEmpty) {
      return Center(
        child: Text(
          'No open positions found for this wallet.',
          style: TextStyle(color: lightText.withOpacity(0.7), fontSize: 16),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header and PNL Summary
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Total Unrealized P&L:',
            style: TextStyle(color: lightText, fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          // Use PnlDisplay for consistent formatting and color
          child: PnlDisplay(pnl: provider.totalPortfolioPnl, isLarge: true),
        ),

        // Sort and Markets Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Open Positions',
                style: TextStyle(color: lightText, fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SortButton(
                currentCriteria: provider.sortCriteria,
                onSelected: provider.setSortCriteria,
              ),
            ],
          ),
        ),

        // Position List
        Expanded(
          child: ListView.builder(
            itemCount: provider.sortedPositions.length,
            itemBuilder: (context, index) {
              final position = provider.sortedPositions[index];
              // Added horizontal padding for better spacing
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: PositionTile(position: position),
              );
            },
          ),
        ),
      ],
    );
  }
}


// --- Updated PositionTile with improved structure and PnlDisplay usage ---

