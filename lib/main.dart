import 'package:AgriTech_Link/screens/dashboard/cart/cart_page.dart';
import 'package:AgriTech_Link/screens/dashboard/cart/checkout_page.dart';
import 'package:AgriTech_Link/screens/dashboard/marketplace/marketplace.dart';
import 'package:AgriTech_Link/screens/dashboard/marketplace/my_store.dart';
import 'package:AgriTech_Link/screens/dashboard/marketplace/orders.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:AgriTech_Link/screens/dashboard/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/splash_screen.dart';
import 'package:AgriTech_Link/screens/authentication/sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://hrffwbvwxtdknbyvazlq.supabase.co',
    anonKey:
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhyZmZ3YnZ3eHRka25ieXZhemxxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjUzNjYwNzQsImV4cCI6MjA0MDk0MjA3NH0.0H0F-F85wk6FG27gh9mhPiUo3V6BTLuf29nQ6ymwjbk',
  );

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;
  bool _isAuthenticated = false;
  bool _isFirstLaunch = true;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
    _checkFirstLaunch();
  }

  Future<void> _checkAuthState() async {
    final session = Supabase.instance.client.auth.currentSession;
    setState(() {
      _isAuthenticated = session != null;
      _isLoading = false;
    });
  }

  Future<void> _checkFirstLaunch() async {
    // You can use shared_preferences to check if it's the first launch
    // For simplicity, we're using a dummy value here
    setState(() {
      _isFirstLaunch = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AgriTech Link',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        primaryColor: Color(0xFFDDF71D),
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFDDF71D)),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xfff9f9f7),
          secondary: Color(0xFF0B2115),
        ),
      ),
      home: _isLoading
          ? CircularProgressIndicator()
          : _isFirstLaunch
          ? SplashScreen()
          : _isAuthenticated
          ? HomeScreen()
          : SignIn(),
      routes: {
        '/onboarding': (context) => OnboardingScreen(),
        '/dashboard': (context) => HomeScreen(),
        '/signin': (context) => SignIn(),
        '/market': (context) => MarketplacePage(),
        '/myStore': (context) => MyStore(),
        '/orders': (context) => OrdersPage(),
        '/cart': (context) => const CartPage(),
        '/checkout': (context) => const CheckoutPage()
      },
    );
  }
}