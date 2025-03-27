import 'dart:convert';

import 'package:go_med/model/sparepartbookingstate.dart';
import '../providers/auth_provider.dart';
import 'package:http/http.dart' as http;
import '../utils/gomed_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/loader.dart';
import 'package:http/retry.dart';

class SparepartBookingProvider extends StateNotifier<SparepartBookingState> {
  final Ref ref; // To access other providers
  SparepartBookingProvider(this.ref) : super((SparepartBookingState.initial()));

  // Function to add a product and handle the response
  Future<void> addSparepartBooking(String? address, String? location,
      String? serviceEngineerId, List<String> sparepartId) async {
    print(
        'data of booking...address-$address,locstion-$location,servicid-$serviceEngineerId,sparepartid-$sparepartId ');
    final loadingState = ref.read(loadingProvider.notifier);

    try {
      loadingState.state = true;

      // Retrieve the token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String? userDataString = prefs.getString('userData');
      final apiUrl = Uri.parse("${Bbapi.bookingSparepart}");

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
      // Initialize RetryClient for handling retries
      final client = RetryClient(
        http.Client(),
        retries: 3, // Retry up to 3 times
        when: (response) =>
            response.statusCode == 400 ||
            response.statusCode == 401, // Retry on 401 Unauthorized
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

      // Creating a Multipart Request
      final response = await client.post(
        apiUrl,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'address': address,
          'location': location,
          //  'sparePartIds':sparepartId.t,
          'sparePartIds': sparepartId, // ✅ Convert to list
           'serviceEngineerId':serviceEngineerId.toString(),
          'status': "pending",
        }),
        
      );
      
      

      // Sending Request
      print('Update Status Code: ${response.statusCode}');
      print('Update Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("sparepartBooking updated successfully!");
      } else {
        final errorBody = jsonDecode(response.body);
        final errorMessage =
            errorBody['message'] ?? 'Unexpected error occurred.';
        throw Exception("Error updating Booking: $errorMessage");
      }
    } catch (error) {
      print("Failed to add sparepartbooking: $error");
      rethrow;
    } finally {
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

      final response = await client.get(
        Uri.parse(Bbapi.getSparepartBooking),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> res = json.decode(response.body);
        final sparepartData= SparepartBookingState.fromJson(res);
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
}
  


























// Define productProvider with ref
final sparepartBookingProvider =
    StateNotifierProvider<SparepartBookingProvider, SparepartBookingState>(
        (ref) {
  return SparepartBookingProvider(ref);
});
