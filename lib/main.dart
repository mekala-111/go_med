import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:go_med/providers/firebase_auth.dart';
import 'package:go_med/screens/Ditributor_screens/dashboard.dart';
import 'package:go_med/screens/product_edit.dart';
import 'package:go_med/screens/serviceEngineer_screens/ServiceEngineerDashboard.dart';
import 'screens/LoginPage.dart';
import 'firebase_options.dart';
import 'package:go_med/providers/auth_provider.dart';
import 'package:go_med/screens/Ditributor_screens/Distributor_products_Bookings.dart';
import 'screens/Ditributor_screens/wallet_screen.dart';

import 'package:go_med/screens/Profile.dart';
import 'package:go_med/screens/Profile_setup.dart';
import 'package:go_med/screens/Register.dart';
import 'package:go_med/screens/Services.dart';

import 'package:go_med/screens/Ditributor_screens/products_scrren.dart';
import 'package:go_med/screens/services_edit.dart';
import 'package:go_med/screens/Ditributor_screens/Distributor_sparepartbookings.dart';
import 'package:go_med/screens/settings.dart';
import 'package:flutter/services.dart'; // Required for screen orientation

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  options:
  // DefaultFirebaseOptions.currentPlatform;
  // final db = FirebaseDatabase.instanceFor(
  //   app: Firebase.app(),
  //   databaseURL: 'https://go-med-9a330-default-rtdb.firebaseio.com/',
  // );
  runApp(
    const ProviderScope(
      // Wrap your app with ProviderScope
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Consumer(
          builder: (context, ref, child) {
            print("build main.dart");

            final authState = ref.watch(loginProvider);
            final user = authState.data?.isNotEmpty == true ? authState.data![0] : null;
            // Watch the authentication state
            // Check for a valid access token
            final accessToken = user?.accessToken;
            final role = user?.details?.role?.toLowerCase();
            final status = user?.details?.status?.toLowerCase();

            print('token/main $accessToken');
            print('status...$status');
            // Check if the user has a valid refresh token
            if (accessToken != null && accessToken.isNotEmpty) {
                  if (status == "active") {
                    if (role == "distributor") {
                      return const DashboardDistributorScreen();
                    } else if (role == "serviceengineer") {
                      return const DashboardPage();
                    }
                  } else {
                    // STATUS = INACTIVE → SHOW MESSAGE
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Account Inactive"),
                          content: const Text("Your account is inactive. Please contact admin."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                    });

                    return LoginScreen();
                  }
                }

            // Attempt auto-login if refresh token is not available
           return FutureBuilder<bool>(
              future: ref.read(loginProvider.notifier).tryAutoLogin(),
              builder: (context, snapshot) {
                print('Token after auto-login attempt: $accessToken');

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Read updated auth state after auto-login
                final newAuth = ref.read(loginProvider);
                final user = newAuth.data?.isNotEmpty == true ? newAuth.data![0] : null;

                final token = user?.accessToken;
                final status = user?.details?.status?.toLowerCase();
                final role = user?.details?.role?.toLowerCase();

                if (snapshot.hasData &&
                    snapshot.data == true &&
                    token != null &&
                    token.isNotEmpty) {

                  if (status == "active") {
                    // USER IS ACTIVE
                    if (role == "distributor") {
                      return const DashboardDistributorScreen();
                    } else if (role == "serviceengineer") {
                      return const DashboardPage();
                    } else {
                      return LoginScreen();
                    }
                  } else {
                    // USER INACTIVE 
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Account Inactive"),
                          content: const Text("Your account is inactive. Please contact admin."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                    });

                    return LoginScreen();
                  }
                }

                // Auto-login failed 
                return LoginScreen();
              },


            );
          },
        ),
        routes: {
          // "addproductscreen": (context) => const AddProductScreen(),
          "productscreen": (context) => const ProductScreen(),
          "loginscreen": (context) => LoginScreen(),
          "dashboardpage": (context) => const DashboardDistributorScreen(),
          "bookingpage": (context) => const BookingsScreen(),
          // "profilesetuppage": (context) => const ProfileSetupPage(),
          "profilepage": (context) => const ProfilePage(),
          "registrationpage": (context) => const RegistrationPage(),
          // "servicepageedit": (context) => const ServicesPageEdit(),
          // "servicepage": (context) => const ServicesPage(),
          "settingspage": (context) => const SettingsPage(),
          "distributorsparepartbooking": (context) =>
              const DistributorSparepartbookings(),
        });
    // This trailing comma makes auto-formatting nicer for build methods.
  }
}
