import 'package:flutter/material.dart';
import '../models/pembacaan_sensor.dart';

class SensorCard extends StatelessWidget {
  final PembacaanSensor sensor;

  const SensorCard({
    super.key,
    required this.sensor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.sensors,
                  color: Colors.blue,
                  size: 30,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    sensor.jenisSensor,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${sensor.nilai.toStringAsFixed(1)}%',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Lokasi: ${sensor.lokasiPos}'),
            Text(
              'Waktu: ${sensor.waktu.toLocal()}',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
