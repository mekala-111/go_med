import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  double bottomPadding = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC0C0C2), // Gray background
      resizeToAvoidBottomInset: true,
      body: AnimatedPadding(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); // Dismiss keyboard when tapping outside
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Logo Section
              const SizedBox(height: 50),
              Center(
                child: Image.asset(
                  'images/logo.png', // Replace with your actual logo path
                  width: 300,
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),
              const Spacer(), // Push content to the top and leave space for the form
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0x802E3236), // Dark gray background
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(120), // Top-left curve
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Phone Number Label and TextField
                    _buildLabel('Phone Number'),
                    _buildTextField(
                      hintText: 'Enter your phone number',
                      controller: phoneNumberController,
                      context: context,
                    ),
                    const SizedBox(height: 20),

                    // OTP Label and TextField with Verify Button
                    _buildLabel('OTP'),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildTextField(
                            hintText: 'Enter OTP',
                            controller: otpController,
                            context: context,
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Add OTP verification logic
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0x801BA4CA), // Light teal
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                          ),
                          child: const Text(
                            'Verify',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0x801BA4CA),
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
                    const SizedBox(height: 20),

                    // Registration Link
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to registration
                        },
                        child: const Text(
                          "Don't have an account? Register Here",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Label for Input Fields
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }

  // Reusable TextField
  Widget _buildTextField({
    required String hintText,
    required TextEditingController controller,
    required BuildContext context,
  }) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          // Move screen up when focusing on TextField
          setState(() {
            bottomPadding = MediaQuery.of(context).viewInsets.bottom;
          });
        } else {
          // Reset padding when focus is lost
          setState(() {
            bottomPadding = 0;
          });
        }
      },
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
