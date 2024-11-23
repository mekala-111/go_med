import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_med/providers/firebase_auth.dart';
import 'package:go_med/providers/loader.dart';


class LoginScreen extends ConsumerWidget {
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            Text(
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
                boxShadow: [
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
                  ),
                  const SizedBox(height: 16),
                  // Send OTP Button
                  ElevatedButton(
                    onPressed: authState.isLoading
                        ? null
                        : () {
                            final phoneNumber = phoneController.text.trim();
                            if (phoneNumber.length == 10) {
                              authNotifier.sendOTP("+91$phoneNumber");
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Enter a valid phone number')),
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
                    child: authState.isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Send OTP",
                            style: TextStyle(fontSize: 16),
                          ),
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
              child: Text(
                "Don't have an account? Register Here",
                style: TextStyle(color: Colors.teal, fontSize: 14),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                // Show help dialog
              },
              child: Text(
                "Have trouble? click here",
                style: TextStyle(color: Colors.teal, fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),
            // Error Message
            if (authState.errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  authState.errorMessage,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
