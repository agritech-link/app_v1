import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInData {
  final String? email;
  final String? password;
  final bool isSignedIn;
  final String? errorMessage;

  SignInData(
      {this.email, this.password, this.isSignedIn = false, this.errorMessage});

  SignInData copyWith({
    String? email,
    String? password,
    bool? isSignedIn,
    String? errorMessage,
  }) {
    return SignInData(
        email: email ?? this.email,
        password: password ?? this.password,
        isSignedIn: isSignedIn ?? this.isSignedIn,
        errorMessage: errorMessage ?? this.errorMessage);
  }
}

class SignInNotifier extends StateNotifier<SignInData> {
  SignInNotifier() : super(SignInData());

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  Future<void> signIn() async {
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: state.email!,
        password: state.password!,
      );

      if (response.session != null) {
        state = state.copyWith(isSignedIn: true, errorMessage: null);
      } else {
        state = state.copyWith(
            isSignedIn: false, errorMessage: 'Unknown error occurred');
      }
    } catch (e) {
      state = state.copyWith(
        isSignedIn: false,
        errorMessage: e.toString(),
      );
    }
  }
}

final signInProvider = StateNotifierProvider<SignInNotifier, SignInData>(
    (ref) => SignInNotifier());
