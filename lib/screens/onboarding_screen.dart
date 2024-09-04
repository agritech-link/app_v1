import 'package:flutter/material.dart';
import 'verification_screen.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create account',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Let’s verify your phone number with a code',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 40),
            TextField(
              decoration: InputDecoration(
                labelText: 'Your phone number',
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text('+26'),
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            Spacer(),
            Text(
              'By creating an account, you accept our Terms of Service and Privacy Policy',
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => VerificationScreen(),
                ));
              },
              child: Text('NEXT'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFDDF71D),
                foregroundColor: Color(0xFF0B2115),
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
