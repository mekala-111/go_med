import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/RegisterState.dart';
import '../utils/gomed_api.dart';

class RegistrationNotifier extends StateNotifier<RegistrationState> {
  RegistrationNotifier() : super(RegistrationState());

  // Method to update the registration form state
  void updateForm({
    // String? username,
    // String? email,
    String? firmName,
    String? gstNumber,
    String? contactNumber,
    String? address,
    String? ownerName,
  }) {
    state = state.copyWith(
        // username: username ?? state.ownerName,
        // email: email ?? state.email,
        firmName: firmName ?? state.firmName,
        gstNumber: gstNumber ?? state.gstNumber,
        contactNumber: contactNumber ?? state.contactNumber,
        address: address ?? state.address,
        ownerName: ownerName ?? state.ownerName);
  }

  // Method to handle form submission
  Future<void> submitForm() async {
    const String apiUrl = Bbapi.signup;
    state = state.copyWith(isSubmitting: true);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode({
          'ownerName': state.ownerName,
          'role': "distributor",
          'firmName': state.firmName,
          'gstNumber': state.gstNumber,
          'mobile': state.contactNumber,
          'address': state.address,
          "activity":"zero"
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Registration successful, handle success logic
        print('registration successful...................');
        print('response.registration data${response.body}');
        state = state.copyWith(isSubmitting: false);
        // Handle the success, maybe navigate to a different page or show a success message
      } else {
        // Registration failed, handle error
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: 'Registration failed. Please try again.',
        );
         print('response.registration data${response.body}');
      }
    } catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'An error occurred. Please try again later.',
      );
    }
  }
}

final registrationProvider =
    StateNotifierProvider<RegistrationNotifier, RegistrationState>((ref) {
  return RegistrationNotifier();
});
