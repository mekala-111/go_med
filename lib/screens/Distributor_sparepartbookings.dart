import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_med/model/Quantity_parts_model.dart';
import 'package:go_med/providers/spareparetbookingprovider.dart';
import 'package:go_med/screens/BottomNavBar.dart';
import 'package:url_launcher/url_launcher.dart';
class DistributorSparepartbookings extends ConsumerStatefulWidget {
  const DistributorSparepartbookings({super.key});

  @override
  ConsumerState<DistributorSparepartbookings> createState() =>
      _ServiceScreenState();
}

class _ServiceScreenState
    extends ConsumerState<DistributorSparepartbookings> {
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
      final isLoading = sparepartBookingState.statusCode == 0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6BC37A),
        elevation: 0,
        title: const Text(
          'Spare Part Bookings',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body:isLoading 
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
                     String? mapsLink;
                     if (booking.location != null &&
                          booking.location!.contains(',')) {
                        final locationParts = booking.location!.split(',');
                        try {
                          
                          final latitude =
                              double.parse(locationParts[0].trim());
                          final longitude =
                              double.parse(locationParts[1].trim());
                          mapsLink =
                              "https://www.google.com/maps?q=$latitude,$longitude";
                        } catch (e) {
                          mapsLink = null;
                        }
                      } else {
                        mapsLink = null;
                      }


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
                            Column(
                              children: booking.sparePartIds?.map((sparePart) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                            // Service Engineer Details
                            if (booking.serviceEngineer != null) ...[
                              const Text(
                                "Service Engineer Details:",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Name: ${booking.serviceEngineer!.name ?? 'N/A'}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                "Email: ${booking.serviceEngineer!.email ?? 'N/A'}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 10),
                            ],
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: ()async {
                                    // TODO: Implement share functionality
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //   const SnackBar(
                                    //     content: Text("Share clicked!"),
                                    //   ),
                                    // );
                                    final message =
                                          "📍 User Location:\n$mapsLink\n\n👤 Name: ${booking.serviceEngineer!.name}\n📞 Phone: ${booking.serviceEngineer!.mobile}\n🏠 Address: ${booking.serviceEngineer!.email?? 'N/A'}\n📌 Location: ${mapsLink ?? 'N/A'}\n\n📦 Products:\n${booking.sparePartIds!.map((sparepart) {
                                        return "- ${sparepart.sparepartName} (price: ${sparepart.price}, ₹${sparepart.description},)";
                                      }).join("\n")}";

                                      final whatsappUrl = Uri.parse(
                                          "https://wa.me/?text=${Uri.encodeComponent(message)}");

                                      // Open WhatsApp with the message
                                      if (await canLaunchUrl(whatsappUrl)) {
                                        await launchUrl(whatsappUrl,
                                            mode:
                                                LaunchMode.externalApplication);
                                      } else {
                                        _showSnackBar(
                                            context, "WhatsApp not available");
                                      }
                                     },
                                    style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                  ),
                                  child: const Text(
                                    "Share",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // TODO: Implement accept booking functionality
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Accept booking clicked!"),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                  ),
                                  child: const Text(
                                    "Accept Booking",
                                    style: TextStyle(color: Colors.white),
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
                bottomNavigationBar:  BottomNavBar(),
    );
  }
   void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            message == "Please fill all fields." ? Colors.red : Colors.blue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}