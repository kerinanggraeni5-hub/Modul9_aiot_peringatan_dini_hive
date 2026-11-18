import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/sensor_cubit.dart';

class PengaturanPage extends StatefulWidget {
  const PengaturanPage({super.key});

  @override
  State<PengaturanPage> createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController waspadaController;
  late TextEditingController siagaController;

  @override
  void initState() {
    super.initState();

    final state = context.read<SensorCubit>().state;

    waspadaController = TextEditingController(
      text: state.batasWaspada.toString(),
    );

    siagaController = TextEditingController(
      text: state.batasSiaga.toString(),
    );
  }

  @override
  void dispose() {
    waspadaController.dispose();
    siagaController.dispose();
    super.dispose();
  }

  Future<void> simpanPengaturan() async {
    if (!formKey.currentState!.validate()) return;

    final waspada = double.parse(
      waspadaController.text.replaceAll(',', '.'),
    );

    final siaga = double.parse(
      siagaController.text.replaceAll(',', '.'),
    );

    if (waspada >= siaga) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Batas Waspada harus lebih kecil dari batas Siaga.',
          ),
        ),
      );
      return;
    }

    await context.read<SensorCubit>().ubahBatas(
      waspada: waspada,
      siaga: siaga,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pengaturan berhasil disimpan.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Sensor'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.tune,
                size: 55,
                color: Colors.blue,
              ),
              const SizedBox(height: 12),
              const Text(
                'Pengaturan Batas Status Sensor',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Atur nilai ambang batas untuk menentukan '
                'kondisi lingkungan berdasarkan pembacaan sensor.',
              ),
              const SizedBox(height: 25),

              TextFormField(
                controller: waspadaController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Batas Waspada',
                  suffixText: '%',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.warning_amber),
                ),
                validator: (value) {
                  final angka = double.tryParse(
                    (value ?? '').replaceAll(',', '.'),
                  );

                  if (angka == null || angka < 0) {
                    return 'Masukkan angka yang valid.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 18),

              TextFormField(
                controller: siagaController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Batas Siaga',
                  suffixText: '%',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.error),
                ),
                validator: (value) {
                  final angka = double.tryParse(
                    (value ?? '').replaceAll(',', '.'),
                  );

                  if (angka == null || angka < 0) {
                    return 'Masukkan angka yang valid.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: simpanPengaturan,
                  icon: const Icon(Icons.save),
                  label: const Text('Simpan Pengaturan'),
                ),
              ),

              const SizedBox(height: 20),

              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Keterangan Status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text('Aman: nilai di bawah batas Waspada.'),
                      Text('Waspada: nilai mencapai batas Waspada.'),
                      Text('Siaga: nilai mencapai batas Siaga.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
