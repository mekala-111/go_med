import 'package:flutter/material.dart';
import '../model/serviceengineersparepartbookingmodel.dart';

class ServiceEngineerSparePartTrackingScreen extends StatelessWidget {
  final Data booking;

  const ServiceEngineerSparePartTrackingScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final trackingSteps = ['Booked', 'Out for Delivery', 'Completed'];

    int mapStatusToStep(String? status) {
      switch (status?.toLowerCase()) {
        case 'pending':
          return 0;
        case 'confirmed':
          return 1;
        case 'completed':
          return 2;
        default:
          return 0;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Order Tracking')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text("Order ID: ${booking.sId}",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("Order Date: ${booking.createdAt}"),
            const SizedBox(height: 20),

            // For each spare part
            ...booking.sparePartIds?.map((part) {
              int currentStep = mapStatusToStep(part.bookingStatus);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Product: ${part.sparePartName ?? 'N/A'}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("Price: ₹${part.price?.toStringAsFixed(2) ?? 'N/A'}"),
                    Text("Quantity: ${part.quantity}"),
                    const SizedBox(height: 16),

                    // Horizontal Step Tracker
                    Row(
                      children: List.generate(trackingSteps.length * 2 - 1, (index) {
                        if (index.isOdd) {
                          final isActive = index ~/ 2 < currentStep;
                          return Expanded(
                            child: Container(
                              height: 2,
                              color: isActive ? Colors.blue : Colors.grey[300],
                            ),
                          );
                        } else {
                          final stepIndex = index ~/ 2;
                          final isActive = stepIndex <= currentStep;

                          return Column(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: isActive ? Colors.blue : Colors.grey[300],
                                child: Text(
                                  '${stepIndex + 1}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                trackingSteps[stepIndex],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isActive ? Colors.blue : Colors.grey,
                                ),
                              ),
                            ],
                          );
                        }
                      }),
                    ),
                  ],
                ),
              );
            }).toList() ?? [],

            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue[100],
                  foregroundColor: Colors.black,
                ),
                child: const Text("Leave a Review"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
