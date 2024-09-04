import 'package:agritech_link/screens/dashboard/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../state/sign_up_notifier.dart';

class PasswordCreationScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpNotifier = ref.read(signUpProvider.notifier);
    final signUpData = ref.watch(signUpProvider); // Watch the state for the sign-up data

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
                    if ((signUpData.phoneNumber?.isEmpty ?? true) ||
                        (signUpData.firstName?.isEmpty ?? true) ||
                        (signUpData.lastName?.isEmpty ?? true) ||
                        (signUpData.password?.isEmpty ?? true)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill in all fields')),
                      );
                      return;
                    }

                    try {
                      final response = await Supabase.instance.client.auth.signUp(
                        email: signUpData.phoneNumber!,
                        password: signUpData.password!,
                        data: {
                          'first_name': signUpData.firstName!,
                          'last_name': signUpData.lastName!,
                        },
                      );

                      // if (response.error != null) {
                      //   // Handle the error
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(content: Text('Sign up failed: ${response.error!.message}')),
                      //   );
                      // } else {
                      //   // Success
                      //   Navigator.of(context).pushReplacement(
                      //     MaterialPageRoute(builder: (_) => HomeScreen()),
                      //   );
                      // }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
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