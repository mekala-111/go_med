import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:go_med/model/servicesState.dart';
import 'package:go_med/providers/loader.dart';
import 'package:http/http.dart' as http;
// import 'package:me';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/gomed_api.dart';
import 'package:http/retry.dart';
import '../providers/auth_provider.dart';

class ServiceProvider extends StateNotifier<ServiceModel> {
  final Ref ref;
  ServiceProvider(this.ref) : super((ServiceModel.initial()));

  Future<void> addService(String? name, String? details, double? price,
      List<String> productIds) async {
    print(
        'service data: name:$name,details:$details,price:$price,productids:$productIds');

    final loadingState = ref.read(loadingProvider.notifier);

    try {
      loadingState.state = true;
      final prefs = await SharedPreferences.getInstance();
      String? userDataStringString = prefs.getString('userData');
      print('printed.................');
      if (userDataStringString == null || userDataStringString.isEmpty) {
        throw Exception("User token is missing. Please log in again.");
      }
      final Map<String, dynamic> userData = jsonDecode(userDataStringString);
      String? token = userData['accessToken'];

      if (token == null || token.isEmpty) {
        token = userData['data'] != null &&
                (userData['data'] as List).isNotEmpty &&
                userData['data'][0]['access_token'] != null
            ? userData['data'][0]['access_token']
            : null;
      }

      print('Retrieved Token: $token');
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

            print('Restored Token::::::::::::::: $newAccessToken');
            req.headers['Authorization'] = 'Bearer $newAccessToken';
          }
        },
      );

      final response = await client.post(Uri.parse(Bbapi.serviceAdd),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({
            "name": name,
            "details": details,
            "price": price,
            "productIds": productIds
          }));

      print("Response Body: ${response.body}");

      //  final streamedResponse = await client.send(response);
      // final responseBody = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(" service Data successfully sent to the API.");
        getSevices();
        var serviceDetails = json.decode(response.body);
        print('service add responce body $serviceDetails');
      } else {
        print(
            "Failed to send data to the API. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error while sending data to the API: $e");
    }
  }

  Future<void> getSevices() async {
    final loadingState = ref.read(loadingProvider.notifier);
    try {
      loadingState.state = true;
      // Retrieve the token from SharedPreferences
      final pref = await SharedPreferences.getInstance();
      String? userDataString = pref.getString('userData');
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
      print('Retrieved Token: $token');
      // Initialize RetryClient for handling retries
      final client = RetryClient(
        http.Client(),
        retries: 3, // Retry up to 3 times
        when: (response) =>
            response.statusCode == 401 || response.statusCode == 400,
        onRetry: (req, res, retryCount) async {
          if (retryCount == 0 &&
              (res?.statusCode == 401 || res?.statusCode == 400)) {
            String? newAccessToken =
                await ref.read(loginProvider.notifier).restoreAccessToken();
            req.headers['Authorization'] = 'Bearer $newAccessToken';
          }
        },
      );
      final response = await client.get(
        Uri.parse(Bbapi.getService),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      final responseBody = response.body;
      print('Get service Status Code: ${response.statusCode}');
      print('Get service Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final res = json.decode(responseBody);
        // Check if the response body contains
        final serviceData = ServiceModel.fromJson(res);
        state = serviceData;
        print("services fetched successfully.${serviceData.messages}");
      } else {
        final Map<String, dynamic> errorBody = jsonDecode(responseBody);
        final errorMessage =
            errorBody['message'] ?? "Unexpected error occurred.";
        throw Exception("Error fetching services: $errorMessage");
      }
    } catch (e) {
      print("Failed to fetch services: $e");
    }
  }

  Future<bool> updateService(
    String? name,
    String? details,
    double? price,
    List<String> productIds,
    String? serviceId,
  ) async {
    final loadingState = ref.read(loadingProvider.notifier);
    loadingState.state = true;

    try {
      // Retrieve the token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
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

      // Initialize RetryClient for handling retries
      final client = RetryClient(
        http.Client(),
        retries: 3, // Retry up to 3 times
        when: (response) =>
            response.statusCode == 401 || response.statusCode == 404,
        onRetry: (req, res, retryCount) async {
          if (retryCount == 0 &&
              (res?.statusCode == 401 || res?.statusCode == 404)) {
            String? newAccessToken =
                await ref.read(loginProvider.notifier).restoreAccessToken();
            req.headers['Authorization'] = 'Bearer $newAccessToken';
          }
        },
      );
      final response = await client.post(Uri.parse(Bbapi.ServiceUpdate),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({
            "name": name,
            "details": details,
            "price": price,
            "productIds": productIds,
            "serviceId": serviceId
          }));

      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Services updated successfully!");
        getSevices(); // Refresh product list
        return true;
      } else {
        final errorBody = jsonDecode(response.body);
        final errorMessage =
            errorBody['message'] ?? 'Unexpected error occurred.';
        throw Exception("Error updating service: $errorMessage");
      }
    } catch (error) {
      print("Failed to update service: $error");
      rethrow;
    } finally {
      loadingState.state = false;
    }
  }

  Future<bool> deleteService(String? serviceId) async {
    print('delete serviceid........$serviceId');
    final loadingState = ref.read(loadingProvider.notifier);
    const String apiUrl = Bbapi.deleteService;
    final loginmodel = ref.read(loginProvider);
    final token = loginmodel.data![0].accessToken;

    try {
      // final prefs = await SharedPreferences.getInstance();
      // String? token = prefs.getString('authToken');
      print('delete try executes');

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
      print('delete function..............');
      final response = await client.delete(
        Uri.parse("$apiUrl/$serviceId"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      print('deleteresponse$response');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Service deleted successfully!");
        getSevices();
        return true;
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception(
            "Error deleting Service: ${errorBody['message'] ?? 'Unexpected error occurred.'}");
      }
    } catch (error) {
      throw Exception("Error deleting Service: $error");
    }
  }
}

final serviceProvider =
    StateNotifierProvider<ServiceProvider, ServiceModel>((ref) {
  return ServiceProvider(ref);
});
