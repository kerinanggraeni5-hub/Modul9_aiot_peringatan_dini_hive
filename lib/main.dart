import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'helpers/hive_helper.dart';
import 'cubit/sensor_cubit.dart';
import 'pages/dashboard_page.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveHelper.instance.init();

  runApp(
    BlocProvider(
      create: (context) => SensorCubit()..muatData(),
      child: const AplikasiAIoT(),
    ),
  );
}

class AplikasiAIoT extends StatelessWidget {
  const AplikasiAIoT({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AIoT Peringatan Dini',
      theme: AppTheme.lightTheme,
      home: const DashboardPage(),
    );
  }
}
