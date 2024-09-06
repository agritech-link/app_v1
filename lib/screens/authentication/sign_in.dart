import 'package:AgriTech_Link/services/sign_in_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/sign_in_notifier.dart';

class SignIn extends ConsumerStatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  ConsumerState<SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  @override
  Widget build(BuildContext context) {
    final signInData = ref.watch(signInProvider);
    final isLoading = ref.watch(signInLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Get help?',
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              const Text(
                "Sign in",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Welcome back to AgriTech Link",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Enter your email and password to sign in",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 20),
              const Text(
                "Email",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.email),
                ),
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.black),
                onChanged: (value) => ref.read(signInProvider.notifier).updateEmail(value),
              ),
              const SizedBox(height: 20),
              const Text(
                "Password",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.visibility_off),
                ),
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.black),
                obscureText: true,
                onChanged: (value) => ref.read(signInProvider.notifier).updatePassword(value),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                    try {
                      ref.read(signInLoadingProvider.notifier).state = true;
                      await SignInLogic.handleSignIn(
                        context,
                        signInData,
                        ref.read(signInProvider.notifier),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Sign in failed: ${e.toString()}')),
                      );
                    } finally {
                      ref.read(signInLoadingProvider.notifier).state = false;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      strokeWidth: 2,
                    ),
                  )
                      : const Text("Sign In"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

final signInLoadingProvider = StateProvider<bool>((ref) => false);