import 'package:hive_flutter/hive_flutter.dart';
import '../models/pembacaan_sensor.dart';

class HiveHelper {
  HiveHelper._();

  static final HiveHelper instance = HiveHelper._();

  static const String namaBox = 'pembacaanSensorBox';

  Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(PembacaanSensorAdapter());
    }

    await Hive.openBox<PembacaanSensor>(namaBox);
  }

  Box<PembacaanSensor> get box =>
      Hive.box<PembacaanSensor>(namaBox);

  Future<void> tambahData(PembacaanSensor data) async {
    await box.put(data.id, data);
  }

  List<PembacaanSensor> ambilSemuaData() {
    final data = box.values.toList();

    data.sort((a, b) => b.waktu.compareTo(a.waktu));

    return data;
  }

  Future<void> ubahData(PembacaanSensor data) async {
    await box.put(data.id, data);
  }

  Future<void> hapusData(String id) async {
    await box.delete(id);
  }

  PembacaanSensor? ambilDataTerbaru() {
    final data = ambilSemuaData();

    if (data.isEmpty) return null;

    return data.first;
  }
}
