import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_med/constants/app_colors.dart';
import 'package:go_med/screens/Ditributor_screens/Distributor_products_Bookings.dart';
import 'package:go_med/screens/BottomNavBar.dart';
import 'package:go_med/screens/Services.dart';
import 'package:go_med/screens/Ditributor_screens/products_scrren.dart';
import '../../providers/Distributor_provider/bookings_provider.dart';
import '../../screens/Ditributor_screens/wallet_screen.dart';

/// Sample Product model
class Product {
  final String name;
  final int stock;

  Product({required this.name, required this.stock});
}

/// Sample provider with some dummy products/spareparts and their stock counts
final productsProvider = StateProvider<List<Product>>((ref) {
  return [
    Product(name: "Product A", stock: 3),
    Product(name: "Product B", stock: 10),
    Product(name: "Sparepart C", stock: 5),
    Product(name: "Sparepart D", stock: 2),
    Product(name: "Product E", stock: 7),
  ];
});

class DashboardDistributorScreen extends ConsumerWidget {
  const DashboardDistributorScreen({super.key});

  bool _isToday(String? dateString) {
    if (dateString == null || dateString.isEmpty) return false;
    final date = DateTime.tryParse(dateString);
    if (date == null) return false;

    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);
    final products = ref.watch(productsProvider);

    // Count today's completed bookings (all types)
    final todayCompletedCount = bookingState.data
        .where((booking) =>
            booking.status?.toLowerCase() == 'completed' && _isToday(booking.createdAt))
        .length;

    // Count today's completed sparepart bookings (same for demo)
    final todayCompletedSparepartCount = bookingState.data
        .where((booking) =>
            booking.status?.toLowerCase() == 'completed' &&
            _isToday(booking.createdAt))
        .length;

    // Count products/spareparts with stock <= 5
    final lowStockCount = products.where((p) => p.stock <= 5).length;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
  backgroundColor:AppColors.gomedcolor,// light greenish like your screenshot
  elevation: 0, // no shadow, matches flat design
  toolbarHeight: 60, // adjust as needed
  automaticallyImplyLeading: false,
  title: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // Logo in a circular container
      Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          color: AppColors.black,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: ClipOval(
            child: Image.asset(
              "assets/images/logo.jpg",
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      // Notification Icon
      IconButton(
        icon: const Icon(Icons.notifications_active, color: AppColors.black,size: 30,),
        onPressed: () {},
      ),
    ],
  ),
),

     
      body: 
      // bookingState.statusCode == 0
      //     ? const Center(child: CircularProgressIndicator())
      //     : 
          RefreshIndicator(
              onRefresh: () => ref.read(bookingProvider.notifier).getBookings(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       const SizedBox(height: 10),
                      SizedBox(
                        height: 60,
                        child: const DashboardButtonRow(),
                      ),
                      const SizedBox(height: 20),
                      const NotificationsHeader(),
                      const SizedBox(height: 20),
                      const NotificationsContainer(),
                      const SizedBox(height: 20),
                      const Text("Overview:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      OverviewItems(
                        todayCompletedCount: todayCompletedCount,
                        todayCompletedSparepartCount: todayCompletedSparepartCount,
                        lowStockCount: lowStockCount,
                      ),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class DashboardButtonRow extends StatelessWidget {
  const DashboardButtonRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        
        children: [
          DashboardButton(
            label: "Booked\nProducts",
            fontSize: 15,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BookingsScreen()),
              );
            },
          ),
          const SizedBox(width: 15),
          DashboardButton(
            label: "Booked\nSpareparts",
            fontSize: 15,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductScreen()),
              );
            },
          ),
          const SizedBox(width: 15),
          DashboardButton(
            label: "Requested\nPro-spa",
            fontSize: 15,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BookingsScreen()),
              );
            },
          ),
          const SizedBox(width: 15),
          DashboardButton(
            label: "Wallet\nAmount",
            fontSize: 15,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WalletScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DashboardButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final double fontSize;

  const DashboardButton({super.key, required this.label, this.onTap, this.fontSize = 10});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        decoration: BoxDecoration(
          color: AppColors.info,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.white,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}

class NotificationsHeader extends StatelessWidget {
  const NotificationsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Alerts and Notifications", style: TextStyle(fontWeight: FontWeight.bold)),
        Text("View all", style: TextStyle(color: AppColors.buttonPrimary)),
      ],
    );
  }
}

class NotificationsContainer extends StatelessWidget {
  const NotificationsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("You have 3 new bookings for tomorrow.",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          SizedBox(height: 5),
          Text("Inventory low: 2 products need restocking",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          SizedBox(height: 5),
          Text("Verification pending: Complete your profile to get verified.",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}

class OverviewItems extends StatelessWidget {
  final int todayCompletedCount;
  final int todayCompletedSparepartCount;
  final int lowStockCount;

  const OverviewItems({
    super.key,
    required this.todayCompletedCount,
    required this.todayCompletedSparepartCount,
    required this.lowStockCount,
  });

  @override
  Widget build(BuildContext context) {
    return 
    Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child:Column(
      children: [
        const OverviewItem(label: "Earnings Today", value: "₹125"),
        OverviewItem(label: "Product Bookings Today", value: todayCompletedCount.toString()),
        OverviewItem(label: "Sparepart Bookings Today", value: todayCompletedSparepartCount.toString()),
        OverviewItem(label: "Products Low in Stock", value: lowStockCount.toString()),
        const OverviewItem(label: "Pending Reviews", value: "45"),
      ],
      )
    );
  }
}

class OverviewItem extends StatelessWidget {
  final String label;
  final String value;

  const OverviewItem({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
