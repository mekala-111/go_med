import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  bool isKeyboardVisible = false;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom; // Keyboard height
    final screenHeight = MediaQuery.of(context).size.height;

    isKeyboardVisible = bottomInset > 0;

    return Scaffold(
      backgroundColor: const Color(0xFFC0C0C2), // Gray background
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Logo Section
          Positioned(
            top: isKeyboardVisible ? 30 : screenHeight * 0.10, // Adjust logo position
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'images/logo.png', // Replace with your actual logo path
                width: 580,
                height: 300,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Input Container Section
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: isKeyboardVisible
                ? screenHeight * 0.25 // Position just below the image when keyboard is visible
                : screenHeight * 0.55, // Default position when keyboard is not visible
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0x802E3236), // Dark gray background
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(120), // Top-left curve
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Phone Number Label and TextField
                  _buildLabel('Phone Number'),
                  _buildTextField(
                    hintText: 'Enter your phone number',
                    controller: phoneNumberController,
                  ),
                  const SizedBox(height: 10),

                  // OTP Label and TextField with Verify Button
                  _buildLabel('OTP'),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildTextField(
                          hintText: 'Enter OTP',
                          controller: otpController,
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
          ),
        ],
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
  }) {
    return TextField(
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
    );
  }
}
