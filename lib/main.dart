import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:go_med/providers/firebase_auth.dart';
import 'package:go_med/screens/dashboard.dart';
import 'screens/LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        debugShowCheckedModeBanner: false, // Optional: Disable the debug banner
        routes: {
          '/': (context) {
            return Consumer(
              builder: (context, ref, child) {
                print("build main.dart");
                final authState = ref.watch(phoneAuthProvider);

                // Check if the user has a valid refresh token
                if (authState.firebaseToken != null) {
                  return DashboardPage(); // User is authenticated, redirect to Home
                } else {
                  print('No valid refresh token, trying auto-login');
                }

                // Attempt auto-login if refresh token is not in state
                return FutureBuilder(
                  future: ref.read(phoneAuthProvider.notifier).tryAutoLogin(),
                  builder: (context, snapshot) {
                    print(
                        'Token after auto-login attempt: ${ref.read(phoneAuthProvider).firebaseToken}');
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      ); // Show SplashScreen while waiting
                    } else if (snapshot.hasData &&
                        snapshot.data == true &&
                        authState.firebaseToken != null) {
                      // If auto-login is successful and refresh token is available, go to Home
                      return DashboardPage();
                    } else {
                      // If auto-login fails, redirect to login page
                      return LoginScreen();
                    }
                  },
                );
              },
            );
          },
        });
    // This trailing comma makes auto-formatting nicer for build methods.
  }
}
