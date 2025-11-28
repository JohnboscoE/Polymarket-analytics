import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../analytic_provider.dart';
import '../constants.dart';
import 'package:polymarket_analytics/pnl_display.dart';


class TopTradersScreen extends StatelessWidget {
  const TopTradersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AnalyticsProvider>();

    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        title: const Text('👑 Top Traders', style: TextStyle(color: lightText)),
        backgroundColor: cardSurface,
      ),
      body: provider.topTraders.isEmpty
          ? const Center(child: Text('No top traders found.', style: TextStyle(color: lightText)))
          : ListView.builder(
        itemCount: provider.topTraders.length,
        itemBuilder: (context, index) {
          final trader = provider.topTraders[index];
          return ListTile(
            leading: const Icon(Icons.person, color: brandBlue),
            title: Text(trader.name, style: const TextStyle(color: lightText)),
            subtitle: Text('P&L: \$${trader.pnl.toStringAsFixed(2)}', style: TextStyle(color: trader.pnl >= 0 ? accentGreen : accentRed)),
          );
        },
      ),
    );
  }
}