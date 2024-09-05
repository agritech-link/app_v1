import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpData {
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? password;
  final bool isSignedUp;
  final String? errorMessage;

  SignUpData({
    this.email,
    this.firstName,
    this.lastName,
    this.password,
    this.isSignedUp = false,
    this.errorMessage
});

  SignUpData copyWith({
    String? email,
    String? firstName,
    String? lastName,
    String? password,
    bool? isSignedUp,
    String? errorMessage,
}) {
    return SignUpData(
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      password: password ?? this.password,
      isSignedUp: isSignedUp ?? this.isSignedUp,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class SignUpNotifier extends StateNotifier<SignUpData> {
  SignUpNotifier() : super(SignUpData());

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updateFirstName(String firstName) {
    state = state.copyWith(firstName: firstName);
  }

  void updateLastName(String lastName) {
    state = state.copyWith(lastName: lastName);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  Future<void> signUp() async {
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: state.email!,
        password: state.password!,
        data: {
          'display_name': state.firstName! + ' ' + state.lastName!,
          }

      );

      if (response.user != null) {
        state = state.copyWith(isSignedUp: true, errorMessage: null);
      } else {
        state = state.copyWith(
          isSignedUp: false,
          errorMessage: 'Unknown error occurred',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isSignedUp: false,
        errorMessage: e.toString(),
      );
    }
  }
}

final signUpProvider = StateNotifierProvider<SignUpNotifier, SignUpData>(
      (ref) => SignUpNotifier(),
);