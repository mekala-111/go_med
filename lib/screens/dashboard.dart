import 'package:flutter/material.dart';
import 'package:go_med/screens/Distributor_products_Bookings.dart';
import 'package:go_med/screens/BottomNavBar.dart';
import 'package:go_med/screens/Services.dart';
import 'package:go_med/screens/products_scrren.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    var role;
    return Scaffold(
      backgroundColor: const Color(0xFFE8F7F2), // Background color
      appBar: AppBar(
        backgroundColor:
            const Color(0xFF6BC37A), // Green color from the screenshot

        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo with white background and rounded corners
            Container(
              padding:
                  const EdgeInsets.all(8.0), // Padding for the white background
              decoration: BoxDecoration(
                color: Colors.white, // White background for the logo
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              child: SizedBox(
                width: 90, // Adjust width of the logo
                height: 30, // Adjust height of the logo
                child: Image.asset(
                  "images/logo.jpg", // Your logo path here
                  fit: BoxFit.contain, // Ensures logo fits properly
                ),
              ),
            ),
            // Status and notification section
            IconButton(
              icon: const Icon(Icons.notifications,
                  color: Colors.black), // Notification icon
              onPressed: () {},
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(
                0xFF6ACF73), // Green color for the border at the bottom
            height: 1.0, // Border height
          ),
        ),
      ),
      body:const SingleChildScrollView(
        child:  Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Status: ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  Text("Active",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  SizedBox(width: 10),
                ],
              ),
              SizedBox(height: 20),
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
      ),
      bottomNavigationBar: const  BottomNavBar(),
    );
  }
}

class DashboardButtonRow extends StatelessWidget {
  const DashboardButtonRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Makes the Row scroll horizontally
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DashboardButton(
            label: "Manage\nServices",
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const ServicesPage()),
              // );
            },
          ),
         const SizedBox(width: 2,),
          DashboardButton(
            label: "Restock\nProducts",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductScreen()),
              );
            },
          ),
           const SizedBox(width: 2,),
          DashboardButton(
            label: "View\nBookings",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BookingsScreen()),
              );
            },
          ),
           const SizedBox(width: 2,),
          const DashboardButton(label: "Check\nFeedback"),
        ],
      ),
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
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF0E7AAB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(label,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF))),
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
        fillColor: Color(0xFFFFFFFF),
        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
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
        color: const Color(0x80C4E4F7), // Background color from the screenshot
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("You have 3 new bookings for tomorrow.",
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13)),
          SizedBox(height: 5),
          Text("Inventory low: 2 products need restocking",
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13)),
          SizedBox(height: 5),
          Text("Verification pending: Complete your profile to get verified.",
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13)),
        ],
      ),
    );
  }
}

class OverviewItems extends StatelessWidget {
  const OverviewItems({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          OverviewItem(label: "Earnings Today", value: "₹1,25,46,485"),
          OverviewItem(label: "Total Bookings Today", value: "15745"),
          OverviewItem(label: "Products Low in Stock", value: "45"),
          OverviewItem(label: "Pending Reviews", value: "45"),
        ],
      ),
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
