import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import '../../providers/auth_provider.dart';
import '../../providers/Distributor_provider/spareparetbookingprovider.dart';
import 'serviceEngineerProductsscreen.dart';
import 'Rezorpay_screen.dart';

class AddressScreen extends ConsumerStatefulWidget {
  const AddressScreen({super.key});

  @override
  ConsumerState<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends ConsumerState<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController addController = TextEditingController();
  final TextEditingController locationSearchController =
      TextEditingController();
  // List<String> sparepartIds = [];
  late String sparepartIds;
  String? parentId;
  String? distributorId;
  double? price;

  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  String _currentAddress = "Fetching location...";
  // final TextEditingController quantityController = TextEditingController();
  double? enteredQuantity;

  @override
  void initState() {
    super.initState();
    _fetchInitialLocation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      sparepartIds = args['sparePartId'];
      // quantity = args['quantity']?.toString();
      enteredQuantity = args['enteredQuantity'];
      parentId = args['parentId'];
      price = args['price'];
      distributorId = args['distributorId'];
      print('🛠️ Received Spare Part ID: $sparepartIds');
      print('📦 Received Quantity: $enteredQuantity');
      print('price of sparepart...$price');
      print('distributor id...$distributorId');
    } else {
      print('⚠️ No arguments received.');
    }
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
      setState(() => _currentAddress =
          "Location permanently denied. Enable from settings.");
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
        String newAddress =
            "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        setState(() {
          _currentAddress = newAddress;
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
    String? loggedInEngineerId =
        loginData.isNotEmpty ? loginData[0].details?.sId : null;

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
                controller: addController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              const Text(
                "Search Location:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              FocusScope(
                node: FocusScopeNode(),
                child: GooglePlaceAutoCompleteTextField(
                  textEditingController: locationSearchController,
                  googleAPIKey: "AIzaSyCMADwyS3eoxJ5dQ_iFiWcDBA_tJwoZosw",
                  inputDecoration: InputDecoration(
                    hintText: "Search for location",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  ),
                  debounceTime: 800,
                  isLatLngRequired: true,
                  getPlaceDetailWithLatLng: (prediction) {
                    double lat = double.parse(prediction.lat!);
                    double lng = double.parse(prediction.lng!);
                    setState(() {
                      _currentPosition = LatLng(lat, lng);
                    });
                    _mapController?.animateCamera(
                        CameraUpdate.newLatLngZoom(_currentPosition!, 15));
                    _getAddressFromLatLng(lat, lng);
                  },
                  itemClick: (prediction) {
                    locationSearchController.text = prediction.description!;
                    locationSearchController.selection =
                        TextSelection.fromPosition(
                      TextPosition(offset: prediction.description!.length),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
              const Text("Location:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(_currentAddress,
                  style: const TextStyle(fontSize: 14, color: Colors.black54)),
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
                                _currentPosition!.longitude);
                          }
                        },
                        markers: {
                          Marker(
                            markerId: const MarkerId("live_location"),
                            position: _currentPosition!,
                            infoWindow: const InfoWindow(title: "You are here"),
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueBlue),
                          ),
                        },
                      ),
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      if (_currentPosition == null) {
                        _showSnackBar(
                            context, "Location not found. Try again.");
                        return;
                      }

                      if (loggedInEngineerId == null ||
                          loggedInEngineerId.isEmpty) {
                        _showSnackBar(
                            context, "Service Engineer ID is missing.");
                        return;
                      }

                      String formattedLocation =
                          "${_currentPosition!.latitude},${_currentPosition!.longitude}";

                      // Navigate to RazorpayScreen with arguments
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RazorpayPaymentPage(
                              address: addController.text,
                              location: formattedLocation,
                              sparepartIds: sparepartIds,
                              engineerId: loggedInEngineerId,
                              quantity: enteredQuantity,
                              parentId: parentId,
                              price: price,
                              distributorId:distributorId),
                        ),
                      );
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
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.white,
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
