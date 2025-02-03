import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_med/providers/auth_provider.dart';
import 'package:go_med/screens/BottomNavBar.dart';

import 'package:go_med/screens/dashboard.dart';
import 'package:go_med/screens/Profile.dart';
import '../providers/logout_notifier.dart';
import '../screens/LoginPage.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logoutNotifier = ref.read(logoutProvider.notifier);

    return 
    // WillPopScope(
    //   onWillPop: () async {
    //     // Navigate to DashboardPage when back button is pressed
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => const DashboardPage()),
    //     );
    //     return false; // Prevent default back navigation
    //   },
      // child:
       Scaffold(
        backgroundColor: const Color(0xFFE8F7F2),
        appBar: AppBar(
          backgroundColor: const Color(0xFF6BC37A),
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
        body: SingleChildScrollView( // Make the body scrollable
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
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
                        builder: (context) => const  ProfilePage(),
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
                    child:ElevatedButton(
  onPressed: () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                logoutNotifier.logout(context); // Call logout function
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF1BA4CA), // Button color
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), // Rounded corners
    ),
    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30), // Adjust padding
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
                      color: Color.fromARGB(255, 79, 177, 137),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      // decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    // Handle Delete Account
                  _showDeleteAccountDialog(context,ref);
  
                  },

                  child: const Text(
                    textAlign: TextAlign.center,
                    "Delete Account",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      // decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),



        
        bottomNavigationBar: const BottomNavBar(currentIndex: 5),
      
    );
  }
  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
  final userModel = ref.read(loginProvider); // Retrieve UserModel from the provider
  final userId = userModel.data?[0].user!.sId; // Get user ID, default to empty string if null
  final token = userModel.data?[0].accessToken; // Get token, default to empty string if null


  //    if (userId.isEmpty || token.isEmpty) {
  //   print("User ID or token is missing.");
  //   return;
  // }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
               // Close the dialog
           ref.read(loginProvider.notifier).deleteAccount(userId,token);
               // Call the delete account method
                _removeAccount(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}
 void _removeAccount(BuildContext context) {
    // Add your account deletion logic here (e.g., API call or local storage update)

    // Example: Show a snackbar and navigate back
    Navigator.of(context).pop(); // Close the dialog
    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Account deleted successfully')),
    );

    // Navigate to login or onboarding page after account deletion
   // Navigator.of(context).pushReplacementNamed('/loginscreen');
   
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  LoginScreen()),
        );
      
  }
}
