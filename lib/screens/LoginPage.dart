import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_med/providers/firebase_auth.dart';
import 'package:go_med/providers/loader.dart';
import 'otp_verify.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController phoneController =
      TextEditingController(text: "+91");

  List<TextEditingController> otpControllers = List.generate(
    6, // Replace with the number of OTP fields
    (index) => TextEditingController(),
  );

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(loadingProvider);
    final authNotifier = ref.read(phoneAuthProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo and Title
            Image.asset(
              'assets/logo.png', // Replace with your logo asset path
              height: 100,
            ),
            const SizedBox(height: 16),
            const Text(
              "GoMedServ Healthcare Pvt Ltd",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 40),
            // Login Card
            Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Phone Number",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  // Phone Number Input
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Enter phone number",
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14.0,
                        horizontal: 12.0,
                      ),
                    ),
                    onChanged: (value) {
                      if (!value.startsWith("+91")) {
                        phoneController.text = "+91";
                        phoneController.selection = TextSelection.fromPosition(
                          TextPosition(offset: phoneController.text.length),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Send OTP Button
                  Consumer(
                    builder: (context, ref, child) {
                      final phoneAuthNotifier =
                          ref.read(phoneAuthProvider.notifier);
                      var loader = ref.watch(loadingProvider);
                      return ElevatedButton(
                        onPressed: loader
                            ? null
                            : () async {
                                String phoneNumber =
                                    phoneController.text.trim();

                                bool isValid = phoneNumber.startsWith("+91") &&
                                    phoneNumber.length == 13 &&
                                    RegExp(r'^[6-9]\d{9}$')
                                        .hasMatch(phoneNumber.substring(3));

                                if (isValid) {
                                  // Attempt to send the OTP
                                  await phoneAuthNotifier.verifyPhoneNumber(
                                      phoneNumber, ref, () {});

                                  // Show the bottom sheet immediately
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom,
                                        ),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(24),
                                            ),
                                          ),
                                          child: OTPInputScreen(otpControllers),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Please enter a valid 10-digit mobile number.'),
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "Send OTP",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Register and Help Links
            GestureDetector(
              onTap: () {
                // Navigate to registration
              },
              child: const Text(
                "Don't have an account? Register Here",
                style: TextStyle(color: Colors.teal, fontSize: 14),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                // Show help dialog
              },
              child: const Text(
                "Have trouble? click here",
                style: TextStyle(color: Colors.teal, fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),
            // Error Message
            // if (authState.errorMessage.isNotEmpty)
            //   Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
            //     child: Text(
            //       authState.errorMessage,
            //       style: const TextStyle(
            //         color: Colors.red,
            //         fontSize: 14,
            //       ),
            //       textAlign: TextAlign.center,
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
