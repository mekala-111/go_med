import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_med/screens/BottomNavBar.dart';
import 'package:go_med/screens/LoginPage.dart';
import 'package:go_med/screens/dashboard.dart';
import 'package:go_med/screens/Profile.dart';
import '../providers/logout_notifier.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logoutNotifier = ref.read(logoutProvider.notifier);

    return WillPopScope(
      onWillPop: () async {
        // Navigate to DashboardPage when back button is pressed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
        return false; // Prevent default back navigation
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFC0C0C2),
        appBar: AppBar(
          backgroundColor: const Color(0x802E3236),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DashboardPage()),
              );
            },
          ),
          title: const Text(
            "Settings",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.black),
              onPressed: () {
                // Handle notification press
              },
            ),
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                // Handle menu press
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: const Text(
                  "Profile settings",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              ListTile(
                title: const Text(
                  "Payment history",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  // Navigate to Payment history
                },
              ),
              const SizedBox(height: 10),
              ListTile(
                title: const Text(
                  "Notification settings",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  // Navigate to Notification settings
                },
              ),
              const SizedBox(height: 10),
              ListTile(
                title: const Text(
                  "Wallet",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  // Navigate to Wallet
                },
              ),
              const SizedBox(height: 20),
              ListTile(
                title: Center(
                  child: ElevatedButton(
                    onPressed: () => logoutNotifier.logout(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1BA4CA), // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30), // Adjust padding
                    ),
                    child: const Text(
                      'Log Out',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white, // Text color
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle leave a review
                },
                child: const Text(
                  "Leave a Review",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFD2F1E4),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  // Handle Delete Account
                },
                child: const Text(
                  textAlign: TextAlign.center,
                  "Delete Account",
                  style: TextStyle(
                    
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavBar(currentIndex: 5),
      ),
    );
  }
}
