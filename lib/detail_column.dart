import 'package:flutter/cupertino.dart';

class _DetailColumn extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  static const Color lightText = Color(0xFFEEEEEE);


  const _DetailColumn({
    required this.title,
    required this.value,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: lightText.withOpacity(0.6),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}