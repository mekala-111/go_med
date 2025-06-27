import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_med/model/DIstributor_models/bookings_state.dart';
import 'package:go_med/utils/gomed_api.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:firebase_database/firebase_database.dart';
import '../loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth_provider.dart';

class BookingsProvider extends StateNotifier<BookingModel> {
  final Ref ref; // To access other providers
  BookingsProvider(this.ref) : super((BookingModel.initial()));

  Future<void> getBookings() async {
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

      String? token = userData['accessToken'] ??
          (userData['data'] != null &&
                  (userData['data'] as List).isNotEmpty &&
                  userData['data'][0]['access_token'] != null
              ? userData['data'][0]['access_token']
              : null);

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

            await prefs.setString('accessToken', newAccessToken);
            token = newAccessToken;
            req.headers['Authorization'] = 'Bearer $newAccessToken';
            print("New Token: $newAccessToken");
          }
        },
      );
      final authState = ref.watch(loginProvider).data;
      final String? distributorId = authState?[0].details!.sId;
      // Get distributor ID

      final response = await client.get(
        Uri.parse("${Bbapi.bookingsGet}/$distributorId"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> res = json.decode(response.body);
        final bookingData = BookingModel.fromJson(res);
        state = bookingData;
        print(" product bookings fetched successfully");
      } else {
        throw Exception('Failed to load bookings: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching bookings: $e');
    } finally {
      loadingState.state = false; // Hide loading state
    }
  }

  Future<bool> updateBookings(String? bookingId, String? bookingStatus,
      String? productId, String? distributorId,
      {required quantity,
      required otp,
      required successQuantity,
      required price,
      required type}) async {
    final loadingState = ref.read(loadingProvider.notifier);
    loadingState.state = true;

    print(
        'Booking Data: , bookingId=$bookingId,quantity:$quantity,status:$bookingStatus, productId:$productId, distributorId:$distributorId,otp:$otp,,type:$type');

    try {
      // Retrieve the token
      final prefs = await SharedPreferences.getInstance();
      final apiUrl = Uri.parse("${Bbapi.bookingUpdate}/$bookingId");
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
      print('Headers: ${jsonEncode({
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          })}');
      print('Body: ${jsonEncode({
            'bookingStatus': bookingStatus,
            // 'quantity':quantity,
            if (quantity != null) "quantity": quantity,
            'productId': productId,
            if (otp != null) "otp": otp,
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
              "productId": productId,
              if (quantity != null) "quantity": quantity,
              "bookingStatus": bookingStatus,
              "distributorId": distributorId,
            },
          ],
          if (otp != null) "Otp": otp,
        }),
      );

      print('Update Status Code: ${response.statusCode}');
      print('Update Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('after 200 condition  successfull');
        if (bookingStatus == 'completed') {
          print('completed...........');
          print('Booking type: $type');

          if (type == 'cod') {
            print('completed...........cod');
            final DatabaseReference dbRef =
                FirebaseDatabase.instance.ref().child('bookings');

            final DatabaseReference distributorRef =
                dbRef.child(distributorId!);

            final DataSnapshot snapshot = await distributorRef.get();
            // final int totalPrice = ((price ?? 0) * 90 / 100).round();
            print("data.........price:$price,quantity:$successQuantity");

            final int safePrice = price ?? 0;
            final int safeQuantity = successQuantity ?? 0;
            final int totalPrice = safePrice * safeQuantity;

            print("data.........price:$price,quantity:$successQuantity");

            final double distribitorPrice =
                totalPrice * 0.125; // Equivalent to subtracting 12.5%

            if (snapshot.exists) {
              // Add to existing wallet
              final currentData = snapshot.value as Map;
              final double currentWallet =
                  double.tryParse(currentData['wallet'].toString()) ?? 0;
              print('currnet wallet amount...$currentWallet');
              final double updatedWallet = double.parse(
                  (currentWallet - distribitorPrice).toStringAsFixed(2));

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
            print('completed..........onlinpayment.');
            final DatabaseReference dbRef =
                FirebaseDatabase.instance.ref().child('bookings');

            final DatabaseReference distributorRef =
                dbRef.child(distributorId!);

            final DataSnapshot snapshot = await distributorRef.get();
            // final int totalPrice = ((price ?? 0) * 90 / 100).round();
             print("data.........price:$price,quantity:$successQuantity");
            final int safePrice = price ?? 0;
            final int safeQuantity = successQuantity ?? 0;
            final int totalPrice = safePrice * safeQuantity;

            final double distributorPrice =
                totalPrice * 0.875; // Equivalent to subtracting 12.5%

            if (snapshot.exists) {
              // Add to existing wallet
              final currentData = snapshot.value as Map;
              final double currentWallet =
                  double.tryParse(currentData['wallet'].toString()) ?? 0;
                  print('currnet wallet amount...$currentWallet');
              final double updatedWallet = double.parse(
                  (currentWallet + distributorPrice).toStringAsFixed(2));

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

        print("product Booking updated successfully!");
        getBookings(); // Refresh bookings list
        return true;
      } else {
        final errorBody = jsonDecode(response.body);
        final errorMessage =
            errorBody['messages'] != null && errorBody['messages'].isNotEmpty
                ? errorBody['messages'][0]
                : 'Unexpected error occurred.';

        throw Exception("Error updating Booking: $errorMessage");
      }
    } catch (error) {
      print("Failed to update Booking: $error");
      rethrow;
    } finally {
      loadingState.state = false;
    }
  }
}

// Define productProvider with ref
final bookingProvider =
    StateNotifierProvider<BookingsProvider, BookingModel>((ref) {
  return BookingsProvider(ref);
});
