import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junetech/features/scan/presentation/bloc/scan_cubit.dart';
import 'package:junetech/features/scan/presentation/pages/home_screen.dart';
import 'package:junetech/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScanCubit>(
      create: (_) => ScanCubit()..fetchScanSummary(1),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'JuneTech 5th Edition',
        theme: ThemeData(
          primarySwatch: Colors.yellow,
          scaffoldBackgroundColor: const Color(0xFF1E1E1E),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1E1E1E),
            foregroundColor: Colors.white,
          ),
          textTheme: const TextTheme(
            headlineSmall: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white70),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
