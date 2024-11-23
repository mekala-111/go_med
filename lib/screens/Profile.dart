import 'package:flutter/material.dart';
import 'package:go_med/screens/BottomNavBar.dart';
import 'package:go_med/screens/dashboard.dart';
import 'package:go_med/screens/Profile_setup.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to DashboardPage when back button is pressed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
        return false; // Prevent default back navigation
      },
      child: 
    Scaffold(
      backgroundColor: const Color(0xFFF4F4F9), // Light background color
      appBar: AppBar(
        backgroundColor: const Color(0x802E3236), // App bar color
        elevation: 0,
        title: Row(
          children: [
            const Text("Profile", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey, // Bottom border color
            height: 1.0, // Bottom border thickness
          ),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("images/logo.png"), // Replace with actual image
            ),
            SizedBox(height: 10),
            ProfileHeader(),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                "As a Flutter Developer, you will be responsible for developing cross-platform mobile apps using the Flutter framework, ensuring performance, usability, and code quality. Key Responsibilities: Collaborate with cross-functional teams to understand project requirements and objectives.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black45),
              ),
            ),
            SizedBox(height: 20),
            Divider(color: Colors.grey),
            SizedBox(height: 10),
            BusinessDetailsSection(),
            SizedBox(height: 20),
            Divider(color: Colors.grey),
            VerificationSection(),
          ],
        ),
      ),
    
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    ),
    );

  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            // Action for Hide button
          },
          icon: const Icon(Icons.visibility_off, color: Colors.black),
          iconSize: 30,
        ),
        const SizedBox(width: 10), // Space between Hide button and name
        const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Go Code Designers", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Text("@gocodedesigner", style: TextStyle(color: Colors.grey)),
          ],
        ),
        const SizedBox(width: 20),
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.black),
          iconSize: 30,
          onPressed: () {
               Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileSetupPage()),
            );
            // Settings action
          },
        ),
      ],
    );
  }
}

class BusinessDetailsSection extends StatelessWidget {
  const BusinessDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Business Details", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        DetailItem(label: "Phone Number", value: "+91 9502105833"),
        DetailItem(label: "Email", value: "gocode@gocodecreations.com"),
        DetailItem(label: "Delivery Address", value: "GoCode Designers Private limited, DD Colony, Hyderabad, Telangana - 500044"),
      ],
    );
  }
}

class DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const DetailItem({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Colors.black54))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold))),
          const Icon(Icons.edit, color: Colors.grey, size: 16),
        ],
      ),
    );
  }
}

class VerificationSection extends StatelessWidget {
  const VerificationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Verification Section :", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        const Row(
          children: [
            Text("Verification Status:", style: TextStyle(color: Colors.black54)),
            SizedBox(width: 8),
            Text("Pending/Verified", style: TextStyle(color: Colors.orange)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text("Submit ID Proof for Verification:", style: TextStyle(color: Colors.black54)),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                // Upload function
              },
              child: const Text("upload", style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          "Please upload a government-issued ID for verification.\nVerification will take 24-48 hours.",
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}
