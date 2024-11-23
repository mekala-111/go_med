import 'package:flutter/material.dart';
import 'package:go_med/screens/Bookings.dart';
import 'package:go_med/screens/BottomNavBar.dart';
import 'package:go_med/screens/Services.dart';
import 'package:go_med/screens/products_scrren.dart';


class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC0C0C2), // Background color
      appBar: AppBar(
        backgroundColor: const Color(0x802E3236),
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage("images/logo.png"),
              radius: 24,
            ),
            const Spacer(),
            const Text("Status : ", style: TextStyle(color: Colors.black)),
            const Text("Active", style: TextStyle(color: Colors.green)),
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
            color: const Color(0x802E3236), // Background color
            height: 1.0, // Adding height for the border
          ),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardButtonRow(),
            SizedBox(height: 20),
            SearchField(),
            SizedBox(height: 20),
            NotificationsHeader(),
            SizedBox(height: 10),
            NotificationsContainer(),
            SizedBox(height: 20),
            Text("Overview:", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            OverviewItems(),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0,),
    );
  }
}

class DashboardButtonRow extends StatelessWidget {
  const DashboardButtonRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DashboardButton(label: "Manage\nServices",
        onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ServicesPage()),
            );
          },
        ),
         DashboardButton(label: "Restock\nProducts",
        onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProductScreen()),
            );
          },
        
        ),
        DashboardButton(
          label: "View\nBookings",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BookingsPage()),
            );
          },
        ),
        const DashboardButton(label: "Check\nFeedback"),
      ],
    );
  }
}

class DashboardButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const DashboardButton({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0x801BA4CA),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return const TextField(
      decoration: InputDecoration(
        hintText: "Search",
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Color(0xFFC0C0C2),
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
        Text("Alerts and Notifications",
            style: TextStyle(fontWeight: FontWeight.bold)),
        Text("View all", style: TextStyle(color: Colors.blue)),
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
        color: const Color(0x801BA4CA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("You have 3 new bookings for tomorrow.",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text("Inventory low: 2 products need restocking",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text("Verification pending: Complete your profile to get verified.",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class OverviewItems extends StatelessWidget {
  const OverviewItems({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        OverviewItem(label: "Earnings Today", value: "₹1,25,46,485"),
        OverviewItem(label: "Total Bookings Today", value: "15745"),
        OverviewItem(label: "Products Low in Stock", value: "45"),
        OverviewItem(label: "Pending Reviews", value: "45"),
      ],
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

