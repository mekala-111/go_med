import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_med/providers/serviceProvider.dart';
import 'package:go_med/screens/BottomNavBar.dart';
import 'package:go_med/screens/dashboard.dart';
import 'package:go_med/screens/services_edit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_med/model/servicesState.dart';
import '../model/servicesState.dart';
import 'package:go_med/providers/products.dart'; // Import product provider

class ServicesPage extends ConsumerStatefulWidget {
  const ServicesPage({super.key});
  @override
  ConsumerState<ServicesPage> createState() => ServiceScreenState();
}

class ServiceScreenState extends ConsumerState<ServicesPage> {
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
    final servicestate = ref.watch(serviceProvider).data ?? [];
    final products = ref.watch(productProvider).data ?? [];

    // Create a map of productId -> productName for easy lookup
    final productMap = {
      for (var p in products) p.productId ?? "": p.productName ?? "Unknown"
    };

    return Scaffold(
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
                itemCount: servicestate.length,
                itemBuilder: (context, index) {
                  final service = servicestate[index];
                  return _buildServiceCard(
                      context, service, productMap ,ref// Pass product map
                      );
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 4),
    );
  }
}

Widget _buildServiceCard(
    BuildContext context, Data service, Map<String, String> productMap,WidgetRef ref) {

  bool _showAllProducts = false;


  List<String> productNames = (service.productIds ?? [])
      .map((id) => productMap[id] ?? "")
      .toList();

  return StatefulBuilder(
    builder: (context, setState) {
      return Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0x401BA4CA),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Name and Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    service.name ?? '',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Text(
                  '₹${service.price ?? 0}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Service Details
            Text(
              'Details: ${service.details ?? ''}',
              style: const TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 8),

            // If only ONE product, show in the same row with edit & delete buttons
            if (productNames.length == 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    productNames.first,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              )

            // If multiple products, show normally and put buttons separately
            else ...[
              const Text(
                "Product Names:",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue),
              ),
              ...(_showAllProducts ? productNames : productNames.take(2)).map(
                (product) => Text(
                  product,
                  style: const TextStyle(fontSize: 14),
                ),
              ),

              const SizedBox(height: 4),

              // "See More / See Less" Button + Edit & Delete Icons (in separate row)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (productNames.length > 2)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showAllProducts = !_showAllProducts;
                        });
                      },
                      child: Text(
                        _showAllProducts ? "See Less" : "See More",
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.lightBlue),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            'servicepageedit',
                            arguments: {
                              'type': "edit",
                              'name': service.name,
                              'price': service.price.toString(),
                              'details': service.details,
                              'productIds':service.productIds,
                              'serviceId':service.sId
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Handle delete action
                          _showConfirmationDialog(
                            context,
                            'Delete',
                            'Are you sure you want to delete this service?',
                            () {
                              // Delete the service
                              // final container =
                              //     ProviderScope.containerOf(context);
                              // container
                                 ref.read(serviceProvider.notifier)
                                  .deleteService(service.sId);
                                  
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ],
        ),
      );
    },
  );
}

void _showConfirmationDialog(BuildContext context, String action,
    String message, VoidCallback onConfirmed) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(action),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirmed();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
