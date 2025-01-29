import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:go_med/providers/firebase_auth.dart';
import 'package:go_med/screens/dashboard.dart';
import 'package:go_med/screens/product_edit.dart';
import 'screens/LoginPage.dart';
import 'firebase_options.dart';
import 'package:go_med/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  options:
  DefaultFirebaseOptions.currentPlatform;
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

            final authState =
                ref.watch(loginProvider); 
                // Watch the authentication state
                  // Check for a valid access token
             final accessToken = authState.data?.isNotEmpty == true ? authState.data![0].accessToken : null;
            
             print('token/main $accessToken');
            // Check if the user has a valid refresh token
            if (accessToken != null && accessToken.isNotEmpty) {
              return const DashboardPage(); // User is authenticated, redirect to Home
            } else {
              print('No valid refresh token, trying auto-login');
            }


            

            // Attempt auto-login if refresh token is not available
            return FutureBuilder<bool>(
              future: ref
                  .read(loginProvider.notifier)
                  .tryAutoLogin(), // Attempt auto-login
              builder: (context, snapshot) {
                print(
                    'Token after auto-login attempt: $accessToken');

                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While waiting for auto-login to finish, show loading indicator
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData &&
                    snapshot.data == true &&
                     ( accessToken != null && accessToken.isNotEmpty)
                     ) {
                  // If auto-login is successful and refresh token is available, go to Dashboard
                  return const DashboardPage();
                } else {
                  // If auto-login fails or no token, redirect to LoginScreen
                  return LoginScreen();
                }
              },
            );
          },
        ),
        routes: {
          "addproductscreen":(context)=>const AddProductScreen(),        }
        );
    // This trailing comma makes auto-formatting nicer for build methods.
  }
}
