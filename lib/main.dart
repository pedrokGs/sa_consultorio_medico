import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sa_consultorio/theme/app_colors.dart';
import 'package:sa_consultorio/theme/theme_provider.dart';
import 'package:sa_consultorio/views/consultations_page.dart';
import 'package:sa_consultorio/views/home_page.dart';
import 'package:sa_consultorio/views/patients_page.dart';
import 'package:sa_consultorio/views/settings_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // final isDark = themeProvider.themeMode == ThemeMode.dark;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Med_app',
      theme: ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder()},
        ),

        colorScheme: AppColors.getColorScheme(false),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(

        colorScheme: AppColors.getColorScheme(true),
        useMaterial3: true,
      ),
      themeMode: themeProvider.themeMode,
      initialRoute: "/", 
      routes: {
        "/": (context) => const HomePage(),
        "/settings": (context) => const SettingsPage(),
        "/consultations": (context) => const ConsultationsPage(),
        "/patients": (context) => const PatientsPage(),
      },
    );
  }
}
