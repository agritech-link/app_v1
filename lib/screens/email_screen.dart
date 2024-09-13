import 'package:flutter/material.dart';
import 'code_verification_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/sign_up_notifier.dart';

class EmailVerificationScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpNotifier = ref.read(signUpProvider.notifier);

    // Listen for sign-up state changes
    ref.listen(signUpProvider, (previous, next) {
      if (next.isSignedUp) { // Assuming `isSignedUp` is a boolean flag
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signed up successfully!')),
        );

        // Navigate to the protected dashboard
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${next.errorMessage}')),
        );
      }
    });

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
              Text(
                "Let's verify your email with a code",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "We'll send you a code to help us set up your account.",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 40),
              Text(
                "Your email",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  signUpNotifier.updateEmail(value);
                },
              ),
              Spacer(),
              Text(
                'By creating an account, you accept our Terms of Service and Privacy Policy.',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('NEXT'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CodeVerificationScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 24.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0)
                      )
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
