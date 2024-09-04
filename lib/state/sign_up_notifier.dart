import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpData {
  final String? phoneNumber;
  final String? firstName;
  final String? lastName;
  final String? password;

  SignUpData({
    this.phoneNumber,
    this.firstName,
    this.lastName,
    this.password,
});

  SignUpData copyWith({
    String? phoneNumber,
    String? firstName,
    String? lastName,
    String? password,
}) {
    return SignUpData(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      password: password ?? this.password
    );
  }
}

class SignUpNotifier extends StateNotifier<SignUpData> {
  SignUpNotifier() : super(SignUpData());

  void updatePhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
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
}

final signUpProvider = StateNotifierProvider<SignUpNotifier, SignUpData>(
      (ref) => SignUpNotifier(),
);