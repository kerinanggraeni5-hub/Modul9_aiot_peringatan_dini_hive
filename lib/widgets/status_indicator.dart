import 'package:flutter/material.dart';

class StatusIndicator extends StatelessWidget {
  final String status;

  const StatusIndicator({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color warna;
    IconData ikon;

    switch (status) {
      case 'Siaga':
        warna = Colors.red;
        ikon = Icons.warning;
        break;
      case 'Waspada':
        warna = Colors.orange;
        ikon = Icons.error_outline;
        break;
      default:
        warna = Colors.green;
        ikon = Icons.check_circle_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: warna.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ikon, color: warna, size: 18),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              color: warna,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
