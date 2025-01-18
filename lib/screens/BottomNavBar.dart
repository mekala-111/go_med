import 'package:flutter/material.dart';
import 'package:go_med/screens/Services.dart';
import 'package:go_med/screens/dashboard.dart';
import 'package:go_med/screens/Bookings.dart';
import 'package:go_med/screens/products_scrren.dart';
import 'package:go_med/screens/Profile.dart';
import 'package:go_med/screens/settings.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  void navigateTo(BuildContext context, int index) {
    if (index == currentIndex) return; // Avoid navigating to the same page

    Widget page;
    switch (index) {
      case 0:
        page = const DashboardPage();
        break;
      case 1:
        page = const ProfilePage();
        break;
      case 2:
        page = const BookingsPage();
        break;
         case 3:
        page = const ProductScreen();
        break;
        case 4:
        page = const ServicesPage();
        break;
         case 5:
        page = SettingsPage();
      // You can add more cases for additional pages like Services and Settings
      default:
        return;
    }

    // Use pushReplacement to avoid stacking pages
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      backgroundColor: const Color(0xFF6BC37A),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.white,
      onTap: (index) => navigateTo(context, index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Bookings'),
        BottomNavigationBarItem(icon: Icon(Icons.inventory),  label: 'Product'),
        BottomNavigationBarItem(icon: Icon(Icons.miscellaneous_services), label: 'Services'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }
}
