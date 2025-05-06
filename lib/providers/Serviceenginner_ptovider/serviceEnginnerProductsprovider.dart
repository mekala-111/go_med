import 'dart:convert';
import '../auth_provider.dart';
import 'package:http/http.dart' as http;
import '../../utils/gomed_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../loader.dart';
import 'package:http/retry.dart';
import '../../model/Serviceengineer_model/ServiceEngineerProductsModel.dart';

class ServiceEnginnerProductsProvider extends StateNotifier<ServiceEngineerProductsModel> {
  final Ref ref; // To access other providers
  ServiceEnginnerProductsProvider
(this.ref) : super((ServiceEngineerProductsModel.initial()));

  
  Future<void> getServiceEnginnerProducts() async {
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
        Uri.parse(Bbapi.serviceEnginnerProductsApproved),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> res = json.decode(response.body);
        final sparepartData = ServiceEngineerProductsModel.fromJson(res);
        state = sparepartData;
        print("service Enginneer products fetched successfully");
      } else {
        throw Exception('Failed to load serviceenginner products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching service enginner products: $e');
    } finally {
      loadingState.state = false; // Hide loading state
    }
  }
 
}
// Define RequestAccepted products with ref
final serviceEngineerProductsProvider =StateNotifierProvider<ServiceEnginnerProductsProvider,ServiceEngineerProductsModel>(
        (ref) {
  return ServiceEnginnerProductsProvider
(ref);
});

