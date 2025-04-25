import 'package:flutter/material.dart';
import 'package:my_flutter_app/screens/dashbaord.dart';

import 'screens/alerts.dart';
import 'screens/automation.dart';
import 'screens/login.dart';
import 'screens/result.dart';
import 'screens/search.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PyIdealista',
      theme: ThemeData(
        primaryColor: const Color(0xFF28A745),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF28A745),
          primary: const Color(0xFF28A745),
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F7F9),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF28A745),
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF28A745),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const Dashboard(),
        '/search': (context) => const SearchPage(),
        '/results': (context) => ResultPage(
              resultCount: 24,
              selectedStations: const ['Centro', 'Salamanca', 'Chamberí'],
              centralStation: 'Sol',
              results: [
                PropertyResult.sample(),
                PropertyResult.sample(),
                PropertyResult.sample(),
                PropertyResult.sample(),
              ],
            ),
        '/automation': (context) => const AutomationScreen(
              selectedStations: [
                'Sol',
                'Gran Vía',
                'Callao',
                'Plaza de España'
              ],
              centralStation: 'Sol',
            ),
        '/alerts': (context) => const AlertsScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/automation') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => AutomationScreen(
              selectedStations: args['selectedStations'] as List<String>,
              centralStation: args['centralStation'] as String,
            ),
          );
        }
        return null;
      },
    );
  }
}
