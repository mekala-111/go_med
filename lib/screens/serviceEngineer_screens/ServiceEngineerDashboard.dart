import 'package:flutter/material.dart';
import 'package:go_med/screens/Ditributor_screens/Distributor_products_Bookings.dart';
import 'package:go_med/screens/BottomNavBar.dart';
import 'package:go_med/screens/Profile.dart';
import 'package:go_med/screens/Services.dart';
import 'package:go_med/screens/Ditributor_screens/products_scrren.dart';
import 'package:go_med/screens/serviceEngineer_screens/Service_engineer_services.dart';
import 'package:go_med/screens/serviceEngineer_screens/serviceEnginnersparepartbooking.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    var role;
    return Scaffold(
      backgroundColor: const Color(0xFFE8F7F2), // Background color
      appBar: AppBar(
        backgroundColor:
            const Color(0xFF6BC37A), // light greenish like your screenshot
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
              decoration: BoxDecoration(
                color: Colors.black,
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
              icon: const Icon(
                Icons.notifications_active,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
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
              // SizedBox(height: 10),
              DashboardButtonRow(),
              // SizedBox(height: 20),
              // SearchField(),
              
              
              SizedBox(height: 10),
              Text("Overview:", style: TextStyle(fontWeight: FontWeight.bold)),
              // SizedBox(height: 10),
              OverviewItems(),
              // SizedBox(height: 20),
              NotificationsHeader(),
              SizedBox(height: 10),
              NotificationsContainer(),
            ],
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
    return
        // SingleChildScrollView(

        //     scrollDirection: Axis.horizontal,
        //     child:
        //   Padding(
        // padding: const EdgeInsets.all(4), // ⬅️ Add padding here
        // child:
        Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.44,
          height: 100,
          child: DashboardButton(
            label: "Manage\nProfile",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const  ProfilePage()),
              );
            },
          ),
        ),
        const SizedBox(width: 10), // spacing between the boxes
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.44,
          height: 100,
          child: DashboardButton(
            label: "Restock\nspareparts",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Serviceenginnersparepartbooking()),
              );
            },
          ),
        ),
      ],
    );
    // );

    //  const SizedBox(width: 2,),
    // DashboardButton(
    //   label: "View\nBookings",
    //   onTap: () {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) => const BookingsScreen()),
    //     );
    //   },
    // ),
    //  const SizedBox(width: 2,),
    // const DashboardButton(label: "Check\nFeedback"),

    // );
  }
}

class DashboardButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const DashboardButton({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF0E7AAB),
            borderRadius: BorderRadius.circular(12),
          ),
          // padding: const EdgeInsets.all(12),
          child: Center( // ⬅️ Center b
          child: Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF))),
        ),
      ),
      )
    );
  }
}

// class SearchField extends StatelessWidget {
//   const SearchField({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const TextField(
//       decoration: InputDecoration(
//         hintText: "Search",
//         prefixIcon: Icon(Icons.search),
//         border: OutlineInputBorder(),
//         filled: true,
//         fillColor: Color(0xFFFFFFFF),
//         contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
//       ),
//     );
//   }
// }

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
    return Column(
      children: const [
        SingleNotificationCard(
          message: "You have 3 new bookings for tomorrow.",
        ),
        SingleNotificationCard(
          message: "Inventory low: 2 products need restocking",
        ),
        SingleNotificationCard(
          message: " Complete your profile to get verified.",
        ),
      ],
    );
  }
}
class SingleNotificationCard extends StatelessWidget {
  final String message;

  const SingleNotificationCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 80, // ⬅️ Set fixed height
      width: double.infinity, // ⬅️ Full width of parent

      child: Container(
        margin: const EdgeInsets.only(bottom: 12), // space between cards
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0x80C4E4F7), // semi-transparent blue
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ),
    );
  }
}


class OverviewItems extends StatelessWidget {
  const OverviewItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color:const Color(0x80C4E4F7),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OverviewItem(label: "Total Bookings Today", value: "15745"),
          SizedBox(height: 12),
          OverviewItem(label: "Products Low in Stock", value: "45"),
          SizedBox(height: 12),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
