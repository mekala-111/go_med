import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:geolocator/geolocator.dart'; // Import geolocator for location
import '../providers/bookings_provider.dart';
import '../screens/BottomNavBar.dart';

class BookingsScreen extends ConsumerStatefulWidget {
  const BookingsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BookingsScreenState createState() => _BookingsScreenState();
}

class _BookingsScreenState extends ConsumerState<BookingsScreen> {
  final TextEditingController statusController = TextEditingController();
  String? bookingId;
  int selectedIndex = 0;
  final List<String> filterOptions = ["All", "Upcoming", "Past"];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(bookingProvider.notifier).getBookings();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      setState(() {
        bookingId = args['_id'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingProvider);
    final distributorBookings = bookingState.data;
     final isLoading = bookingState.statusCode == 0;

    var filteredBookings = distributorBookings;
    if (selectedIndex == 1) {
      filteredBookings = distributorBookings
          .where((booking) => booking.status == "Upcoming")
          .toList();
    } else if (selectedIndex == 2) {
      filteredBookings = distributorBookings
          .where((booking) => booking.status == "Past")
          .toList();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE8F7F2),
      appBar: AppBar(
        title: const Text("Bookings", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF6BC37A),
      ),
      body: Column(
        children: [
          ToggleButtons(
            isSelected: List.generate(
                filterOptions.length, (index) => index == selectedIndex),
            selectedColor: Colors.white,
            fillColor: Colors.green,
            borderRadius: BorderRadius.circular(20),
            children: filterOptions
                .map((option) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(option),
                    ))
                .toList(),
            onPressed: (index) {
              setState(() => selectedIndex = index);
            },
          ),
          const SizedBox(height: 20),
          Text("Total Bookings: ${filteredBookings.length}",
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(
            child: isLoading
             ? const Center(child: CircularProgressIndicator())
            :filteredBookings.isEmpty
                ? const Center(child: Text("No bookings available"))
                : ListView.builder(
                    itemCount: filteredBookings.length,
                    itemBuilder: (context, index) {
                      final booking = filteredBookings[index];
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
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("User: ${booking.userId.name}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text("Email: ${booking.userId.email}"),
                              
                            
                              // Inside your widget:
                              mapsLink != null
                                  ? RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: "Location: ",
                                            style: TextStyle(color: Colors.black,fontSize:20),
                                          ),
                                          TextSpan(
                                            text: mapsLink,
                                            style: const TextStyle(
                                              color: Colors.blue,
                                              // decoration: TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                final uri = Uri.parse(mapsLink!);
                                                if (await canLaunchUrl(uri)) {
                                                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                                                } else {
                                                  throw 'Could not launch $mapsLink';
                                                }
                                              },
                                          ),
                                        ],
                                      ),
                                    )
                                  : const Text("Location: N/A"),


                              Text("Address: ${booking.address}"),
                              const SizedBox(height: 5),
                              const Text('Products:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Divider(color: Colors.grey.shade300),
                              ...booking.productIds.map((product) => SizedBox(
                                    width: double.infinity,
                                    height: 230,
                                    child: Card(
                                      elevation: 4,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 16),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                "Product Name: ${product.productName}",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                "Description: ${product.productDescription}"),
                                            Text(
                                                "Quantity: ${product.quantity}"),
                                            Text.rich(
                                              TextSpan(
                                                text: "Price: ₹",
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black),
                                                children: [
                                                  TextSpan(
                                                    text: "${product.price}",
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xFF6BC37A),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                                "Status: ${product.bookingStatus}"),
                                            const SizedBox(height: 10),
                                            // Only one button shown at a time
                                          if (product.bookingStatus == "pending") ...[
                                            ElevatedButton(
                                              onPressed: () async {
                                                bool confirm = await _showConfirmationDialog(context);
                                                if (confirm) {
                                                  try {
                                                    await ref.read(bookingProvider.notifier).updateBookings(
                                                      booking.id,
                                                      product.quantity,
                                                      "confirmed"
                                                    );
                                                    _showSnackBar(context, "Booking accepted successfully");
                                                  } catch (e) {
                                                    _showSnackBar(context, e.toString());
                                                  }
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color.fromARGB(255, 161, 166, 161),
                                                foregroundColor: Colors.white,
                                              ),
                                              child: const Text("Booking Accept"),
                                            ),
                                          ] else if (product.bookingStatus == "Confirmed") ...[
                                            ElevatedButton(
                                              onPressed: () async {
                                                bool confirm = await _showConfirmationDialog(context);
                                                if (confirm) {
                                                  try {
                                                    await ref.read(bookingProvider.notifier).updateBookings(
                                                      booking.id,
                                                      product.quantity,
                                                      "completed"
                                                    );
                                                    _showSnackBar(context, "Product marked as delivered");
                                                  } catch (e) {
                                                    _showSnackBar(context, e.toString());
                                                  }
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                foregroundColor: Colors.white,
                                              ),
                                              child: const Text("Delivery complete"),
                                            ),
                                          ] else if (product.bookingStatus == "Completed") ...[
                                            const Text(
                                              "✅ Product Delivered Successfully",
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ]

                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      // Fetch current location
                                      // Position position =
                                      //     await _getCurrentLocation();

                                      // final latitude = position.latitude;
                                      // final longitude = position.longitude;

                                      // final mapsLink =
                                      //     "https://www.google.com/maps?q=${booking.location}";

                                      // Construct the message to be sent to WhatsApp
                                      final message =
                                          "📍 User Location:\n$mapsLink\n\n👤 Name: ${booking.userId.name}\n📞 Phone: ${booking.userId.mobile}\n🏠 Address: ${booking.address ?? 'N/A'}\n📌 Location: ${mapsLink ?? 'N/A'}\n\n📦 Products:\n${booking.productIds.map((product) {
                                        return "- ${product.productName} (Qty: ${product.quantity}, ₹${product.price},)";
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
                                    icon: const Icon(Icons.navigation),
                                    label: const Text("Navigate & Share"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
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
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  // Future<Position> _getCurrentLocation() async {
  //   // Check if location services are enabled
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     throw Exception('Location services are disabled.');
  //   }

  //   // Request location permission
  //   LocationPermission permission = await Geolocator.requestPermission();
  //   if (permission == LocationPermission.denied) {
  //     throw Exception('Location permission denied.');
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     throw Exception('Location permission denied forever.');
  //   }

  //   // Get current location
  //   return await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  // }

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

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm Booking"),
              content: const Text("Do you want to accept this booking?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("OK"),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
