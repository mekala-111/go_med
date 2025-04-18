import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/serviceEnginnerProductsprovider.dart';
import '../providers/serviceengineer_booking_services_provide.dart';
import '../screens/BottomNavBar.dart';

class Serviceengineerbookingsservicescreeen extends ConsumerStatefulWidget {
  const Serviceengineerbookingsservicescreeen({super.key});

  @override
  ConsumerState<Serviceengineerbookingsservicescreeen> createState() =>
      _ServiceScreenState();
}

class _ServiceScreenState
    extends ConsumerState<Serviceengineerbookingsservicescreeen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(serviceEngineerBookingServicesProvider.notifier)
          .getServiceEnginnerBookingServices();
      ref
          .read(serviceEngineerProductsProvider.notifier)
          .getServiceEnginnerProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final serviceBooking = ref.watch(serviceEngineerBookingServicesProvider);
    final productState = ref.watch(serviceEngineerProductsProvider);

    // Create a map of productId -> productName for easy lookup
    final Map<String, String> productIdNameMap = {
      for (var product in productState.data ?? [])
        if (product.productId != null && product.productName != null)
          product.productId!: product.productName!
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6BC37A),
        elevation: 0,
        title: const Text(
          'Service Bookings',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: serviceBooking.data == null || serviceBooking.data!.isEmpty
          ? const Center(child: Text('No bookings available.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: serviceBooking.data!.length,
              itemBuilder: (context, index) {
                final booking = serviceBooking.data![index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  color: const Color.fromARGB(255, 204, 213, 230),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Service Details
                        const Text(
                          'Service Details',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        ...booking.serviceIds?.map((service) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Name: ${service.name ?? 'N/A'}'),

                                    // Show product names instead of product IDs
                                   if (booking.productId != null && booking.productId!.isNotEmpty)
  Text('Product: ${productIdNameMap[booking.productId!] ?? 'Unknown Product'}'),


                                    Text('Details: ${service.details ?? 'N/A'}'),
                                    Text('Status: ${booking.status ?? 'N/A'}'),
                                    const Divider(height: 24),
                                  ],
                                ),
                              );
                            }).toList() ??
                            [const Text('No services listed.')],

                        const SizedBox(height: 12),

                        /// User Details
                        const Text(
                          'User Details',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text('Username: ${booking.userId?.name ?? 'N/A'}'),
                        Text('Mobile: ${booking.userId?.mobile ?? 'N/A'}'),
                        Text('Email: ${booking.userId?.email ?? 'N/A'}'),
                        Text('Location: ${booking.location ?? 'N/A'}'),
                        Text('Address: ${booking.address ?? 'N/A'}'),

                        const SizedBox(height: 12),

                        /// Action Buttons (Accept, Decline, Share)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // TextButton.icon(
                            //   onPressed: () {
                            //     // Accept action
                            //   },
                            //   icon: const Icon(Icons.check_circle,
                            //       color: Colors.green),
                            //   label: const Text("Accept"),
                            // ),
                            // const SizedBox(width: 8),
                            // TextButton.icon(
                            //   onPressed: () {
                            //     // Decline action
                            //   },
                            //   icon:
                            //       const Icon(Icons.cancel, color: Colors.red),
                            //   label: const Text("Decline"),
                            // ),
                            const SizedBox(width: 8),
                            TextButton.icon(
                              onPressed: () {
                                // Share action
                              },
                              icon:
                                  const Icon(Icons.share, color: Colors.blue),
                              label: const Text("Share"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
