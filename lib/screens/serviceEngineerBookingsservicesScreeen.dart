import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/serviceEnginnerProductsprovider.dart';
import '../providers/serviceengineer_booking_services_provide.dart';
import '../screens/BottomNavBar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

class Serviceengineerbookingsservicescreeen extends ConsumerStatefulWidget {
  const Serviceengineerbookingsservicescreeen({super.key});

  @override
  ConsumerState<Serviceengineerbookingsservicescreeen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends ConsumerState<Serviceengineerbookingsservicescreeen> {
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
      ref.read(serviceEngineerBookingServicesProvider.notifier).getServiceEnginnerBookingServices();
      ref.read(serviceEngineerProductsProvider.notifier).getServiceEnginnerProducts();
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
    final serviceBooking = ref.watch(serviceEngineerBookingServicesProvider);
    final productState = ref.watch(serviceEngineerProductsProvider);

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
      body: serviceBooking.statusCode == 0
          ? const Center(child: CircularProgressIndicator())
          : serviceBooking.data!.isEmpty
              ? const Center(child: Text('No bookings available.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: serviceBooking.data!.length,
                  itemBuilder: (context, index) {
                    final booking = serviceBooking.data![index];
                    _startOtpControllers[index] ??= TextEditingController();
                    _endOtpControllers[index] ??= TextEditingController();
                    _startOtpFilled[index] ??= false;
                    _startOtpSubmitted[index] ??= false;
                    _endOtpFilled[index] ??= false;
                    _endOtpSubmitted[index] ??= false;

                    String? mapsLink;
                    if (booking.location != null && booking.location!.contains(',')) {
                      final locationParts = booking.location!.split(',');
                      try {
                        final latitude = double.parse(locationParts[0].trim());
                        final longitude = double.parse(locationParts[1].trim());
                        mapsLink = "https://www.google.com/maps?q=$latitude,$longitude";
                      } catch (_) {}
                    }

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
                            const Text('Service Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 8),
                            ...booking.serviceIds?.map((service) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Name: ${service.name ?? 'N/A'}'),
                                        if (booking.productId != null && booking.productId!.isNotEmpty)
                                          Text('Product: ${productIdNameMap[booking.productId!] ?? 'Unknown'}'),
                                        Text('Details: ${service.details ?? 'N/A'}'),
                                        Text('Status: ${booking.status ?? 'N/A'}'),
                                        const Divider(height: 24),
                                      ],
                                    ),
                                  );
                                }).toList() ??
                                [const Text('No services listed.')],
                            const SizedBox(height: 12),

                            if (booking.status?.toLowerCase() == 'confirmed') ...[
                              if (!_startOtpSubmitted[index]!) ...[
                                const Text('Start OTP Verification',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _startOtpControllers[index],
                                  keyboardType: TextInputType.number,
                                  maxLength: 6,
                                  decoration: const InputDecoration(labelText: 'Enter Start OTP', counterText: ""),
                                  onChanged: (value) {
                                    setState(() {
                                      _startOtpFilled[index] = value.length == 6;
                                    });
                                  },
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: _startOtpFilled[index]!
                                      ? () {
                                          setState(() {
                                            _startOtpSubmitted[index] = true;
                                          });
                                        }
                                      : null,
                                  child: const Text("Start OTP"),
                                ),
                              ] else if (!_endOtpSubmitted[index]!) ...[
                                const SizedBox(height: 16),
                                const Text('End OTP Verification',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _endOtpControllers[index],
                                  keyboardType: TextInputType.number,
                                  maxLength: 6,
                                  decoration: const InputDecoration(labelText: 'Enter End OTP', counterText: ""),
                                  onChanged: (value) {
                                    setState(() {
                                      _endOtpFilled[index] = value.length == 6;
                                    });
                                  },
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: _endOtpFilled[index]!
                                      ? () {
                                          setState(() {
                                            _endOtpSubmitted[index] = true;
                                          });
                                        }
                                      : null,
                                  child: const Text("End OTP"),
                                ),
                              ] else
                                const Padding(
                                  padding: EdgeInsets.only(top: 12),
                                  child: Text('Service Completed',
                                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
                                ),
                            ],

                            const SizedBox(height: 12),
                            const Text('User Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 8),
                            Text('Username: ${booking.userId?.name ?? 'N/A'}'),
                            Text('Mobile: ${booking.userId?.mobile ?? 'N/A'}'),
                            Text('Email: ${booking.userId?.email ?? 'N/A'}'),
                            mapsLink != null
                                ? RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: "Location: ",
                                          style: TextStyle(color: Colors.black, fontSize: 20),
                                        ),
                                        TextSpan(
                                          text: mapsLink,
                                          style: const TextStyle(color: Colors.blue, fontSize: 20),
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
                            Text('Address: ${booking.address ?? 'N/A'}'),

                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    // Share action
                                  },
                                  icon: const Icon(Icons.share, color: Colors.blue),
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
