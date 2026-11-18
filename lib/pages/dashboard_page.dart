import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/sensor_cubit.dart';
import '../models/pembacaan_sensor.dart';
import '../widgets/sensor_card.dart';
import '../widgets/status_indicator.dart';
import 'riwayat_sensor_page.dart';
import 'pengaturan_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Future<void> tambahSimulasi(BuildContext context) async {
    final random = Random();

    final data = PembacaanSensor(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      jenisSensor: 'Ketinggian Air',
      nilai: 20 + random.nextInt(81).toDouble(),
      lokasiPos: 'Pos Pantau A',
      waktu: DateTime.now(),
    );

    await context.read<SensorCubit>().tambahSensor(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AIoT Peringatan Dini'),
        actions: [
          BlocBuilder<SensorCubit, SensorState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Center(
                  child: StatusIndicator(status: state.status),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<SensorCubit, SensorState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final sensorTerbaru = state.daftarSensor.isEmpty
              ? null
              : state.daftarSensor.first;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dashboard Monitoring',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pantau kondisi lingkungan melalui pembacaan sensor.',
                ),
                const SizedBox(height: 20),

                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.analytics_outlined,
                          size: 40,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Total Pembacaan Sensor'),
                              Text(
                                '${state.daftarSensor.length} data',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                const Text(
                  'Pembacaan Terbaru',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                if (sensorTerbaru != null)
                  SensorCard(sensor: sensorTerbaru)
                else
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          'Belum ada data sensor. '
                          'Tekan tombol simulasi untuk menambahkan data.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => tambahSimulasi(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Simulasikan Pembacaan Sensor'),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RiwayatSensorPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.history),
                    label: const Text('Lihat Riwayat Sensor'),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PengaturanPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.settings),
                    label: const Text('Pengaturan Batas Status'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
