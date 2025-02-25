

class RegistrationState {
  final String ownerName;
  final String email;
  final String firmName;
  // final String role;
  final String gstNumber;
  final String contactNumber;
  final String address;
  final bool isSubmitting;
  final String? errorMessage;

  var selectedImage;

  RegistrationState({
    this.ownerName = '',
    this.email = '',
    this.firmName = '',
    this.gstNumber = '',
    this.contactNumber = '',
    this.address = '',
    this.isSubmitting = false,
    this.errorMessage,
    // this.role='',
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
     String? ownerName,
     
    //  String? role,
  }) {
    return RegistrationState(
      ownerName: username ?? this.ownerName,
      email: email ?? this.email,
      // role: role??this.role,
      firmName: firmName ?? this.firmName,
      gstNumber: gstNumber ?? this.gstNumber,
      contactNumber: contactNumber ?? this.contactNumber,
      address: address ?? this.address,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
