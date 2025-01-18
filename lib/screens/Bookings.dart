import 'package:flutter/material.dart';
import 'package:go_med/screens/BottomNavBar.dart';
import 'package:go_med/screens/dashboard.dart';


class BookingsPage extends StatelessWidget {
  const BookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to DashboardPage when back button is pressed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
        return false; // Prevent default back navigation
      },
      child: Scaffold(
         backgroundColor:  const Color(0xFFE8F7F2), 
        appBar: AppBar(
          title: const Text("Bookings",
          style: TextStyle(color: Colors.white,
        
          ),
          ),
          backgroundColor: const Color(0xFF6BC37A),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {},
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ToggleButtons(
                isSelected: const [true, false, false],
                selectedColor: const Color(0x802E3236),
                fillColor: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('All'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Upcoming'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Past'),
                  ),
                ],
                onPressed: (index) {
                  // Handle toggle button selection here
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Upcoming Bookings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("View All Bookings"),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 3, // Adjust based on data
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0x401BA4CA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Albert Flores",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              color: Colors.white,
                              ),
                            ),
                            const Text("Full Body Checkup",
                             style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                            const Text(
                              "15 May 2020 8:30 am",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                  onPressed: () {},
                                  child: const Text("Confirm",
                                   style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0x802E3236),
                                    foregroundColor: Colors.black,
                                  ),
                                  onPressed: () {},
                                  child: const Text("Reschedule",
                                   style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () {},
                                  child: const Text("Cancel",
                                   style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Divider(),
              const Text(
                'Past Bookings',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                'You have completed 12 bookings this month.',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0x401BA4CA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Client Name: Jane Smith"),
                    Text("Service: Blood Test"),
                    Text("Completed on: Sept 5, 2024"),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Booking Status Updates',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                'Booking confirmed for [Client Name] on [Date/Time].\nBooking canceled for [Client Name] on [Date/Time].',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff00ba4ca),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: const Center(
                  child: Text("Add New Booking",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavBar(currentIndex: 2),
      ),
    );
  }
}
