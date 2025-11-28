import 'package:flutter/material.dart';
import 'package:polymarket_analytics/constants.dart';

class PnlDisplay extends StatelessWidget {
  final double pnl;
  final bool isLarge;

  const PnlDisplay({super.key, required this.pnl, this.isLarge = false});

  @override
  Widget build(BuildContext context) {
    final color = pnl >= 0 ? accentGreen : accentRed;
    final sign = pnl >= 0 ? '+' : '';

    return Text(
      '$sign\$${pnl.abs().toStringAsFixed(2)}',
      style: TextStyle(
        color: color,
        fontSize: isLarge ? 24 : 16,
        fontWeight: isLarge ? FontWeight.bold : FontWeight.w600,
      ),
    );
  }
}
