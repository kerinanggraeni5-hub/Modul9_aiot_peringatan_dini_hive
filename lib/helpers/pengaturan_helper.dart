import 'package:shared_preferences/shared_preferences.dart';

class PengaturanHelper {
  static const String keyWaspada = 'batasWaspada';
  static const String keySiaga = 'batasSiaga';

  Future<double> ambilBatasWaspada() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(keyWaspada) ?? 50.0;
  }

  Future<double> ambilBatasSiaga() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(keySiaga) ?? 80.0;
  }

  Future<void> simpanBatas({
    required double waspada,
    required double siaga,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble(keyWaspada, waspada);
    await prefs.setDouble(keySiaga, siaga);
  }
}
