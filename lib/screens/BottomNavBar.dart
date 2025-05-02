import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_med/providers/auth_provider.dart';
import 'package:go_med/screens/Service_engineer_services.dart';
import 'package:go_med/screens/dashboard.dart';
import 'package:go_med/screens/Distributor_products_Bookings.dart';
import 'package:go_med/screens/products_scrren.dart';
import 'package:go_med/screens/settings.dart';
import 'package:go_med/screens/serviceEngineerProductsscreen.dart';
import 'package:go_med/screens/Distributor_sparepartbookings.dart';
import '../screens/serviceEngineerBookingsservicesScreeen.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  void navigateTo(BuildContext context, int index, String role) {
    final routes = [
      "/dashboard",
      "/bookings",
      "/products",
      "/distributorsparepartbooking",
      "/settings"
    ];

    if (ModalRoute.of(context)?.settings.name == routes[index]) return;

    Widget page;
    switch (index) {
      case 0:
        page = const DashboardPage();
        break;
      case 1:
        page = (role == 'serviceEngineer')
            ? const Serviceengineerbookingsservicescreeen()
            : const BookingsScreen();
        break;
      case 2:
        page = (role == 'serviceEngineer')
            ? const ServiceEngineerProductsPage()
            : const ProductScreen();
        break;
      case 3:
        page = (role == 'serviceEngineer')
            ? const ServicesEngineerPage()
            : const DistributorSparepartbookings();
        break;
      case 4:
        page = const SettingsPage();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        settings: RouteSettings(name: routes[index]),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final route = ModalRoute.of(context)?.settings.name;

    switch (route) {
      case "/dashboard":
        return 0;
      case "/bookings":
        return 1;
      case "/products":
        return 2;
      case "/distributorsparepartbooking":
        return 3;
      case "/settings":
        return 4;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModel = ref.watch(loginProvider);
    final role = userModel.data?.first.details?.role ?? '';

    return BottomNavigationBar(
      currentIndex: _getCurrentIndex(context),
      backgroundColor: const Color(0xFF6BC37A),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.white,
      selectedIconTheme: const IconThemeData(color: Colors.black, size: 28),
      unselectedIconTheme: const IconThemeData(color: Colors.white, size: 24),
      onTap: (index) => navigateTo(context, index, role),
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Bookings'),
        BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Product'),
        // BottomNavigationBarItem(
        //     icon: Icon(Icons.miscellaneous_services), label: 'Spare Parts'),
         BottomNavigationBarItem(
      icon: const Icon(Icons.miscellaneous_services),
      label: role == 'serviceEngineer' ? 'Services' : 'Spare Parts',
    ),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }
}
