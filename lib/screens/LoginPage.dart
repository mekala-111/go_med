import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_med/constants/app_colors.dart';
import 'package:go_med/screens/serviceEngineer_screens/ServiceEngineerDashboard.dart';
import 'dart:async';
import '../providers/firebase_auth.dart';
import '../providers/loader.dart';
import 'Ditributor_screens/dashboard.dart';
import '../screens/Register.dart';
import '../providers/auth_provider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class LoginScreen extends ConsumerStatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController phoneController =
      TextEditingController(text: "+91");
  final TextEditingController otpController = TextEditingController();

  bool isKeyboardVisible = false;
  bool isSendingOtp = false;
  bool isLoggingIn = false;
  bool isOtpEntered = false;
  String lastPhoneNumber = "";

  int countdown = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    otpController.addListener(() {
      if (mounted) {
        setState(() {
          isOtpEntered = otpController.text.trim().isNotEmpty;
        });
      }
    });

    phoneController.addListener(() {
      if (!mounted) return;

      final text = phoneController.text;
      if (!text.startsWith("+91")) {
        phoneController.value = TextEditingValue(
          text: "+91",
          selection: TextSelection.collapsed(offset: 3),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  void startOtpCountdown() {
    if (!mounted) return;

    setState(() {
      countdown = 60;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (countdown > 0) {
            countdown--;
          } else {
            _timer?.cancel();
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  // 🛑 NEW — SHOW ERROR AND STOP FLOW
  void showOtpError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
    setState(() {
      isLoggingIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
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
                  colors: [AppColors.gomedcolor, AppColors.white],
                ),
              ),
            ),
          ),

          // Logo Section
          Positioned(
            top: isKeyboardVisible ? 30 : screenHeight * 0.10,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 300,
                height: 100,
                child:
                    Image.asset('assets/images/logo1.jpg', fit: BoxFit.cover),
              ),
            ),
          ),

          // Input Section
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
                  colors: [Color(0xFF8ED6F8), AppColors.white],
                ),
                borderRadius:
                    BorderRadius.only(topLeft: Radius.circular(160)),
              ),
              padding: const EdgeInsets.fromLTRB(50, 50, 50, 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Phone Number Field
                  const Text('Phone Number',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      hintText: 'Enter your phone number',
                      filled: true,
                      fillColor: AppColors.grey,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(13),
                      FilteringTextInputFormatter.allow(RegExp(r'[\d+]')),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // OTP Field + Send Button
                  const Text('OTP',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: otpController,
                          decoration: InputDecoration(
                            hintText: 'Enter OTP',
                            filled: true,
                            fillColor: AppColors.grey,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      ElevatedButton(
                        onPressed: countdown > 0 || isSendingOtp
                            ? null
                            : () async {
                                if (!mounted) return;

                                setState(() => isSendingOtp = true);

                                final phoneNumber =
                                    phoneController.text.trim();
                                final isValid = phoneNumber.startsWith("+91") &&
                                    phoneNumber.length == 13 &&
                                    RegExp(r'^[6-9]\d{9}$')
                                        .hasMatch(phoneNumber.substring(3));

                                if (isValid) {
                                  lastPhoneNumber = phoneNumber;
                                  try {
                                    final authNotifier =
                                        ref.read(loginProvider.notifier);
                                    await authNotifier.verifyPhoneNumber(
                                        phoneNumber, ref);

                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text("OTP sent successfully")));
                                      startOtpCountdown();
                                    }
                                  } catch (e) {
                                    showOtpError("Failed to send OTP: $e");
                                  }
                                } else {
                                  showOtpError(
                                      "Enter a valid 10-digit phone number.");
                                }

                                if (mounted) {
                                  setState(() => isSendingOtp = false);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0E7AAB),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 30),
                        ),
                        child: isSendingOtp
                            ? const CircularProgressIndicator(
                                color: AppColors.white, strokeWidth: 2)
                            : Text(
                                countdown > 0
                                    ? "$countdown sec"
                                    : (lastPhoneNumber ==
                                            phoneController.text.trim()
                                        ? "Resend OTP"
                                        : "Send OTP"),
                                style: const TextStyle(
                                    color: AppColors.white, fontSize: 16),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Verify Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isOtpEntered && !isLoggingIn
                          ? () async {
                              if (!mounted) return;

                              final smsCode = otpController.text.trim();
                              if (smsCode.isEmpty) {
                                showOtpError("Please enter the OTP.");
                                return;
                              }

                              setState(() => isLoggingIn = true);

                              try {
                                final authNotifier =
                                    ref.read(loginProvider.notifier);

                                // TRY OTP LOGIN
                                await authNotifier.signInWithPhoneNumber(
                                    smsCode, ref);

                                // STOP TIMER
                                _timer?.cancel();

                                if (!mounted) return;

                                // READ LOGIN RESULT
                                final authState =
                                    ref.read(loginProvider);
                                final userData =
                                    authState.data?.isNotEmpty == true
                                        ? authState.data![0]
                                        : null;

                                // ❌ If login failed
                                if (userData == null ||
                                    userData.accessToken!.isEmpty) {
                                  showOtpError("Invalid OTP. Try again.");
                                  return;
                                }

                                // SUCCESS
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("OTP Verified Successfully!")),
                                );

                                final role = userData.details?.role
                                    ?.toLowerCase();

                                // NAVIGATE
                                if (role == "distributor") {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const DashboardDistributorScreen()),
                                  );
                                } else if (role == "serviceengineer") {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const DashboardPage()),
                                  );
                                } else {
                                  showOtpError(
                                      "Unknown role. Contact support.");
                                }
                              } on FirebaseAuthException catch (e) {
                                if (!mounted) return;

                                // Firebase-specific OTP errors
                                if (e.code == "invalid-verification-code") {
                                  showOtpError("Incorrect OTP.");
                                } else if (e.code == "session-expired") {
                                  showOtpError(
                                      "OTP session expired. Please request a new one.");
                                } else {
                                  showOtpError(
                                      "OTP Verification failed: ${e.message}");
                                }
                              } catch (e, stackTrace) {
                                FirebaseCrashlytics.instance.recordError(
                                  e,
                                  stackTrace,
                                  reason: "OTP verification error",
                                );

                                showOtpError("Unexpected error: $e");
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isOtpEntered ? AppColors.info : AppColors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: isLoggingIn
                          ? const CircularProgressIndicator(
                              color: AppColors.white, strokeWidth: 2)
                          : const Text("Verify"),
                    ),
                  ),
                  const SizedBox(height: 19),

                  // Register Link
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
                        style: TextStyle(fontSize: 12),
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
