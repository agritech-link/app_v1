import 'screens/onboarding_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart/';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// void main() => runApp(MyApp());
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://hrffwbvwxtdknbyvazlq.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhyZmZ3YnZ3eHRka25ieXZhemxxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjUzNjYwNzQsImV4cCI6MjA0MDk0MjA3NH0.0H0F-F85wk6FG27gh9mhPiUo3V6BTLuf29nQ6ymwjbk',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AgriTech Link',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        primaryColor: Color(0xFFDDF71D),
        scaffoldBackgroundColor: Colors.white, // Set background color for Scaffold
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white, // Background color of input fields
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey), // Customize border color
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFDDF71D)), // Customize focused border color
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xfff9f9f7),
          secondary: Color(0xFF0B2115),
        ),
      ),
      home: SplashScreen(),
      routes: {
        '/onboarding': (context) => OnboardingScreen(),
      },
    );
  }
}

