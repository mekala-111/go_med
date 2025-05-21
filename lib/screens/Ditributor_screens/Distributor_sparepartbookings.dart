import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_med/providers/Distributor_provider/spareparetbookingprovider.dart';
import 'package:go_med/providers/auth_provider.dart';
import 'package:go_med/screens/BottomNavBar.dart';
import 'package:url_launcher/url_launcher.dart';

class DistributorSparepartbookings extends ConsumerStatefulWidget {
  const DistributorSparepartbookings({super.key});

  @override
  ConsumerState<DistributorSparepartbookings> createState() =>
      _ServiceScreenState();
}

class _ServiceScreenState extends ConsumerState<DistributorSparepartbookings> {
 late TextEditingController otpController;

@override
void initState() {
  super.initState();
  otpController = TextEditingController();
  Future.microtask(() {
    ref.read(sparepartBookingProvider.notifier).getSparepartBooking();
  });
}

@override
void dispose() {
  otpController.dispose();
  super.dispose();
}


  @override
  Widget build(BuildContext context) {
    final sparepartBookingState = ref.watch(sparepartBookingProvider);
    final isLoading = sparepartBookingState.statusCode == 0;

    final loginData = ref.watch(loginProvider);
    final distributorId = loginData.data?.first.details?.sId;
    print('distributorId....................$distributorId');
    // final TextEditingController otpController = TextEditingController();
    final booking = sparepartBookingState.data;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6BC37A),
        elevation: 0,
        title: const Text(
          'Spare Part Bookings',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
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


                    // Generate Google Maps link
                    String? mapsLink;
                    if (booking.location != null &&
                        booking.location!.contains(',')) {
                      final locationParts = booking.location!.split(',');
                      try {
                        final latitude = double.parse(locationParts[0].trim());
                        final longitude = double.parse(locationParts[1].trim());
                        mapsLink =
                            "https://www.google.com/maps?q=$latitude,$longitude";
                      } catch (e) {
                        mapsLink = null;
                      }
                    }

                    final spareParts = booking.sparePartIds
                            ?.where((sp) => sp.sId != null)
                            .toList() ??
                        [];

                    return spareParts.isEmpty
                        ? const SizedBox.shrink()
                        : Card(
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
                                    children: spareParts.map((sparePart) {
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
                                                sparePart
                                                    .sparePartImages!.first,
                                                height: 150,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "SparepartName: ${sparePart.sparePartName}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          // const SizedBox(height: 4),
                                          Text(
                                            "Description: ${sparePart.description ?? 'No description'}",
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          Text(
                                            "Price: ₹${sparePart.price ?? 'N/A'}",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green),
                                          ),
                                          Text(
                                            "quantity: ${sparePart.quantity ?? 'N/A'}",
                                          ),
                                          Text(
                                            "Available Stock: ${sparePart.availableStock?? 'N/A'}",
                                          ),
                                          Text(
                                            "status: ${sparePart.bookingStatus ?? 'N/A'}",
                                          ),

                                          const SizedBox(height: 10),
                                          if (sparePart.bookingStatus ==
                                              "pending")
                                            ElevatedButton(
                                              onPressed: () async {
                                                bool confirm =
                                                    await _showConfirmationDialog(
                                                        context);
                                                if (confirm) {
                                                  try {
                                                    await ref
                                                        .read(
                                                            sparepartBookingProvider
                                                                .notifier)
                                                        .updateSparepartBookings(
                                                          booking.sId,
                                                          quantity:null,
                                                          successQuantity:null,
                                                          "confirmed",
                                                          sparePart.sId,
                                                          sparePart.parentId,
                                                          distributorId,
                                                          price:sparePart.price,
                                                          otp: null,
                                                          booking.type,
                                                          booking.paidPrice,
                                                          booking.totalPrice
                                                        );
                                                  } catch (e) {
                                                    _showSnackBar(
                                                        context, e.toString());
                                                  }
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.grey,
                                                foregroundColor: Colors.white,
                                              ),
                                              child:
                                                  const Text("Booking Accept"),
                                            )
                                          else if (sparePart.bookingStatus ==
                                              "confirmed")
                                            ElevatedButton(
                                              onPressed: () async {
                                                bool confirm =
                                                    await _showConfirmationDialog(
                                                        context);
                                                if (confirm) {
                                                  try {
                                                    await ref
                                                        .read(
                                                            sparepartBookingProvider
                                                                .notifier)
                                                        .updateSparepartBookings(
                                                            booking.sId,
                                                            quantity:sparePart.quantity,
                                                             successQuantity:null,
                                                             "startDelivery",
                                                            sparePart.sId,
                                                            sparePart.parentId,
                                                            distributorId,
                                                            otp: null,
                                                            booking.type,
                                                            booking.paidPrice,
                                                          booking.totalPrice,
                                                          price:sparePart.price,);
                                                    _showSnackBar(context,
                                                        "sparepart marked as delivered");
                                                  } catch (e) {
                                                    _showSnackBar(
                                                        context, e.toString());
                                                  }
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                foregroundColor: Colors.white,
                                              ),
                                              child:
                                                  const Text("start Delivery"),
                                            )
                                          else if (sparePart.bookingStatus ==
                                              "startDelivery") ...[
                                            TextFormField(
                                              controller: otpController,
                                              keyboardType:
                                                  TextInputType.number,
                                              maxLength: 4,
                                              decoration: const InputDecoration(
                                                labelText: "Enter 4-digit OTP",
                                                border: OutlineInputBorder(),
                                                counterText: "",
                                              ),
                                             onChanged: (_) => setState(() {}),

                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                bool confirm =
                                                    await _showConfirmationDialog(
                                                        context);
                                                if (confirm) {
                                                  try {
                                                    await ref
                                                        .read(
                                                            sparepartBookingProvider
                                                                .notifier)
                                                        .updateSparepartBookings(
                                                          booking.sId,
                                                          quantity: null,
                                                          "completed",
                                                          sparePart.sId,
                                                          sparePart.parentId,
                                                          distributorId,
                                                          price:sparePart.price,
                                                          otp: otpController
                                                              .text
                                                              .trim(),
                                                              booking.type,
                                                              booking.paidPrice,
                                                          booking.totalPrice,
                                                          successQuantity:sparePart.quantity
                                                        );
                                                    _showSnackBar(context,
                                                        "sparepart marked as delivered");
                                                  } catch (e) {
                                                    _showSnackBar(
                                                        context, e.toString());
                                                  }
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                foregroundColor: Colors.white,
                                              ),
                                              child: const Text(
                                                  "Delivery Completed"),
                                            )
                                          ] else if (sparePart.bookingStatus ==
                                              "completed")
                                            const Text(
                                              " sparepart Delivered Successfully",
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 10),
                                  if (booking.serviceEngineer != null) ...[
                                    const Text(
                                      "Service Engineer Details:",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          final message =
                                              "📍 User Location:\n$mapsLink\n\n👤 Name: ${booking.serviceEngineer!.name}\n📞 Phone: ${booking.serviceEngineer!.mobile}\n🏠 Address: ${booking.serviceEngineer!.email ?? 'N/A'}\n📌 Location: ${mapsLink ?? 'N/A'}\n\n📦 Spare Parts:\n${spareParts.map((sp) {
                                            return "- ${sp.sparePartName} (₹${sp.price}, ${sp.description})";
                                          }).join("\n")}";

                                          final whatsappUrl = Uri.parse(
                                              "https://wa.me/?text=${Uri.encodeComponent(message)}");

                                          if (await canLaunchUrl(whatsappUrl)) {
                                            await launchUrl(whatsappUrl,
                                                mode: LaunchMode
                                                    .externalApplication);
                                          } else {
                                            _showSnackBar(context,
                                                "WhatsApp not available");
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
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                  },
                ),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm'),
            content: const Text('Are you sure you want to continue?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel')),
              ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Confirm')),
            ],
          ),
        ) ??
        false;
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
