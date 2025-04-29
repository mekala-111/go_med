import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_med/utils/gomed_api.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

import '../providers/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth_provider.dart';
import '../model/serviceengineersparepartbookingmodel.dart';

class ServiceEnginnersparepartBookingProvider extends StateNotifier<ServiceengineersparepartbookingModel> {
  final Ref ref; // To access other providers
  ServiceEnginnersparepartBookingProvider(this.ref) : super((ServiceengineersparepartbookingModel.initial()));

  Future<void> fetchSparepartBookings() async {
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
        Uri.parse(Bbapi.serviceEnginnerSparepartBooking),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> res = json.decode(response.body);
        final productData = ServiceengineersparepartbookingModel.fromJson(res);
        state = productData;
        print("serviceengineer sparepartbooking fetched successfully");
      } else {
        throw Exception('Failed to load sparepartbooking: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching sparepartBooking: $e');
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
        fetchSparepartBookings();
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
final serciceEngineerSparepartBookingProvider =
    StateNotifierProvider<ServiceEnginnersparepartBookingProvider, ServiceengineersparepartbookingModel>((ref) {
  return ServiceEnginnersparepartBookingProvider(ref);
});
