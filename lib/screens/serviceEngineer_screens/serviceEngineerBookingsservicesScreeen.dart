import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_med/model/DIstributor_models/Distributor_products_model.dart';
import 'package:go_med/providers/auth_provider.dart';
import '../../providers/Serviceenginner_ptovider/serviceEnginnerProductsprovider.dart';
import '../../providers/Serviceenginner_ptovider/serviceengineer_booking_services_provide.dart';
import '../BottomNavBar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
// import '../../providers/';

class Serviceengineerbookingsservicescreeen extends ConsumerStatefulWidget {
  const Serviceengineerbookingsservicescreeen({super.key});

  @override
  ConsumerState<Serviceengineerbookingsservicescreeen> createState() =>
      _ServiceScreenState();
}

class _ServiceScreenState
    extends ConsumerState<Serviceengineerbookingsservicescreeen> {
  final Map<int, TextEditingController> _startOtpControllers = {};
  final Map<int, TextEditingController> _endOtpControllers = {};
  final Map<int, bool> _startOtpFilled = {};
  final Map<int, bool> _startOtpSubmitted = {};
  final Map<int, bool> _endOtpFilled = {};
  final Map<int, bool> _endOtpSubmitted = {};

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
  void dispose() {
    _startOtpControllers.values.forEach((c) => c.dispose());
    _endOtpControllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   final serviceBooking = ref.watch(serviceEngineerBookingServicesProvider).data??[];
final productState = ref.watch(serviceEngineerProductsProvider);
final loginData = ref.watch(loginProvider).data ?? [];
final String? loggedInEngineerId =
    loginData.isNotEmpty ? loginData[0].details?.sId : null;

final  allBookings = serviceBooking;

final hasEngineerBookings = allBookings
    .where((booking) => booking.serviceEngineerId== loggedInEngineerId)
    .isNotEmpty;

final filteredEngineerBookings = hasEngineerBookings
    ? allBookings
        .where((booking) => booking.serviceEngineerId == loggedInEngineerId)
        .toList()
    : [];

final Map<String, String> productIdNameMap = {
  for (var product in productState.data ?? [])
    if (product.productId != null && product.productName != null)
      product.productId!: product.productName!
};
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6BC37A),
        elevation: 0,
        title:  Text(
          'Service Bookings',
          style: TextField.materialMisspelledTextStyle
          // TextStyle(color: Colors.black),
        ),
      ),
      body:
      //  filteredEngineerBookings
      //     ? const Center(child: CircularProgressIndicator())
      //     : filteredEngineerBookings.isEmpty
      //         ? const Center(child: Text('No bookings available.'))
      //         : 
              ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredEngineerBookings.length,
                  itemBuilder: (context, index) {
                    final booking = filteredEngineerBookings[index];
                    _startOtpControllers[index] ??= TextEditingController();
                    _endOtpControllers[index] ??= TextEditingController();
                    _startOtpFilled[index] ??= false;
                    _startOtpSubmitted[index] ??= false;
                    _endOtpFilled[index] ??= false;
                    _endOtpSubmitted[index] ??= false;

                    String? mapsLink;
                    if (booking.location != null &&
                        booking.location!.contains(',')) {
                      final locationParts = booking.location!.split(',');
                      try {
                        final latitude = double.parse(locationParts[0].trim());
                        final longitude = double.parse(locationParts[1].trim());
                        mapsLink =
                            "https://www.google.com/maps?q=$latitude,$longitude";
                      } catch (_) {}
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Service Details',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            // const SizedBox(height: 8),
                            ...booking.serviceIds?.map((service) {
                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 4),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 2,
                                    color: const Color.fromARGB(
                                        255, 194, 225, 241),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Name: ${service.name ?? 'N/A'}'),
                                          if (booking.productId != null &&
                                              booking.productId!.isNotEmpty)
                                            Text(
                                                'Product: ${productIdNameMap[booking.productId!] ?? 'Unknown'}'),
                                          Text(
                                              'Details: ${service.details ?? 'no details'}'),
                                          Text(
                                              'Date: ${booking.date ?? 'no date'}'),
                                          Text(
                                              'Time: ${booking.time ?? 'no time'}'),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text: 'Status: ',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: booking.status,
                                                  style: TextStyle(
                                                    color: _getStatusColor(
                                                        booking.status),
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )

                                          // const Divider(height: 24),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList() ??
                                [const Text('No services listed.')],
                            const SizedBox(height: 12),

                            // if (booking.status?.toLowerCase() == 'confirmed') ...[
                            if (booking.status?.toLowerCase() ==
                                'confirmed') ...[
                              const Text('Start OTP Verification',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _startOtpControllers[index],
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                decoration: const InputDecoration(
                                    labelText: 'Enter Start OTP',
                                    counterText: ""),
                                onChanged: (value) {
                                  setState(() {
                                    _startOtpFilled[index] = value.length == 6;
                                  });
                                },
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: _startOtpFilled[index]!
                                    ? () async {
                                        final bookingId = booking
                                            .sId; // Use your actual field name here
                                        final otp = _startOtpControllers[index]!
                                            .text
                                            .trim();

                                        if (bookingId == null || otp.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Booking ID or OTP missing')),
                                          );
                                          return;
                                        }

                                        final success = await ref
                                            .read(
                                                serviceEngineerBookingServicesProvider
                                                    .notifier)
                                            .updateServiceBookings(
                                              bookingId,
                                              startOtp: otp,
                                              endOtp:
                                                  null, // Sending only start OTP
                                            );

                                        if (success) {
                                          setState(() {
                                            _startOtpSubmitted[index] = true;
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Start OTP submitted')),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Failed to submit Start OTP')),
                                          );
                                        }
                                      }
                                    : null,
                                child: const Text("Start OTP"),
                              ),
                            ] else if (booking.status?.toLowerCase() ==
                                'servicestarted') ...[
                              const SizedBox(height: 16),
                              const Text('End OTP Verification',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _endOtpControllers[index],
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                decoration: const InputDecoration(
                                    labelText: 'Enter End OTP',
                                    counterText: ""),
                                onChanged: (value) {
                                  setState(() {
                                    _endOtpFilled[index] = value.length == 6;
                                  });
                                },
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: _endOtpFilled[index]!
                                    ? () async {
                                        final bookingId = booking
                                            .sId; // Use your actual field name here
                                        final otp = _endOtpControllers[index]!
                                            .text
                                            .trim();

                                        if (bookingId == null || otp.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Booking ID or OTP missing')),
                                          );
                                          return;
                                        }

                                        final success = await ref
                                            .read(
                                                serviceEngineerBookingServicesProvider
                                                    .notifier)
                                            .updateServiceBookings(
                                              bookingId,
                                              startOtp:
                                                  null, // Sending only end OTP
                                              endOtp: otp,
                                            );

                                        if (success) {
                                          setState(() {
                                            _endOtpSubmitted[index] = true;
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content:
                                                    Text('End OTP submitted')),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Failed to submit End OTP')),
                                          );
                                        }
                                      }
                                    : null,
                                child: const Text("End OTP"),
                              ),
                            ] else
                              const Padding(
                                padding: EdgeInsets.only(top: 12),
                                child: Text('',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                              ),
                            // const SizedBox(height: 12),
                            const Text('User Details',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            // const SizedBox(height: 8),
                            Text('${booking.userId?.name ?? 'N/A'}'),
                            Text('${booking.userId?.mobile ?? 'N/A'}'),
                            Text('${booking.userId?.email ?? 'N/A'}'),
                            mapsLink != null
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Location:",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // const SizedBox(height: 4),
                                      GestureDetector(
                                        onTap: () async {
                                          final uri = Uri.parse(mapsLink!);
                                          if (await canLaunchUrl(uri)) {
                                            await launchUrl(uri,
                                                mode: LaunchMode
                                                    .externalApplication);
                                          } else {
                                            throw 'Could not launch $mapsLink';
                                          }
                                        },
                                        child: Text(
                                          mapsLink!,
                                          style: const TextStyle(
                                            color: Colors.blue,
                                            fontSize: 12,
                                            // decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const Text("Location: N/A"),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Address:',
                                  style: TextStyle(
                                    fontSize: 12,
                                    // fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                // const SizedBox(height: 4),
                                Text(
                                  booking.address ?? 'N/A',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    // Share action
                                  },
                                  icon: const Icon(Icons.share,
                                      color: Colors.blue),
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
//   String _getStatusLabel(String? status) {
//   switch (status?.toLowerCase()) {
//     case 'pending':
//       return 'Pending';
//     case 'confirmed':
//       return 'Confirmed';
//     case 'start service':
//       return 'Start Service';
//     case 'service completed':
//       return 'Service Completed';
//     default:
//       return status ?? 'No Status';
//   }
// }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.red;
      case 'confirmed':
        return Colors.blue;
      case 'startservice':
        return Colors.orange;
      case 'servicecompleted':
        return Colors.green;
      default:
        return Colors.black;
    }
  }
}
