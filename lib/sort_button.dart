import 'package:flutter/material.dart';
import 'package:polymarket_analytics/sort_criteria.dart';
import 'constants.dart';

class SortButton extends StatelessWidget {
  final SortCriteria currentCriteria;
  final Function(SortCriteria) onSelected;


  const SortButton({
    required this.currentCriteria,
    required this.onSelected,
    super.key, // Added super.key for best practice
  });

  String _getLabel(SortCriteria criteria) {
    switch (criteria) {
      case SortCriteria.resolutionDate:
        return 'Closest Resolution';
      case SortCriteria.pnlValue:
        return 'Highest P&L';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortCriteria>(
      color: cardSurface,



      onSelected: onSelected,
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<SortCriteria>>[
          PopupMenuItem<SortCriteria>(
            value: SortCriteria.resolutionDate,
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: currentCriteria == SortCriteria.resolutionDate ? brandBlue : lightText.withOpacity(0.7)),
                const SizedBox(width: 8),
                Text(
                  'Sort by Resolution Date',
                  style: TextStyle(
                      color: currentCriteria == SortCriteria.resolutionDate ? brandBlue : lightText,
                      fontWeight: currentCriteria == SortCriteria.resolutionDate ? FontWeight.bold : FontWeight.normal
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem<SortCriteria>(
            value: SortCriteria.pnlValue,
            child: Row(
              children: [
                Icon(Icons.trending_up, color: currentCriteria == SortCriteria.pnlValue ? brandBlue : lightText.withOpacity(0.7)),
                const SizedBox(width: 8),
                Text(
                  'Sort by P&L Value',
                  style: TextStyle(
                      color: currentCriteria == SortCriteria.pnlValue ? brandBlue : lightText,
                      fontWeight: currentCriteria == SortCriteria.pnlValue ? FontWeight.bold : FontWeight.normal
                  ),
                ),
              ],
            ),
          ),
        ];
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: cardSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: brandBlue.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Text(
              _getLabel(currentCriteria),
              style: const TextStyle(color: brandBlue, fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, color: brandBlue, size: 20),
          ],
        ),
      ),
    );
  }
}
