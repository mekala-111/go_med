import 'dart:convert';

import 'package:go_med/model/DIstributor_models/sparepartbookingstate.dart';
import '../auth_provider.dart';
import 'package:http/http.dart' as http;
import '../../utils/gomed_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../loader.dart';
import 'package:http/retry.dart';
import 'package:firebase_database/firebase_database.dart';

class SparepartBookingProvider extends StateNotifier<SparepartBookingState> {
  final Ref ref; // To access other providers
  SparepartBookingProvider(this.ref) : super((SparepartBookingState.initial()));

  // Function to add a product and handle the response
  Future<void> addSparepartBooking(
      String? address,
      String? location,
      String? sparepartId,
      String? serviceEngineerId,
      double? quantity,
      String? parentId,
      String distributorId,
      double? originalPrice,
      double? finalPrice,
      double? totalPrice,
      double? finalUnitPrice,
      String? paymentMethod,
      
      ) async {
    print(
        'Booking Details: Address-$address, Location-$location, Service Engineer ID-$serviceEngineerId, Quantity-$quantity, Spare Part ID-$sparepartId,distributorId:$distributorId,price:$originalPrice');

    final loadingState = ref.read(loadingProvider.notifier);

    try {
      // Start loading state
      loadingState.state = true;

      // Retrieve the token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String? userDataString = prefs.getString('userData');
      final apiUrl = Uri.parse("${Bbapi.bookingSparepart}");

      // Validate user data and token
      if (userDataString == null || userDataString.isEmpty) {
        throw Exception("User token is missing. Please log in again.");
      }

      final Map<String, dynamic> userData = jsonDecode(userDataString);
      String? token = userData['accessToken'];

      if (token == null || token.isEmpty) {
        token = userData['data'] != null &&
                (userData['data'] as List).isNotEmpty &&
                userData['data'][0]['access_token'] != null
            ? userData['data'][0]['access_token']
            : null;
      }

      if (token == null || token.isEmpty) {
        throw Exception("User token is invalid. Please log in again.");
      }

      print('Retrieved Token: $token');

     

      // Initialize RetryClient for retrying requests on failure
      final client = RetryClient(
        http.Client(),
        retries: 3, // Retry up to 3 times
        when: (response) =>
            response.statusCode == 400 ||
            response.statusCode == 401, // Retry on 400 or 401
        onRetry: (req, res, retryCount) async {
          if (retryCount == 0 && res?.statusCode == 400 ||
              res?.statusCode == 401) {
            // Handle token restoration logic on the first retry
            String? newAccessToken =
                await ref.read(loginProvider.notifier).restoreAccessToken();
            print('Restored Token:++++++++++ $newAccessToken');
            req.headers['Authorization'] = 'Bearer $newAccessToken';
          }
        },
      );

      // Make API call to add spare part booking
      final response = await client.post(
        apiUrl,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'address': address,
          'location': location,
          'serviceEngineerId': serviceEngineerId,
          'status': "pending",
          'type':paymentMethod,
          
          'userPrice':finalPrice,
           if (paymentMethod == 'cod')'paidprice': finalUnitPrice,
          'totalPrice':totalPrice,
          "Otp": "5765",
          'products': [
            {
              'distributorId': distributorId,
              'userPrice':finalPrice,
              'productId': sparepartId, // Spare Part ID
              'parentId': parentId, // Example parentId (replace as needed)
              // 'drRequestId': "68031f0be36c9278cb559940", // Example drRequestId (replace as needed)
              'quantity': quantity, // Quantity of the spare part
              'bookingStatus': "pending", // Default booking status

            }
          ],
        }),
      );

      // Check the status code and handle the response
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // final Map<String, dynamic> responseBody = jsonDecode(response.body);
        // final DatabaseReference dbRef =
        //     FirebaseDatabase.instance.ref().child('bookings');

        // final DatabaseReference distributorRef = dbRef.child(distributorId);

        // final DataSnapshot snapshot = await distributorRef.get();
        // final int totalPrice = ((originalPrice ?? 0) * 90 / 100).round();
        // if (snapshot.exists) {
        //   // Add to existing wallet
        //   final currentData = snapshot.value as Map;
        //   final int currentWallet =
        //       int.tryParse(currentData['wallet'].toString()) ?? 0;
        //   final int updatedWallet = currentWallet + totalPrice;

        //   await distributorRef.update({
        //     'wallet': updatedWallet,
        //   });

        //   print(
        //       "Updated wallet for distributor $distributorId: $updatedWallet");
        // } else {
        //   // Create new record
        //   await distributorRef.set({
        //     'distributor_id': distributorId,
        //     'wallet': totalPrice,
        //   });

        //   // print(
        //       // "Created new wallet record for distributor $distributorId: $price");
        // }

        print("SparepartBooking added successfully!");
      } else {
        // Handle errors
        try {
          final errorBody = jsonDecode(response.body);
          final errorMessage =
              errorBody['messages']?.join(", ") ?? 'Unexpected error occurred.';
          throw Exception("Error updating Booking: $errorMessage");
        } catch (e) {
          throw Exception("Invalid response format: ${response.body}");
        }
      }
    } catch (error) {
      // Handle any errors in the process
      print("Failed to add spare part booking: $error");
      rethrow; // Rethrow the error to propagate it
    } finally {
      // Reset loading state
      loadingState.state = false;
    }
  }

  Future<void> getSparepartBooking() async {
    final loadingState = ref.read(loadingProvider.notifier);
    final prefs = await SharedPreferences.getInstance();

    loadingState.state = true; // Show loading state

    try {
      loadingState.state = true;
      String? userDataString = prefs.getString('userData');
      if (userDataString == null || userDataString.isEmpty) {
        throw Exception("User token is missing. Please log in again.");
      }
      final Map<String, dynamic> userData = jsonDecode(userDataString);
      String? token = userData['accessToken'];

      if (token == null || token.isEmpty) {
        token = userData['data'] != null &&
                (userData['data'] as List).isNotEmpty &&
                userData['data'][0]['access_token'] != null
            ? userData['data'][0]['access_token']
            : null;
      }

      if (token == null || token.isEmpty) {
        throw Exception("User token is invalid. Please log in again.");
      }

      print('Retrieved Token: $token');

      final client = RetryClient(
        http.Client(),
        retries: 3,
        when: (response) =>
            response.statusCode == 401 || response.statusCode == 400,
        onRetry: (req, res, retryCount) async {
          if (retryCount == 0 &&
              (res?.statusCode == 401 || res?.statusCode == 400)) {
            print("Token expired, refreshing...");
            String? newAccessToken =
                await ref.read(loginProvider.notifier).restoreAccessToken();

            if (newAccessToken != null) {
              await prefs.setString('accessToken', newAccessToken);
              token = newAccessToken;
              req.headers['Authorization'] = 'Bearer $newAccessToken';
              print("New Token: $newAccessToken");
            }
          }
        },
      );
      final authState = ref.watch(loginProvider).data;
      final String? distributorId = authState?[0].details!.sId;

      final response = await client.get(
        Uri.parse("${Bbapi.getSparepartBooking}/$distributorId"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> res = json.decode(response.body);
        final sparepartData = SparepartBookingState.fromJson(res);
        state = sparepartData;
        print("serviceengineer sparepart booking fetched successfully");
      } else {
        throw Exception('Failed to load sparepart: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching sparepart: $e');
    } finally {
      loadingState.state = false; // Hide loading state
    }
  }

  Future<bool> deleteSparepartBooking(String? sparepartBookingId) async {
    final loadingState = ref.read(loadingProvider.notifier);
    const String apiUrl = Bbapi.deleteSparepartBooking;
    final loginmodel = ref.read(loginProvider);
    final token = loginmodel.data![0].accessToken;

    try {
      // final prefs = await SharedPreferences.getInstance();
      // String? token = prefs.getString('authToken');

      if (token == null || token.isEmpty) {
        throw Exception("User token is missing. Please log in again.");
      }
      loadingState.state = true; // Show loading state
      final client = RetryClient(
        http.Client(),
        retries: 4,
        when: (response) {
          return response.statusCode == 401 || response.statusCode == 400
              ? true
              : false;
        },
        onRetry: (req, res, retryCount) async {
          if (retryCount == 0 && res?.statusCode == 401 ||
              res?.statusCode == 400) {
            // Here, handle your token restoration logic
            // You can access other providers using ref.read if needed
            var accessToken =
                await ref.watch(loginProvider.notifier).restoreAccessToken();

            //print(accessToken); // Replace with actual token restoration logic
            req.headers['Authorization'] = 'Bearer $accessToken';
          }
        },
      );

      final response = await client.delete(
        Uri.parse("$apiUrl/$sparepartBookingId"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("sparepart booking  deleted successfully!");
        getSparepartBooking();
        return true;
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception(
            "Error deleting delete sparepart booking: ${errorBody['message'] ?? 'Unexpected error occurred.'}");
      }
    } catch (error) {
      throw Exception("Error deleting sparepartbooking: $error");
    }
  }

  Future<bool> updateSparepartBookings(String? bookingId, String? bookingStatus,
      String? sparepartId, String? parentId, String? distributorId,String? type,
      double? paidprice,double? totalprice,
      {required quantity,required otp,required price,required successQuantity}) async {
    final loadingState = ref.read(loadingProvider.notifier);
    loadingState.state = true;

    print(
        'Booking Data: , bookingId=$bookingId,quantity:$quantity,status:$bookingStatus, productId:$sparepartId,parentId:$parentId,distributorId-$distributorId');

    try {
      // Retrieve the token
      final prefs = await SharedPreferences.getInstance();
      final apiUrl = Uri.parse("${Bbapi.sparepartBookingUpdate}/$bookingId");
      String? userDataString = prefs.getString('userData');

      if (userDataString == null || userDataString.isEmpty) {
        throw Exception("User token is missing. Please log in again.");
      }

      final Map<String, dynamic> userData = jsonDecode(userDataString);
      String? token = userData['accessToken'];

      if (token == null || token.isEmpty) {
        token = (userData['data'] is List && userData['data'].isNotEmpty)
            ? userData['data'][0]['access_token']
            : null;
      }

      if (token == null || token.isEmpty) {
        throw Exception("User token is invalid. Please log in again.");
      }

      print('Retrieved Token: $token');

      // Debugging: Print full request
      print('API URL: $apiUrl');

      print('Body: ${jsonEncode({
            'bookingStatus': bookingStatus,
            // 'quantity':quantity,
            if (quantity != null) "quantity": quantity,
            'productId': sparepartId,
            'parentId': parentId,
            'distributorId': distributorId,
            'type':type
          })}');

      // Initialize RetryClient
      final client = RetryClient(http.Client(), retries: 3, when: (response) {
        return response.statusCode == 401 || response.statusCode == 404;
      });

      final response = await client.patch(
        apiUrl,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "products": [
            {
              "productId": sparepartId,
               if (quantity != null) "quantity": quantity,
              "bookingStatus": bookingStatus,
              'parentId': parentId,
              'distributorId': distributorId
              // ,'type':type
            }
          ],
          // "status": bookingStatus, // Optional if you want to update root status
           if (otp != null) 'Otp':otp,
          //  'type':type

        }),
      );

      print('Update Status Code: ${response.statusCode}');
      print('Update Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (bookingStatus == 'completed') {
          if (type == 'cod') {
            
            final DatabaseReference dbRef =
                FirebaseDatabase.instance.ref().child('bookings');

            final DatabaseReference distributorRef =
                dbRef.child(distributorId!);

            final DataSnapshot snapshot = await distributorRef.get();
            // final int totalPrice = ((price ?? 0) * 90 / 100).round();
           final int totalPrice = price * quantity;

           final double distribitorPrice = totalPrice * 0.125;// Equivalent to subtracting 12.5%

            if (snapshot.exists) {
              // Add to existing wallet
              final currentData = snapshot.value as Map;
              final int currentWallet =
                  int.tryParse(currentData['wallet'].toString()) ?? 0;
              final double updatedWallet = double.parse((currentWallet - distribitorPrice).toStringAsFixed(2));


              await distributorRef.update({
                'wallet': updatedWallet,
              });

              print(
                  "Updated wallet for distributor $distributorId: $updatedWallet");
            } else {
              // Create new record
              await distributorRef.set({
                'distributor_id': distributorId,
                'wallet': distribitorPrice,
              });

              print(
                  "Created new wallet record for distributor $distributorId: $price");
            }
          } else if (type == 'onlinepayment') {
            final DatabaseReference dbRef =
                FirebaseDatabase.instance.ref().child('bookings');

            final DatabaseReference distributorRef =
                dbRef.child(distributorId!);

            final DataSnapshot snapshot = await distributorRef.get();
            // final int totalPrice = ((price ?? 0) * 90 / 100).round();
           final int totalPrice = price * quantity;
           final double distributorPrice = totalPrice * 0.875; // Equivalent to subtracting 12.5%

            if (snapshot.exists) {
              // Add to existing wallet
              final currentData = snapshot.value as Map;
              final int currentWallet =
                  int.tryParse(currentData['wallet'].toString()) ?? 0;
              final double updatedWallet = double.parse((currentWallet + distributorPrice).toStringAsFixed(2));


              await distributorRef.update({
                'wallet': updatedWallet,
              });

              print(
                  "Updated wallet for distributor $distributorId: $updatedWallet");
            } else {
              // Create new record
              await distributorRef.set({
                'distributor_id': distributorId,
                'wallet': distributorPrice,
              });

              print(
                  "Created new wallet record for distributor $distributorId: $price");
            }
          }
        }

        print(" sparepart Booking updated successfully!");
        getSparepartBooking(); // Refresh bookings list
        return true;
      } else {
        final errorBody = jsonDecode(response.body);
        final errorMessage =
            errorBody['message'] ?? 'Unexpected error occurred.';
        throw Exception("Error updating Booking: $errorMessage");
      }
    } catch (error) {
      print("Failed to update sparepartBooking: $error");
      rethrow;
    } finally {
      loadingState.state = false;
    }
  }
}

// Define productProvider with ref
final sparepartBookingProvider =
    StateNotifierProvider<SparepartBookingProvider, SparepartBookingState>(
        (ref) {
  return SparepartBookingProvider(ref);
});
