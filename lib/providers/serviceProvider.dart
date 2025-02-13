import 'dart:convert';

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
      String? serviceDataString = prefs.getString('userData');
      print('printed.................');
      if (serviceDataString == null || serviceDataString.isEmpty) {
        throw Exception("User token is missing. Please log in again.");
      }
      final Map<String, dynamic> userData = jsonDecode(serviceDataString);
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
            // print('Restored Token: $newAccessToken');
            req.headers['Authorization'] = 'Bearer $newAccessToken';
          }
        },
      );

      final response = await client.post(Uri.parse(Bbapi.serviceAdd),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "name": name,
            "details": details,
            "price": price,
            "productIds": productIds
          }));
      print('add to end point==============');
      //  final streamedResponse = await client.send(response);
      // final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Data successfully sent to the API.");
        var serviceDetails = json.decode(response.body);
        ServiceModel user = ServiceModel.fromJson(serviceDetails);

        final serviceData = json.encode({
          'statusCode': user.statusCode,
          'success': user.success,
          'messages': user.messages,
          // 'data': user.data?.map((data) => data.toJson()).toList(),
        });
        print("service Data to Save in SharedPreferences: $serviceData");
        await prefs.setString('userData', serviceData);
      } else {
        print(
            "Failed to send data to the API. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error while sending data to the API: $e");
    }
  }
}

final serviceProvider =
    StateNotifierProvider<ServiceProvider, ServiceModel>((ref) {
  return ServiceProvider(ref);
});
