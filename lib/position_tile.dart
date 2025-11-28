import 'package:flutter/material.dart';
import 'package:polymarket_analytics/position.dart';
import 'package:polymarket_analytics/constants.dart';

// --- Helper Widget: PnlDisplay ---
class PnlDisplay extends StatelessWidget {
  final double pnl;
  final bool isPercentage;

  const PnlDisplay({required this.pnl, this.isPercentage = false, super.key, required bool isLarge});

  String get _formattedValue {
    final sign = pnl >= 0 ? '+' : '-';
    final value = pnl.abs().toStringAsFixed(2);
    return isPercentage ? '$sign${pnl.abs().toStringAsFixed(1)}%' : '$sign\$$value';
  }

  Color get _pnlColor => pnl >= 0 ? accentGreen : accentRed;

  @override
  Widget build(BuildContext context) {
    return Text(
      _formattedValue,
      style: TextStyle(
        color: _pnlColor,
        fontWeight: FontWeight.bold,
        fontSize: isPercentage ? 14 : 16,
      ),
    );
  }
}

// --- Main Widget: PositionTile ---
class PositionTile extends StatelessWidget {
  final Position position;
  const PositionTile({required this.position, super.key});

  @override
  Widget build(BuildContext context) {
    final bool isPositive = position.unrealizedPnlDollar >= 0;
    final Color pnlColor = isPositive ? accentGreen : accentRed;

    return Card(
      color: cardSurface,
      margin: const EdgeInsets.only(bottom: 8, top: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        // Title: Market Title
        title: Text(
          position.marketTitle,
          style: const TextStyle(color: lightText, fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        // Subtitle: Outcome and Category
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Outcome: ${position.outcome}',
              style: TextStyle(color: lightText.withOpacity(0.8), fontSize: 13),
            ),
            Text(
              'Category: ${position.category}',
              style: TextStyle(color: brandBlue.withOpacity(0.8), fontSize: 11),
            ),
          ],
        ),
        // Trailing: P&L Value
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Using the assumed PnlDisplay widget for consistent formatting
            PnlDisplay(pnl: position.unrealizedPnlDollar, isLarge: false),
            Text(
              'P&L',
              style: TextStyle(color: lightText.withOpacity(0.6), fontSize: 10),
            ),
          ],
        ),
      ),
    );}}
