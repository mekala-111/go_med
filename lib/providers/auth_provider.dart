// import 'dart:convert';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../modle/authstate.dart';

// class AuthNotifier extends StateNotifier<> {
//   AuthNotifier() : super(AuthState.initial());

//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//   // Update phone number in state
//   void updatePhoneNumber(String phoneNumber) {
//     state = state.copyWith(mobileno: int.tryParse(phoneNumber));
//   }

//   // Update OTP in state
//   void updateOtp(String otp) {
//     state = state.copyWith(messages: otp);
//   }

//   // Send OTP
//   Future<void> sendOtp(String phoneNumber) async {
//     if (phoneNumber.isEmpty || phoneNumber.length != 10) {
//       throw Exception('Invalid phone number');
//     }

//     try {
//       await _firebaseAuth.verifyPhoneNumber(
//         phoneNumber: '+91$phoneNumber', // Add country code as needed
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           // Auto-sign-in on successful verification
//           await _firebaseAuth.signInWithCredential(credential);
//           state = state.copyWith(profile: true, messages: 'Login Successful');
//           await _saveUserData();
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           state = state.copyWith(messages: 'Verification failed: ${e.message}');
//           throw Exception(e.message ?? 'Verification failed');
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           state = state.copyWith(
//             ftoken: verificationId, // Save verification ID for future use
//             messages: 'OTP sent successfully',
//           );
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           state = state.copyWith(ftoken: verificationId);
//         },
//       );
//     } catch (e) {
//       state = state.copyWith(messages: 'Failed to send OTP');
//       throw Exception('Failed to send OTP: $e');
//     }
//   }

//   // Verify OTP
//   Future<void> verifyOtp(String otp) async {
//     if (otp.isEmpty || otp.length != 6) {
//       throw Exception('Invalid OTP');
//     }

//     try {
//       final PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: state.ftoken!,
//         smsCode: otp,
//       );

//       await _firebaseAuth.signInWithCredential(credential);
//       state = state.copyWith(profile: true, messages: 'Login Successful');
//       await _saveUserData(); // Save user data to shared preferences
//     } catch (e) {
//       state = state.copyWith(messages: 'OTP verification failed');
//       throw Exception('Failed to verify OTP: $e');
//     }
//   }

//   // Logout and clear user data
//   Future<void> logout() async {
//     try {
//       await _firebaseAuth.signOut(); // Sign out from Firebase

//       // Clear shared preferences except 'profile'
//       final prefs = await SharedPreferences.getInstance();
//       Set<String> keys = prefs.getKeys();
//       for (String key in keys) {
//         if (key != 'profile') {
//           prefs.remove(key);
//         }
//       }

//       // Reset state
//       state = AuthState.initial();
//     } catch (e) {
//       throw Exception('Failed to log out: $e');
//     }
//   }

//   // Try auto-login based on saved data
//   Future<void> tryAutoLogin() async {
//     final prefs = await SharedPreferences.getInstance();
//     if (!prefs.containsKey('userData')) {
//       return;
//     }

//     final extractData =
//         json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
//     state = state.copyWith(
//       mobileno: extractData['mobileno'],
//       profile: extractData['profile'],
//     );
//   }

//   // Save user data to shared preferences
//   Future<void> _saveUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userData = json.encode({
//       'mobileno': state.mobileno,
//       'profile': state.profile,
//     });
//     await prefs.setString('userData', userData);
//   }
// }

// // Provide the AuthNotifier instance
// final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
//   return AuthNotifier();
// });
