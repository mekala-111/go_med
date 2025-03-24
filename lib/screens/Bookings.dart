import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/bookings_provider.dart';
import '../screens/BottomNavBar.dart';

class BookingsScreen extends ConsumerStatefulWidget {
  const BookingsScreen({super.key});

  @override
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
        // statusController.text = args['status'] ?? '';
        bookingId = args['_id'] ?? '';
        print('booking id.........$bookingId');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingProvider);

    final distributorBookings = bookingState.data ?? [];

    print('Total Filtered Bookings: ${distributorBookings.length}');

    // Filter bookings based on status selection
    var filteredBookings = distributorBookings;
    // final createAt= filteredBookings.;
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
          // Toggle buttons for filtering bookings
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
          Text("Total Bookings: ${distributorBookings.length}",
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

          // Bookings List
          Expanded(
            child: filteredBookings.isEmpty
                ? const Center(child: Text("No bookings available"))
                : ListView.builder(
                    itemCount: filteredBookings.length,
                    itemBuilder: (context, index) {
                      final booking = filteredBookings[index];

                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // User Information
                              Text("User: ${booking.userId.name}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text("Email: ${booking.userId.email}"),
                              Text("Location: ${booking.location?.toString()}"),
                              Text("Address: ${booking.address}"),
                              const SizedBox(height: 5),
                              const Text('Products:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const Divider(),

                              // Displaying all products inside this booking
                              ...booking.productIds.map((product) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Product Name: ${product.productName}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          "Description: ${product.productDescription}"),
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
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF6BC37A),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  )),

                              // Buttons for actions
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      // Implement share functionality
                                    },
                                    icon: const Icon(Icons.share),
                                    label: const Text("Share"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      bool confirm =
                                          await _showConfirmationDialog(
                                              context);
                                      if (confirm) {
                                        // Proceed with booking acceptance
                                        try {
                                          await ref
                                              .read(bookingProvider.notifier)
                                              .updateBookings(booking.id);
                                          // statusController.clear();
                                          _showSnackBar(context,
                                              "Booking updated successfully");
                                        } catch (e) {
                                          _showSnackBar(context, e.toString());
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text("Booking Accept"),
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

  /// Function to Show Confirmation Dialog
  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm Booking"),
              content: const Text("Do you want to accept this booking?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // User canceled
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // User confirmed
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        ) ??
        false; // Default to false if dialog is dismissed
  }
}
