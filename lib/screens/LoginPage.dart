import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/firebase_auth.dart';
import '../providers/loader.dart';
import 'dashboard.dart';
import '../screens/Register.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController phoneController =TextEditingController(text: "+91");
  final TextEditingController otpController = TextEditingController();

  bool isKeyboardVisible = false;
  bool isSendingOtp = false; // Loading state for "Send OTP" button
  bool isLoggingIn = false; // Loading state for "Login" button
  bool isOtpEntered = false; // Tracks if OTP is entered

  @override
  void initState() {
    super.initState();

    // Listen to changes in the OTP text field
    otpController.addListener(() {
      setState(() {
        isOtpEntered = otpController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    otpController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(loadingProvider);
    final authNotifier = ref.read(loginProvider.notifier);
    final bottomInset =
        MediaQuery.of(context).viewInsets.bottom; // Keyboard height
    final screenHeight = MediaQuery.of(context).size.height;
    isKeyboardVisible = bottomInset > 0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background Gradient
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
            child: Center(
              child: Container(
                width: 300,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    'images/logo.jpg',
                    width: 300,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          // Input Container Section
          AnimatedPositioned(
            duration: const Duration(milliseconds: 50),
            curve: Curves.easeInOut,
            top: isKeyboardVisible ? screenHeight * 0.25 : screenHeight * 0.49,
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
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Phone Number Label and TextField
                  const Padding(
                    padding: EdgeInsets.only(bottom: 4.0),
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
                    keyboardType: TextInputType.phone,
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
                    padding: EdgeInsets.only(bottom: 4.0),
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
                      ElevatedButton(
                        onPressed: authState || isSendingOtp
                            ? null
                            : () async {
                                setState(() {
                                  isSendingOtp = true;
                                });
                                final phoneNumber = phoneController.text.trim();
                                final isValid = phoneNumber.startsWith("+91") &&
                                    phoneNumber.length == 13 &&
                                    RegExp(r'^[6-9]\d{9}$')
                                        .hasMatch(phoneNumber.substring(3));

                                if (isValid) {
                                  try {
                                    await authNotifier.verifyPhoneNumber(
                                      phoneNumber,
                                      ref,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('OTP sent successfully!'),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('Failed to send OTP: $e'),
                                      ),
                                    );
                                  } finally {
                                    setState(() {
                                      isSendingOtp = false;
                                    });
                                  }
                                } else {
                                  setState(() {
                                    isSendingOtp = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Please enter a valid 10-digit mobile number.'),
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0E7AAB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 30),
                        ),
                        child: isSendingOtp
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Send OTP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isOtpEntered && !isLoggingIn
                          ? () async {
                              final smsCode = otpController.text.trim();
                              if (smsCode.isNotEmpty) {
                                setState(() {
                                  isLoggingIn = true;
                                });
                                try {
                                  await ref
                                      .read(loginProvider.notifier)
                                      .signInWithPhoneNumber(smsCode, ref);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "OTP Verified Successfully!")),
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DashboardPage(),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text("Failed to verify OTP: $e"),
                                    ),
                                  );
                                } finally {
                                  setState(() {
                                    isLoggingIn = false;
                                  });
                                }
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isOtpEntered
                            ? const Color(0xFF0E7AAB)
                            : Colors.grey, // Disabled button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: isLoggingIn
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Verify',
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegistrationPage()),
                        );
                      },
                      child: const Text(
                        "Don't have an account? Register Here",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
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
