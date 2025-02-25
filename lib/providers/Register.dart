import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http_parser/http_parser.dart'; // Import this for MediaType
import '../model/RegisterState.dart';
import '../utils/gomed_api.dart';

class RegistrationNotifier extends StateNotifier<RegistrationState> {
  RegistrationNotifier() : super(RegistrationState());

  // Method to handle form submission with image upload
  Future<void> submitForm(
    String? firmName,
    String? gstNumber,
    String? contactNumber,
    String? address,
    String? ownerName,
    String? email,
    File? selectedImage,
  ) async {
    const String apiUrl = Bbapi.signup;
    state = state.copyWith(isSubmitting: true);
    print(
        'registe data name--$firmName, email--$email, mobile--$contactNumber, photo--${selectedImage?.path},address--$address,ownername--$ownerName,');

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add form fields
      request.fields.addAll({
        'ownerName':ownerName ?? '',
        'role': "distributor",
        'firmName': firmName ?? '',
        'gstNumber': gstNumber ?? '',
        'mobile': contactNumber ?? '',
        'address': address ?? '',
        'email': email ?? '',
        'status': "active",
      });
      print('feiels adding.........');
      print('state data.............name=${state.firmName},email=${state.email}');

      // Check if an image is selected and exists
      if (selectedImage != null) {
        if (await selectedImage.exists()) {
          request.files.add(await http.MultipartFile.fromPath(
            'distributorImage', // Field name in API for file upload
            selectedImage.path,
            contentType: MediaType('image', 'jpeg'), // Ensure correct MIME type
          ));
        } else {
          print(" image file does not exist: ${selectedImage.path}");
          throw Exception(" image file not found");
        }
      }

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // Handle response
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Registration successful.');
        print('Response data: ${response.body}');
        state = state.copyWith(isSubmitting: false);
      } else {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: 'Registration failed. Please try again.',
        );
        print('Registration failed. Response: ${response.body}');
      }
    } catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'An error occurred. Please try again later.',
      );
      print("Error: $error");
    }
  }
}

// Provider for managing registration state
final registrationProvider =
    StateNotifierProvider<RegistrationNotifier, RegistrationState>((ref) {
  return RegistrationNotifier();
});
