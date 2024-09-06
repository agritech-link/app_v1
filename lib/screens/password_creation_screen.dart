import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sign_up_notifier.dart';
import '../screens/dashboard/home_screen.dart';

class PasswordCreationScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpNotifier = ref.read(signUpProvider.notifier);
    final signUpData = ref.watch(signUpProvider);

    bool isValidPassword(String password) {
      final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$');
      return regex.hasMatch(password);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            child: Text('Get help?', style: TextStyle(color: Colors.black)),
            onPressed: () {
              // Implement help functionality
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Text(
                "Create your password",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Choose a password",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.visibility_off),
                ),
                onChanged: (value) {
                  signUpNotifier.updatePassword(value);
                },
              ),
              SizedBox(height: 10),
              Text(
                "At least 8 characters long, containing a letter and a number",
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('DONE'),
                  onPressed: () async {
                    // Validate and submit the data to Supabase
                    if ((signUpData.email?.isEmpty ?? true) ||
                        (signUpData.firstName?.isEmpty ?? true) ||
                        (signUpData.lastName?.isEmpty ?? true) ||
                        (signUpData.password?.isEmpty ?? true)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please fill in all fields'),
                        ),
                      );
                      return;
                    }

                    if (!isValidPassword(signUpData.password!)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Password must be at least 6 characters long, contain a letter, a number, and a special character'),
                          duration: Duration(seconds: 4),
                        ),
                      );
                      return;
                    }

                    await signUpNotifier.signUp();

                    if (signUpData.isSignedUp) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => HomeScreen()),
                      );
                    } else if (signUpData.errorMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Sign-up failed: ${signUpData.errorMessage}'),
                          duration: Duration(seconds: 4),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
