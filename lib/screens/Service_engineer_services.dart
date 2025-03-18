// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:go_med/providers/engineer_service.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_med/providers/serviceProvider.dart';
// import 'package:go_med/screens/BottomNavBar.dart';

// class ServicesEngineerPage extends ConsumerStatefulWidget {
//   const ServicesEngineerPage({super.key});

//   @override
//   ConsumerState<ServicesEngineerPage> createState() => ServiceScreenState();
// }

// class ServiceScreenState extends ConsumerState<ServicesEngineerPage> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       ref.read(engineerServiceProvider.notifier).getUsers();
//       ref.read(serviceProvider.notifier).getSevices();

//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final ServiceEngineers = ref.watch(engineerServiceProvider);
//     print('engineerservices........$ServiceEngineers');
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Spare Part Details"),
//         backgroundColor: const Color(0xFF6BC37A),
//       ),
//       body: const Center(
//         child: Text("Welcome to the Service Engineer Page"),
//       ),
//       bottomNavigationBar: const BottomNavBar(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_med/providers/engineer_service.dart';
import 'package:go_med/providers/serviceProvider.dart';
import 'package:go_med/providers/auth_provider.dart'; // Import loginProvider to get logged-in user data
import 'package:go_med/screens/BottomNavBar.dart';

class ServicesEngineerPage extends ConsumerStatefulWidget {
  const ServicesEngineerPage({super.key});

  @override
  ConsumerState<ServicesEngineerPage> createState() => ServiceScreenState();
}

class ServiceScreenState extends ConsumerState<ServicesEngineerPage> {
  String? loggedInEngineerId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(engineerServiceProvider.notifier).getUsers();
      ref.read(serviceProvider.notifier).getSevices();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Fetch logged-in user data
    final loginData = ref.watch(loginProvider).data ?? [];
    loggedInEngineerId = loginData.isNotEmpty ? loginData[0].details?.sId : null;
    print('Logged-in Engineer ID: $loggedInEngineerId');

    final engineers = ref.watch(engineerServiceProvider);
    final services = ref.watch(serviceProvider);

    // Find logged-in engineer
    // final loggedInEngineer = engineers.data
    //     ?.firstWhere((engineer) => engineer.sId == loggedInEngineerId, orElse: () => null);
    final loggedInEngineer = engineers.data
    ?.where((engineer) => engineer.sId == loggedInEngineerId)
    .isNotEmpty == true
    ? engineers.data!.firstWhere((engineer) => engineer.sId == loggedInEngineerId)
:null;

    // Filter services for this engineer
    final filteredServices = services.data
            ?.where((service) => service.sId == loggedInEngineerId)
            .toList() ??
        [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Services"),
        backgroundColor: const Color(0xFF6BC37A),
      ),
      body: loggedInEngineer == null
          ? const Center(child: Text("No service engineer found."))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome, ${loggedInEngineer.name ?? "Engineer"}",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Display services in a list
                  filteredServices.isEmpty
                      ? const Text("No services found for this engineer.")
                      : Expanded(
                          child: ListView.builder(
                            itemCount: filteredServices.length,
                            itemBuilder: (context, index) {
                              final service = filteredServices[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 3,
                                child: ListTile(
                                  title: Text(service.name ?? "Service"),
                                  subtitle: Text(service.details ?? "No description"),
                                  trailing: Text("₹${service.price ?? "0.00"}"),
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
