import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/firebase_auth.dart';
import '../providers/loader.dart';
import 'dashboard.dart';

class LoginScreen extends ConsumerStatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController phoneController =
      TextEditingController(text: "+91");
  final TextEditingController otpController = TextEditingController();

  bool isKeyboardVisible = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(loadingProvider);
    final authNotifier = ref.read(phoneAuthProvider.notifier);
    final bottomInset =
        MediaQuery.of(context).viewInsets.bottom; // Keyboard height
    final screenHeight = MediaQuery.of(context).size.height;

    isKeyboardVisible = bottomInset > 0;

    return Scaffold(
  
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF6EE883), // Green color
                Color(0xFFFFFFFF), // White color
              ],
            ),
          ),
        ),
      ),
          // Logo Section
          Positioned(
            top: isKeyboardVisible
                ? 30
                : screenHeight * 0.10, // Adjust logo position
            left: 0,
            right: 0,
            
            child:  Center(
  child: Container(
  width: 300,
  height: 100,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(30), // Set your desired curve radius
   
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(30), // Make sure this matches the container's radius
    child: Image.asset(
      'images/logo.jpg', // Replace with your actual logo path
      width: 300,
      height: 100, // Set height to match the container's height
      fit: BoxFit.cover, // This ensures the image fills the container without distortion
    ),
  ),
),

),

          ),

          // Input Container Section
          AnimatedPositioned(
            duration: const Duration(milliseconds: 50),
            curve: Curves.easeInOut,
            top: isKeyboardVisible
                ? screenHeight *
                    0.25 // Position just below the image when keyboard is visible
                : screenHeight *
                    0.49, // Default position when keyboard is not visible
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF8ED6F8), // Light blue
          Color(0xFFFEFFF9), // Off-white
        ],
        stops: [0.18, 0.98],
      ),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(160), // Top-left curve
      ),
    ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 50, vertical: 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Phone Number Label and TextField
                  const Padding(
                    padding:  EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      'Phone Number',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      hintText: 'Enter your phone number',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (!value.startsWith("+91")) {
                        phoneController.text = "+91";
                        phoneController.selection = TextSelection.fromPosition(
                          TextPosition(offset: phoneController.text.length),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 10),

                  // OTP Label and TextField with Verify Button
                  const Padding(
                    padding:  EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      'OTP',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: otpController,
                          decoration: InputDecoration(
                            hintText: 'Enter OTP',
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 15),
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

                                    bool isValid = phoneNumber
                                            .startsWith("+91") &&
                                        phoneNumber.length == 13 &&
                                        RegExp(r'^[6-9]\d{9}$')
                                            .hasMatch(phoneNumber.substring(3));

                                    if (isValid) {
                                      // Attempt to send the OTP
                                      await phoneAuthNotifier.verifyPhoneNumber(
                                          phoneNumber, ref);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Please enter a valid 10-digit mobile number.'),
                                        ),
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFF0E7AAB), // Light teal
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 30),
                            ),
                            child: const Text(
                              'Verify',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        String smsCode = otpController.text
                            .trim(); // Get the OTP from the single text field
                        if (smsCode.isNotEmpty) {
                          try {
                            // Verify the OTP
                            await ref
                                .read(phoneAuthProvider.notifier)
                                .signInWithPhoneNumber(smsCode, ref);

                            // Show success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("OTP Verified Successfully!")),
                            );

                            // Navigate to the dashboard page
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DashboardPage()),
                            );
                          } catch (e) {
                            // Show error message if OTP verification fails
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Failed to verify OTP: $e")),
                            );
                          }
                        } else {
                          // Show a message if the OTP field is empty
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please enter the OTP.")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0E7AAB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 19),

                  // Registration Link
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to registration
                      },
                      
                      child: const Text(
                        "Don't have an account? Register Here",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
