import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_med/providers/auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/Distributor_provider/bookings_provider.dart';
import '../BottomNavBar.dart';

class BookingsScreen extends ConsumerStatefulWidget {
  const BookingsScreen({super.key});

  @override
  _BookingsScreenState createState() => _BookingsScreenState();
}

class _BookingsScreenState extends ConsumerState<BookingsScreen> {
  String? bookingId;
  int selectedIndex = 0;
  final List<String> filterOptions = ["All", "Upcoming", "Past"];
  final TextEditingController otpController = TextEditingController();

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
    final loginData = ref.watch(loginProvider);
    final distributorId = loginData.data?.first.details?.sId;

    return Scaffold(
      backgroundColor: const Color(0xFFE8F7F2),
      appBar: AppBar(
        title: const Text("Bookings", style: TextStyle(color: Colors.white,)),
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
                : filteredBookings.isEmpty
                    ? const Center(child: Text("No bookings available"))
                    : ListView.builder(
                        itemCount: filteredBookings.length,
                        itemBuilder: (context, index) {
                          final booking = filteredBookings[index];
                          String? mapsLink;

                          if (booking.location != null &&
                              booking.location!.contains(',')) {
                            final parts = booking.location!.split(',');
                            try {
                              final lat = double.parse(parts[0].trim());
                              final lng = double.parse(parts[1].trim());
                              mapsLink =
                                  "https://www.google.com/maps?q=$lat,$lng";
                            } catch (_) {}
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
                                  mapsLink != null
                                      ? RichText(
                                          text: TextSpan(
                                            children: [
                                              const TextSpan(
                                                  text: "Location: ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20)),
                                              TextSpan(
                                                text: mapsLink,
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 20,
                                                ),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () async {
                                                        final uri =
                                                            Uri.parse(mapsLink!);
                                                        if (await canLaunchUrl(
                                                            uri)) {
                                                          await launchUrl(uri,
                                                              mode: LaunchMode
                                                                  .externalApplication);
                                                        }
                                                      },
                                              ),
                                            ],
                                          ),
                                        )
                                      : const Text("Location: N/A"),
                                  Text("Address: ${booking.address}"),
                                  const SizedBox(height: 10),
                                  const Text('Products:',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  Divider(color: Colors.grey.shade300),
                                  ...booking.productIds.map((product) {
                                    return SizedBox(
                                      width: double.infinity,
                                      // height: 240,
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
                                              Text("${product.productName}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  "Description: ${product.productDescription}",
                                                   maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,),
                                              Text("Qty: ${product.quantity}"),
                                              Text.rich(
                                                TextSpan(
                                                  text: "Price:₹",
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
                                                        color:
                                                            Color(0xFF6BC37A),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text("AvailableStock:${product.availableStock??0}"),
                                              Text(
                                                  "Status: ${product.bookingStatus}"),
                                              const SizedBox(height: 10),
                                             if (product.bookingStatus == "pending")
                                            ElevatedButton(
                                              onPressed: () async {
                                                bool confirm = await _showConfirmationDialog(context);
                                                if (confirm) {
                                                  try {
                                                    await ref.read(bookingProvider.notifier).updateBookings(
                                                          booking.id,
                                                          quantity: null,
                                                          successQuantity:null,
                                                          price:null,
                                                          "confirmed",
                                                          product.id,
                                                          distributorId,
                                                          otp:null,
                                                          type:"cod"
                                                        );
                                                  } catch (e) {
                                                    _showSnackBar(context, e.toString());
                                                  }
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.grey,
                                                foregroundColor: Colors.white,
                                              ),
                                              child: const Text("Booking Accept"),
                                            )

                                          else if (product.bookingStatus == "confirmed")...[
                                             
                                            ElevatedButton(
                                              onPressed: () async {
                                                bool confirm = await _showConfirmationDialog(context);
                                                if (confirm) {
                                                  try {
                                                    await ref.read(bookingProvider.notifier).updateBookings(
                                                          booking.id,
                                                          quantity: product.quantity,
                                                          successQuantity:null,
                                                                price:null,
                                                          "startDelivery",
                                                          product.id,
                                                          distributorId,
                                                           otp:null,
                                                           type:"cod"
                                                        );
                                                  } catch (e) {
                                                    _showSnackBar(context, e.toString());
                                                  }
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.grey,
                                                foregroundColor: Colors.white,
                                              ),
                                              child: const Text("Start Delivery"),
                                            )
                                            ]

                                          else if (product.bookingStatus == "startDelivery") ...[
                                           TextFormField(
                                              controller: otpController,
                                              keyboardType: TextInputType.number,
                                              maxLength: 4,
                                              decoration: const InputDecoration(
                                                labelText: "Enter 4-digit OTP",
                                                border: OutlineInputBorder(),
                                                counterText: "",
                                              ),
                                              onChanged: (value) {
                                                setState(() {});
                                              },
                                            ),
                                            
                                            ElevatedButton(
                                              onPressed: otpController.text.length == 4
                                                  ? () async {
                                                      bool confirm = await _showConfirmationDialog(context);
                                                      if (confirm) {
                                                        try {
                                                          await ref.read(bookingProvider.notifier).updateBookings(
                                                                booking.id,
                                                                quantity: null,
                                                                successQuantity:product.quantity,
                                                                price:product.price,
                                                                "completed",
                                                                product.id,
                                                                distributorId,
                                                                otp:otpController.text.trim(),
                                                                type:"COD"
                                                              );
                                                          _showSnackBar(
                                                              context, "Product marked as delivered");
                                                        } catch (e) {
                                                          _showSnackBar(context, e.toString());
                                                        }
                                                      }
                                                    }
                                                  : null,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                foregroundColor: Colors.white,
                                              ),
                                              child: const Text("Delivery Completed"),
                                            ),
                                          ]

                                          else if (product.bookingStatus == "completed")
                                            const Text(
                                              "Product Delivered Successfully",
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                  const SizedBox(height: 10),
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      final message =
                                          "📍 User Location:\n$mapsLink\n\n👤 Name: ${booking.userId.name}\n📞 Phone: ${booking.userId.mobile}\n🏠 Address: ${booking.address ?? 'N/A'}\n📌 Location: ${mapsLink ?? 'N/A'}\n\n📦 Products:\n${booking.productIds.map((product) {
                                        return "- ${product.productName} (Qty: ${product.quantity}, ₹${product.price})";
                                      }).join("\n")}";

                                      final whatsappUrl = Uri.parse(
                                          "https://wa.me/?text=${Uri.encodeComponent(message)}");

                                      if (await canLaunchUrl(whatsappUrl)) {
                                        await launchUrl(whatsappUrl,
                                            mode:
                                                LaunchMode.externalApplication);
                                      } else {
                                        _showSnackBar(context,
                                            "WhatsApp not available");
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

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Confirmation'),
              content: const Text('Are you sure you want to proceed?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
