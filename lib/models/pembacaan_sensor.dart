import 'package:hive/hive.dart';

class PembacaanSensor {
  final String id;
  final String jenisSensor;
  final double nilai;
  final String lokasiPos;
  final DateTime waktu;

  PembacaanSensor({
    required this.id,
    required this.jenisSensor,
    required this.nilai,
    required this.lokasiPos,
    required this.waktu,
  });
}

class PembacaanSensorAdapter extends TypeAdapter<PembacaanSensor> {
  @override
  final int typeId = 0;

  @override
  PembacaanSensor read(BinaryReader reader) {
    final fields = <int, dynamic>{};

    final jumlahField = reader.readByte();
    for (var i = 0; i < jumlahField; i++) {
      final key = reader.readByte();
      fields[key] = reader.read();
    }

    return PembacaanSensor(
      id: fields[0] as String,
      jenisSensor: fields[1] as String,
      nilai: (fields[2] as num).toDouble(),
      lokasiPos: fields[3] as String,
      waktu: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PembacaanSensor obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.jenisSensor)
      ..writeByte(2)
      ..write(obj.nilai)
      ..writeByte(3)
      ..write(obj.lokasiPos)
      ..writeByte(4)
      ..write(obj.waktu);
  }
}
