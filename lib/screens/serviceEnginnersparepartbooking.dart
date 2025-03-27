import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_med/providers/spareparetbookingprovider.dart';

// import '../model/sparepartbookingstate.dart';

class Serviceenginnersparepartbooking extends ConsumerStatefulWidget {
  const Serviceenginnersparepartbooking({super.key});

  @override
  ConsumerState<Serviceenginnersparepartbooking> createState() =>
      _ServiceScreenState();
}

class _ServiceScreenState
    extends ConsumerState<Serviceenginnersparepartbooking> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(sparepartBookingProvider.notifier).getSparepartBooking();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sparepartBookingState = ref.watch(sparepartBookingProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6BC37A),
        elevation: 0,
        title: const Text(
          'Spare Part Bookings',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: sparepartBookingState.data == null
          ? const Center(child: CircularProgressIndicator()) // Loading state
          : sparepartBookingState.data!.isEmpty
              ? const Center(
                  child: Text(
                    'No spare part bookings available.',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: sparepartBookingState.data!.length,
                  itemBuilder: (context, index) {
                    final booking = sparepartBookingState.data![index];

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   "Booking ID: ${booking.sId ?? 'N/A'}",
                            //   style: const TextStyle(
                            //       fontSize: 14, fontWeight: FontWeight.bold),
                            // ),
                            // const SizedBox(height: 8),
                            Column(
                              children: booking.sparePartIds?.map((sparePart) {
                                    return Column(
                                      children: [
                                        if (sparePart.sparePartImages
                                                ?.isNotEmpty ??
                                            false)
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              sparePart.sparePartImages!.first,
                                              height: 150,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        const SizedBox(height: 8),
                                        Text(
                                          sparePart.sparepartName ?? 'N/A',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Description: ${sparePart.description ?? 'No description'}",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          "Price: ₹${sparePart.price ?? 'N/A'}",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green),
                                        ),
                                        const Divider(),
                                      ],
                                    );
                                  }).toList() ??
                                  [],
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                // Handle delete logic here
                _showConfirmationDialog(
                context,
                'Delete',
                'Are you sure you want to delete this sparepartbooking?',
                () => ref
                    .read(sparepartBookingProvider.notifier)
                    .deleteSparepartBooking(booking.sId),
              );
                                // TODO: Implement cancel booking functionality
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Cancel booking clicked!"),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                              ),
                              child: const Text(
                                "Cancel Booking",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
}
