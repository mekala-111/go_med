// import 'dart:math';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../model/authstate.dart';
// import '../providers/firebase_auth.dart';
// import '../providers/loader.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../utils/gomed_api.dart';
// import '../model/login_auth_state.dart';

// class PhoneAuthNotifier extends StateNotifier<PhoneAuthState> {
//   PhoneAuthNotifier() : super(PhoneAuthState(verificationId: ''));

//   Future<bool> tryAutoLogin() async {
//     final prefs = await SharedPreferences.getInstance();

//     // Check if the Firebase token is stored in shared preferences
//     if (!prefs.containsKey('firebaseToken')) {
//       print('No Firebase token found. tryAutoLogin is set to false.');
//       return false;
//     }

//     // Retrieve the Firebase token
//     String? firebaseToken = prefs.getString('firebaseToken');

//     // If the token exists, save it to the model and return true
//     print('Firebase token found: $firebaseToken');

//     // Update the state with the Firebase token
//     state = state.copyWith(firebaseToken: firebaseToken);

//     return true;
//   }

//   Future<void> verifyPhoneNumber(
//     String phoneNumber,
//     WidgetRef ref,
//   ) async {
//     final auth = ref.read(firebaseAuthProvider);
//     var loader = ref.read(loadingProvider.notifier);
//     var codeSentNotifier = ref.read(codeSentProvider.notifier);
//     var pref = await SharedPreferences.getInstance();

//     try {
//       await auth.verifyPhoneNumber(
//         phoneNumber: phoneNumber,
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           await auth.signInWithCredential(credential);
//           state = PhoneAuthState(verificationId: '');
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           print("Verification failed: ${e.message}");
//           state = PhoneAuthState(verificationId: '', error: e.message);
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           print("Verification code sent: $verificationId");
//           // state = PhoneAuthState(verificationId: verificationId);
//           pref.setString("verificationid", verificationId);
//           codeSentNotifier.state = true; // Update the codeSentProvider
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           print("Auto-retrieval timeout. Verification ID: $verificationId");
//           state = PhoneAuthState(verificationId: verificationId);
//         },
//       );
//     } catch (e) {
//       loader.state = false;
//       print("Error during phone verification: $e");
//       state = PhoneAuthState(verificationId: '', error: e.toString());
//     }
//   }

//   Future<void> signInWithPhoneNumber(String smsCode, WidgetRef ref) async {
//     final authState = ref.watch(firebaseAuthProvider);
//     final loadingState = ref.watch(loadingProvider.notifier);
//     var pref = await SharedPreferences.getInstance();
//     String? verificationid = pref.getString("verificationid");
//     try {
//       loadingState.state = true;
//       print('try exicuted');

//       if (state.verificationId.isEmpty) {
//         throw "Verification ID is missing. Please request a new OTP.";
//       }

//       AuthCredential credential = PhoneAuthProvider.credential(
//           verificationId: verificationid!, smsCode: smsCode);

//       await authState.signInWithCredential(credential).then((value) async {
//         if (value.user != null) {
//           print("Phone verification successful.");

//           // Generate a custom UID
//           String customUid =
//               "#${(100000 + DateTime.now().millisecondsSinceEpoch % 900000)}";
//           String? firebaseToken = await value.user?.getIdToken();
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           await prefs.setString('firebaseToken', firebaseToken!);

//           state = state.copyWith(firebaseToken: firebaseToken);
//           // Send phone number and role to API
//           await sendPhoneNumberAndRoleToAPI(
//             phoneNumber: value.user!.phoneNumber!,
//             role: "vendor", // Assign the role as needed
//           );

//           print("Vendor data stored locally and sent to API.");
//         }
//       });

//       loadingState.state = false;
//     } catch (e) {
//       loadingState.state = false;
//       print("Error during phone verification: $e");
//       state = state.copyWith(error: e.toString());
//     } finally {
//       loadingState.state = false;
//     }
//   }
// Future<void> sendPhoneNumberAndRoleToAPI({
//   required String phoneNumber,
//   required String role,
// }) async {
//   const String apiUrl = Bbapi.login; // Replace with your API URL

//   print('Phone number: $phoneNumber, Role: $role');

//   try {
//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer YOUR_API_TOKEN", // Replace with a valid token if required
//       },
//       body: json.encode({
//         "mobile": phoneNumber,
//         "role": role,
//       }),
//     );

//     if (response.statusCode == 201 || response.statusCode == 200) {
//       print("Data successfully sent to the API.");
//       print("Response: ${response.body}");

//       // Parse the response into the Autogenerated model
//       final Map<String, dynamic> responseData = json.decode(response.body);
//       final parsedResponse = LoginAuthState.fromJson(responseData);

//       // Extract the access token from the first Data object in the response
//       if (parsedResponse.data != null && parsedResponse.data!.isNotEmpty) {
//         final accessToken = parsedResponse.data!.first.accessToken;

//         if (accessToken != null) {
//           // Store the token in SharedPreferences
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           await prefs.setString('authToken', accessToken);

//           print("Token saved locally: $accessToken");

//           // Update state with the token
//           state = state.copyWith(firebaseToken: accessToken);
//           print("Login data stored successfully.");
//         } else {
//           print("Access token is null.");
//         }
//       } else {
//         print("Data list is empty or null.");
//       }
//     } else {
//       print(
//           "Failed to send data to the API. Status code: ${response.statusCode}");
//       print("Response: ${response.body}");
//     }
//   } catch (e) {
//     print("Error while sending data to the API: $e");
//   }
// }


//   Future<String> generateUniqueUid() async {
//     Random random = Random();
//     String uniqueUid;

//     // Generate a random 6-digit UID
//     int randomNumber =
//         100000 + random.nextInt(900000); // Range: 100000 to 999999
//     uniqueUid = "$randomNumber#";

//     return uniqueUid;
//   }
// }
// final loginProvider =
//     StateNotifierProvider<PhoneAuthNotifier,PhoneAuthState>((ref) {
//   return PhoneAuthNotifier();
// });
