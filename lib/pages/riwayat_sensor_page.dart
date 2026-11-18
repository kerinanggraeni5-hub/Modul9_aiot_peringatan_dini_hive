import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/sensor_cubit.dart';
import '../models/pembacaan_sensor.dart';

class RiwayatSensorPage extends StatelessWidget {
  const RiwayatSensorPage({super.key});

  Future<void> editSensor(
    BuildContext context,
    PembacaanSensor sensor,
  ) async {
    final controller = TextEditingController(
      text: sensor.nilai.toString(),
    );

    final nilaiBaru = await showDialog<double>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Pembacaan Sensor'),
          content: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: const InputDecoration(
              labelText: 'Nilai sensor',
              suffixText: '%',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final nilai = double.tryParse(
                  controller.text.replaceAll(',', '.'),
                );

                if (nilai != null && nilai >= 0) {
                  Navigator.pop(dialogContext, nilai);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (nilaiBaru == null) return;

    final dataBaru = PembacaanSensor(
      id: sensor.id,
      jenisSensor: sensor.jenisSensor,
      nilai: nilaiBaru,
      lokasiPos: sensor.lokasiPos,
      waktu: sensor.waktu,
    );

    await context.read<SensorCubit>().ubahSensor(dataBaru);
  }

  Future<void> konfirmasiHapus(
    BuildContext context,
    PembacaanSensor sensor,
  ) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Data'),
          content: const Text(
            'Apakah kamu yakin ingin menghapus pembacaan sensor ini?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (konfirmasi == true) {
      await context.read<SensorCubit>().hapusSensor(sensor.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Sensor'),
      ),
      body: BlocBuilder<SensorCubit, SensorState>(
        builder: (context, state) {
          if (state.daftarSensor.isEmpty) {
            return const Center(
              child: Text('Belum ada riwayat pembacaan sensor.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: state.daftarSensor.length,
            itemBuilder: (context, index) {
              final sensor = state.daftarSensor[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.sensors),
                  ),
                  title: Text(sensor.jenisSensor),
                  subtitle: Text(
                    '${sensor.nilai.toStringAsFixed(1)}% • '
                    '${sensor.lokasiPos}\n'
                    '${sensor.waktu.toLocal()}',
                  ),
                  isThreeLine: true,
                  trailing: PopupMenuButton<String>(
                    onSelected: (pilihan) {
                      if (pilihan == 'edit') {
                        editSensor(context, sensor);
                      } else if (pilihan == 'hapus') {
                        konfirmasiHapus(context, sensor);
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      PopupMenuItem(
                        value: 'hapus',
                        child: Text('Hapus'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
