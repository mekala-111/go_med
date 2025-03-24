import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_med/providers/engineer_service.dart';
import 'package:go_med/providers/serviceProvider.dart';
import 'package:go_med/providers/auth_provider.dart';
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
    final loginData = ref.watch(loginProvider).data ?? [];
    loggedInEngineerId =
        loginData.isNotEmpty ? loginData[0].details?.sId : null;

    final engineers = ref.watch(engineerServiceProvider);
    final services = ref.watch(serviceProvider);

    final loggedInEngineer = engineers.data
                ?.where((engineer) => engineer.sId == loggedInEngineerId)
                .isNotEmpty ==
            true
        ? engineers.data!
            .firstWhere((engineer) => engineer.sId == loggedInEngineerId)
        : null;

    final filteredServices = services.data
            ?.where((service) =>
                loggedInEngineer?.serviceIds?.contains(service.sId) ?? false)
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
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
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
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          print("SERVICE ${service.name}");
                                        },
                                        child: Text(
                                          service.name ?? "Service",
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        service.details ?? "No description",
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "₹${service.price ?? "0.00"}",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green),
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
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
