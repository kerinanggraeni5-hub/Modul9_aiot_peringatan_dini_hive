import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/pembacaan_sensor.dart';
import '../helpers/hive_helper.dart';
import '../helpers/pengaturan_helper.dart';

class SensorState extends Equatable {
  final List<PembacaanSensor> daftarSensor;
  final double batasWaspada;
  final double batasSiaga;
  final bool loading;

  const SensorState({
    this.daftarSensor = const [],
    this.batasWaspada = 50,
    this.batasSiaga = 80,
    this.loading = false,
  });

  String get status {
    if (daftarSensor.isEmpty) return 'Aman';

    final nilai = daftarSensor.first.nilai;

    if (nilai >= batasSiaga) return 'Siaga';
    if (nilai >= batasWaspada) return 'Waspada';

    return 'Aman';
  }

  SensorState copyWith({
    List<PembacaanSensor>? daftarSensor,
    double? batasWaspada,
    double? batasSiaga,
    bool? loading,
  }) {
    return SensorState(
      daftarSensor: daftarSensor ?? this.daftarSensor,
      batasWaspada: batasWaspada ?? this.batasWaspada,
      batasSiaga: batasSiaga ?? this.batasSiaga,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => [
    daftarSensor,
    batasWaspada,
    batasSiaga,
    loading,
  ];
}

class SensorCubit extends Cubit<SensorState> {
  final HiveHelper hive = HiveHelper.instance;
  final PengaturanHelper pengaturan = PengaturanHelper();

  SensorCubit() : super(const SensorState());

  Future<void> muatData() async {
    emit(state.copyWith(loading: true));

    final data = hive.ambilSemuaData();
    final waspada = await pengaturan.ambilBatasWaspada();
    final siaga = await pengaturan.ambilBatasSiaga();

    emit(state.copyWith(
      daftarSensor: data,
      batasWaspada: waspada,
      batasSiaga: siaga,
      loading: false,
    ));
  }

  Future<void> tambahSensor(PembacaanSensor data) async {
    await hive.tambahData(data);
    await muatData();
  }

  Future<void> ubahSensor(PembacaanSensor data) async {
    await hive.ubahData(data);
    await muatData();
  }

  Future<void> hapusSensor(String id) async {
    await hive.hapusData(id);
    await muatData();
  }

  Future<void> ubahBatas({
    required double waspada,
    required double siaga,
  }) async {
    await pengaturan.simpanBatas(
      waspada: waspada,
      siaga: siaga,
    );

    await muatData();
  }
}
