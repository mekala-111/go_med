import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../states/RegisterNotifier.dart';

class RegistrationNotifier extends StateNotifier<RegistrationState> {
  RegistrationNotifier() : super(RegistrationState());

  // Method to update the registration form state
  void updateForm({
    String? username,
    String? email,
    String? firmName,
    String? gstNumber,
    String? contactNumber,
    String? address,
  }) {
    state = state.copyWith(
      username: username ?? state.username,
      email: email ?? state.email,
      firmName: firmName ?? state.firmName,
      gstNumber: gstNumber ?? state.gstNumber,
      contactNumber: contactNumber ?? state.contactNumber,
      address: address ?? state.address,
    );
  }

  // Method to handle form submission
  Future<void> submitForm() async {
    state = state.copyWith(isSubmitting: true);

    try {
      final response = await http.post(
        Uri.parse('https://your-api-url.com/register'),
        body: json.encode({
          'username': state.username,
          'email': state.email,
          'firm_name': state.firmName,
          'gst_number': state.gstNumber,
          'contact_number': state.contactNumber,
          'address': state.address,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Registration successful, handle success logic
        state = state.copyWith(isSubmitting: false);
        // Handle the success, maybe navigate to a different page or show a success message
      } else {
        // Registration failed, handle error
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: 'Registration failed. Please try again.',
        );
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