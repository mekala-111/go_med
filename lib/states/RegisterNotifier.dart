import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegistrationState {
  final String username;
  final String email;
  final String firmName;
  final String gstNumber;
  final String contactNumber;
  final String address;
  final bool isSubmitting;
  final String? errorMessage;

  RegistrationState({
    this.username = '',
    this.email = '',
    this.firmName = '',
    this.gstNumber = '',
    this.contactNumber = '',
    this.address = '',
    this.isSubmitting = false,
    this.errorMessage,
  });

  RegistrationState copyWith({
    String? username,
    String? email,
    String? firmName,
    String? gstNumber,
    String? contactNumber,
    String? address,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return RegistrationState(
      username: username ?? this.username,
      email: email ?? this.email,
      firmName: firmName ?? this.firmName,
      gstNumber: gstNumber ?? this.gstNumber,
      contactNumber: contactNumber ?? this.contactNumber,
      address: address ?? this.address,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
