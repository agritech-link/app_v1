import 'package:AgriTech_Link/providers/sign_in_notifier.dart';
import 'package:AgriTech_Link/screens/dashboard/home_screen.dart';
import 'package:flutter/material.dart';



class SignInLogic {
  static bool isValidPassword(String password) {
    final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$');
    return regex.hasMatch(password);
  }

  static bool isValidEmail(String email) {
    final regex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return regex.hasMatch(email);
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  static Future<void> handleSignIn(BuildContext context, SignInData signInData, SignInNotifier signInNotifier) async {
    if ((signInData.email?.isEmpty ?? true) ||
        (signInData.password?.isEmpty ?? true)) {
      showErrorSnackBar(context, "Please fill in all fields");
      return;
    }

    if (!isValidPassword(signInData.password!)) {
      showErrorSnackBar(context, 'Password must be at least 6 characters long, contain a letter, a number, and a special character');
      return;
    }

    if (!isValidEmail(signInData.email!)) {
      showErrorSnackBar(context, 'Please enter a valid email address.');
      return;
    }

    await signInNotifier.signIn();

    if (signInData.isSignedIn) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => HomeScreen()));
    } else if (signInData.errorMessage != null) {
      showErrorSnackBar(context, 'Sign-in failed: ${signInData.errorMessage}');
    }
  }
}