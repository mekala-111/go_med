import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  final TextEditingController phoneController = TextEditingController(text: "+91");
  final TextEditingController otpController = TextEditingController();

  bool isKeyboardVisible = false;
  bool isSendingOtp = false; // Loading state for "Send OTP" button
  bool isLoggingIn = false; // Loading state for "Verify" button
  bool isOtpEntered = false; // Tracks if OTP is entered
  String lastPhoneNumber = ""; // Store the last sent phone number

  int countdown = 0; // Countdown timer for OTP
  Timer? _timer; // Timer object

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer if active
    super.dispose();
  }

  void startOtpCountdown() {
    setState(() {
      countdown = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (countdown > 0) {
          countdown--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    otpController.addListener(() {
      setState(() {
        isOtpEntered = otpController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(loadingProvider);
    final authNotifier = ref.watch(loginProvider.notifier);
    final authNotifierLogin = ref.watch(loginProvider);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    isKeyboardVisible = bottomInset > 0;
    final accessToken = authNotifierLogin.data?.isNotEmpty == true
                ?authNotifierLogin.data![0].accessToken
                : null;
            final status = authNotifierLogin.data?.isNotEmpty == true
                ? authNotifierLogin.data![0].details?.status
                : null;

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
                child: Image.asset('assets/images/logo1.jpg', fit: BoxFit.cover),
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
                borderRadius: BorderRadius.only(topLeft: Radius.circular(160)),
              ),
              // padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
              padding: const EdgeInsets.fromLTRB(50, 50, 50, 80), // ⬅️ Increase bottom padding here
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Phone Number Field
                  const Text('Phone Number', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      hintText: 'Enter your phone number',
                      filled: true,
                      fillColor: AppColors.grey,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 10),

                  // OTP Field & Send OTP Button
                  const Text('OTP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: otpController,
                          decoration: InputDecoration(
                            hintText: 'Enter OTP',
                            filled: true,
                            fillColor: AppColors.grey,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 15),
                      ElevatedButton(
                        onPressed: countdown > 0 || isSendingOtp
                            ? null
                            : () async {
                              
                                setState(() {
                                  isSendingOtp = true;
                     });
                               final phoneNumber = phoneController.text.trim();
                                final isValid = phoneNumber.startsWith("+91") &&

                                    phoneNumber.length == 13 &&
                                    RegExp(r'^[6-9]\d{9}$').hasMatch(phoneNumber.substring(3));

                                if (isValid) {
                                   setState(() {
                                                     lastPhoneNumber = phoneNumber;
                                          });
                                  try {
                                    await authNotifier.verifyPhoneNumber(phoneNumber, ref);
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP sent successfully!')));
                                    startOtpCountdown(); // Start countdown
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to send OTP: $e')));
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a valid 10-digit phone number.')));
                                }

                                setState(() {
                                  isSendingOtp = false;
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0E7AAB),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                        ),
                        child: isSendingOtp
                            ? const CircularProgressIndicator(color: AppColors.white, strokeWidth: 2)
                            : Text(countdown > 0 ? '$countdown sec'  : (lastPhoneNumber == phoneController.text.trim() ? 'Resend OTP' : 'Send OTP'),
                            style: const TextStyle(color: AppColors.white, fontSize: 16),
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
                          ? () async 
                          {
                            String smsCode = otpController.text.trim();
                            if (smsCode.isNotEmpty){
                              setState(() {
                                isLoggingIn = true;
                              });

                              try {
                                await 
                                ref.read(loginProvider.notifier).signInWithPhoneNumber(otpController.text.trim(), ref);
                                // ✅ Stop the Timer
                                     if (_timer != null && _timer!.isActive) {
                                          _timer!.cancel();
                                        }

                                      
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("OTP Verified Successfully!")));
                                if (context.mounted&& (accessToken != null && accessToken.isNotEmpty) 
                                // && (authNotifierLogin.data![0].details!.status=='Active'||authNotifierLogin.data![0].details!.status=='active')
                                ) {
                                  final role = authNotifierLogin.data![0].details?.role?.toLowerCase();
                                      if (role == 'distributor') {
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardDistributorScreen()));
                                    } else if (role == 'serviceEngineer') {
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardPage()));
                                    
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Unknown role. Please contact support.')),
                                      );
                                    }
                                    
                                    
                                    }

                                
                                } on FirebaseAuthException catch (e) {
                                  setState(() {
                                 isLoggingIn  = false;
                                         });

                                    String errorMessage = 'Verification failed. Please try again.';
                                    if (e.code == 'invalid-verification-code') {
                                      errorMessage = 'The OTP you entered is incorrect.';
                                    } else if (e.code == 'session-expired') {
                                      errorMessage = 'OTP session expired. Please request a new one.';
                                    }

                                   ScaffoldMessenger.of(context).showSnackBar(
                                   SnackBar(
                                   content: Text(errorMessage),
                                    backgroundColor: AppColors.error,
                               ),
                               );
                                
                              } catch (e,stackTrace) {
                                   setState(() {
                                     isLoggingIn  = false; // Stop loading if there was an error
                                   });

                                   FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'OTP verification error');
                                  // Show error message if OTP verification fails
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("An error occurred: $e"),
                                    backgroundColor: AppColors.error,),
                                  );
                                
                              } 
                              }else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Please enter the OTP."),
                                  backgroundColor: AppColors.error,),
                                );
                              }
                              setState(() {
                                isLoggingIn = false;
                              });
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isOtpEntered ? AppColors.info : AppColors.grey,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: isLoggingIn ? const CircularProgressIndicator(color: AppColors.white, strokeWidth: 2) : const Text('Verify'),
                    ),
                  ),
                  const SizedBox(height: 19),

                  // Register Link
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
                      },
                      child: const Text("Don't have an account? Register Here", style: TextStyle(fontSize: 12)),
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