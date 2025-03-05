import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_med/providers/auth_provider.dart';
import 'package:go_med/screens/Services.dart';
import 'package:go_med/screens/Service_engineer.dart';
import 'package:go_med/screens/dashboard.dart';
import 'package:go_med/screens/Bookings.dart';
import 'package:go_med/screens/products_scrren.dart';
import 'package:go_med/screens/settings.dart';

import 'package:go_med/model/login_auth_state.dart';

class BottomNavBar extends ConsumerWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  void navigateTo(BuildContext context, int index, String role) {
    if (index == currentIndex) return; // ✅ Prevents infinite navigation loop

    Widget page;

    switch (index) {
      case 0:
        page = const DashboardPage();
        break;
      case 1:
        page = const BookingsPage();
        break;
      case 2:
        page = const ProductScreen();
        break;
      case 3:
        page = (role == 'serviceEngineer') 
          ? const ServicesEngineerPage() // ✅ Go to ServiceEngineerPage
          : const ServicesPage(); // ✅ Go to ServicesPage for other roles
        break;
      case 4:
        page = const SettingsPage();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  int _getCurrentIndex(BuildContext context, String role) {
    final route = ModalRoute.of(context)?.settings.name;
    
    if (route == "/dashboard") return 0;
    if (route == "/bookings") return 1;
    if (route == "/products") return 2;
    if (route == "/services") return 3;
    if (route == "/settings") return 4;

    return 0; // Default to Home if no match
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModel = ref.watch(loginProvider); // ✅ Fetch user data
    final role = userModel.data?.first.details?.role ?? '';

    List<BottomNavigationBarItem> items = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      const BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Bookings'),
      const BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Product'),
      const BottomNavigationBarItem(
          icon: Icon(Icons.miscellaneous_services), label: 'Services'),
      const BottomNavigationBarItem(
          icon: Icon(Icons.settings), label: 'Settings'),
    ];

    return BottomNavigationBar(
      currentIndex: _getCurrentIndex(context, role),
      backgroundColor: const Color(0xFF6BC37A),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.white,
      onTap: (index) => navigateTo(context, index, role),
      items: items,
    );
  }
}
