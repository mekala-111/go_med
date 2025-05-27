import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/Serviceengineer_model/serviceengineersparepartbookingmodel.dart';
import '../../providers/Serviceenginner_ptovider/Serviceengineersparepartbookingprovider.dart';

class ServiceEngineerSparePartTrackingScreen extends ConsumerWidget {
  final Data booking;

  const ServiceEngineerSparePartTrackingScreen(
      {super.key, required this.booking});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackingSteps = [
      'Booked',
      'Confirmed',
      'OutforDelivery',
      'Completed'
    ];

    int mapStatusToStep(String? status) {
      final normalized = status?.toLowerCase().trim();
      switch (normalized) {
        case 'pending':
          return 0;
        case 'confirmed':
          return 1;
        case 'startdelivery':
          return 2;
        case 'completed':
          return 3;
        default:
          return 0;
      }
    }

    // double totalPrice = booking.totalPrice;
    // double paidPrice = (booking.paidPrice)
    //     ? booking.paidPrice
    //     : booking.paidPrice
    //         ? booking.paidPrice
    //         : 0.0;
    final double remainingPrice = (booking.totalPrice??0) - (booking.paidPrice??0);

    return Scaffold(
      appBar: AppBar(title: const Text('Order Tracking')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text("Order ID: ${booking.sId}",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("OTP: ${booking.otp}"),
            const SizedBox(height: 20),
            ...booking.sparePartIds?.map((part) {
                  final currentStep = mapStatusToStep(part.bookingStatus);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Product: ${part.sparePartName ?? 'N/A'}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Text(
                                "Price: ₹${part.price?.toStringAsFixed(2) ?? 'N/A'}"),
                            Text("Quantity: ${part.quantity}"),
                            const SizedBox(height: 16),
                            Row(
                              children: List.generate(
                                  trackingSteps.length * 2 - 1, (index) {
                                if (index.isOdd) {
                                  final isLineActive = index ~/ 2 < currentStep;
                                  return Expanded(
                                    child: Container(
                                      height: 2,
                                      color: isLineActive
                                          ? Colors.blue
                                          : Colors.grey[300],
                                    ),
                                  );
                                } else {
                                  final stepIndex = index ~/ 2;
                                  final isActive = stepIndex <= currentStep;
                                  return Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor: isActive
                                            ? Colors.blue
                                            : Colors.grey[300],
                                        child: Text(
                                          '${stepIndex + 1}',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        trackingSteps[stepIndex],
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w500,
                                          color: isActive
                                              ? Colors.blue
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              }),
                            ),
                            const SizedBox(height: 16),
                            if ((part.bookingStatus?.toLowerCase().trim() ??
                                        '') ==
                                    'pending' ||
                                (part.bookingStatus?.toLowerCase().trim() ??
                                        '') ==
                                    'confirmed')
                              ElevatedButton(
                                onPressed: () {
                                  _showConfirmationDialog(
                                    context,
                                    'Cancel Booking',
                                    'Are you sure you want to cancel this spare part booking?',
                                    () => ref
                                        .read(
                                            serciceEngineerSparepartBookingProvider
                                                .notifier)
                                        .deleteSparepartBooking(part.sId ?? ''),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 242, 152, 146),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                ),
                                child: const Text(
                                  "Cancel Booking",
                                  style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                                ),
                              )
                            else
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  "You cannot cancel, it's already processed.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList() ??
                [],
          ],
        ),
      ),

      /// Bottom bar with totals and review button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Price Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("TotalPrice: ₹${booking.totalPrice!.toStringAsFixed(2)}"),
                if ((booking.type?.toLowerCase() ?? '') == 'cod') ...[
                  Text("PaidPrice: ₹${booking.paidPrice!.toStringAsFixed(2)}"),

                  Text(
                    "Remaining: ₹${remainingPrice.toStringAsFixed(2)}",
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ],
              ],
            ),

            // Leave a Review Button
            ElevatedButton(
              onPressed: () {
                // TODO: Add review logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text("Leave a Review"),
            ),
          ],
        ),
      ),
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
              onPressed: () => Navigator.of(context).pop(),
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
}
