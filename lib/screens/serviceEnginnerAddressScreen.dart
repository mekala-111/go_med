import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:convert';

import '../providers/auth_provider.dart';
import '../providers/spareparetbookingprovider.dart';

class AddressScreen extends ConsumerStatefulWidget {
  const AddressScreen({super.key});

  @override
  ConsumerState<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends ConsumerState<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController addressController = TextEditingController();
  List<String> sparepartIds = [];

  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  String _currentAddress = "Fetching location...";

  @override
  void initState() {
    super.initState();
    _fetchInitialLocation();

    Future.delayed(Duration.zero, () {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null && args.containsKey('sparePartIds')) {
        setState(() {
          final receivedIds = args['sparePartIds'];
          if (receivedIds is String) {
            sparepartIds = [receivedIds];
          } else if (receivedIds is List) {
            sparepartIds = List<String>.from(receivedIds.map((e) => e.toString()));
          }
          print('Received spare part IDs: $sparepartIds');
        });
      }
    });
  }

  Future<void> _fetchInitialLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _currentAddress = "Location services are disabled.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _currentAddress = "Location permission denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _currentAddress = "Location permanently denied. Enable from settings.");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_currentPosition!, 15),
    );

    await _getAddressFromLatLng(position.latitude, position.longitude);
  }

  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          _currentAddress = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        });
      }
    } catch (e) {
      setState(() => _currentAddress = "Failed to fetch address.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final loginData = ref.watch(loginProvider).data ?? [];
    String? loggedInEngineerId = loginData.isNotEmpty ? loginData[0].details?.sId : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Address"),
        backgroundColor: const Color(0xFF6BC37A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              const Text("Location:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(_currentAddress, style: const TextStyle(fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 10),
              Expanded(
                child: _currentPosition == null
                    ? const Center(child: CircularProgressIndicator())
                    : GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _currentPosition!,
                          zoom: 15,
                        ),
                        myLocationEnabled: true,
                        onMapCreated: (GoogleMapController controller) {
                          _mapController = controller;
                        },
                        onCameraMove: (CameraPosition position) {
                          setState(() {
                            _currentPosition = position.target;
                          });
                        },
                        onCameraIdle: () async {
                          if (_currentPosition != null) {
                            await _getAddressFromLatLng(
                              _currentPosition!.latitude,
                              _currentPosition!.longitude,
                            );
                          }
                        },
                        markers: {
                          Marker(
                            markerId: const MarkerId("live_location"),
                            position: _currentPosition!,
                            infoWindow: const InfoWindow(title: "You are here"),
                            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                          ),
                        },
                      ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Builder(
                  builder: (context) => ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        print('Booking spare part...');

                        if (sparepartIds.isEmpty) {
                          _showSnackBar(context, "No spare parts selected.");
                          return;
                        }

                        if (_currentPosition == null) {
                          _showSnackBar(context, "Location not found. Try again.");
                          return;
                        }

                        if (loggedInEngineerId == null || loggedInEngineerId!.isEmpty) {
                          _showSnackBar(context, "Service Engineer ID is missing.");
                          return;
                        }

                        String formattedLocation = "${_currentPosition!.latitude},${_currentPosition!.longitude}";

                        try {
                          await ref.read(sparepartBookingProvider.notifier).addSparepartBooking(
                                addressController.text,
                                formattedLocation,
                                loggedInEngineerId,
                                sparepartIds,
                              );

                          _showSnackBar(context, "Spare part booked successfully!");
                          Navigator.of(context).pop();
                        } catch (e) {
                          _showSnackBar(context, "Error: ${e.toString()}");
                        }
                      } else {
                        _showSnackBar(context, "Please fill all fields.");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 31, 176, 84),
                      minimumSize: Size(screenWidth * 0.9, screenHeight * 0.06),
                    ),
                    child: Text(
                      "Book Spare Part",
                      style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: message.contains("Error") ? Colors.red : Colors.blue,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
