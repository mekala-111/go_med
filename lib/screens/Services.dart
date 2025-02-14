import 'package:flutter/material.dart';
import 'package:go_med/providers/serviceProvider.dart';
import 'package:go_med/screens/BottomNavBar.dart';
import 'package:go_med/screens/dashboard.dart';
import 'package:go_med/screens/services_edit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServicesPage extends ConsumerStatefulWidget {
  const ServicesPage({super.key});
  @override
  ConsumerState<ServicesPage> createState() => productScreenState();
}

class productScreenState extends ConsumerState<ServicesPage> {
  // @override
  // void initState() {
  //   super.initState();
  //   Future.microtask(() => ref.read(serviceProvider.notifier).getSevices());
  //   print('init state excuteded for geting services...........');
  // }
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      ref.read(serviceProvider.notifier).getSevices();
    });

    print('init state executed for getting services...........');
  }

  @override
  Widget build(BuildContext context) {
    return
        // WillPopScope(
        //   onWillPop: () async {
        //     // Navigate to DashboardPage when back button is pressed
        //     Navigator.pushReplacement(
        //       context,
        //       MaterialPageRoute(builder: (context) => const DashboardPage()),
        //     );
        //     return false; // Prevent default back navigation
        //   },
        //   child:
        Scaffold(
      backgroundColor: const Color(0xFFE8F7F2),
      appBar: AppBar(
         leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
          },
        ),

      title: const Text("Services"),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Current services",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ServicesPageEdit()),
                    );
                  },
                  child: const Text(
                    "Add Services",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 6, // Adjust based on the number of services
                itemBuilder: (context, index) {
                  bool isActive = index % 2 ==
                      0; // Just for example, make alternate items active/inactive
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
                            "Full Body Checkup",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text("Duration: 60 minutes",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white)),
                          const SizedBox(height: 4),
                          const Text(
                            "₹1500",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isActive ? "Active" : "Inactive",
                                style: TextStyle(
                                  color: isActive ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.white),
                                onPressed: () {
                                  // Handle edit action
                                },
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
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 4),
    );
  }
}
