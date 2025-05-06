import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_med/utils/gomed_api.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:go_med/model/DIstributor_models/Quantity_parts_model.dart';
import '../loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth_provider.dart';

class QuantityPartsProvider extends StateNotifier<QuantityPartsModel> {
  final Ref ref; // To access other providers
  QuantityPartsProvider(this.ref) : super((QuantityPartsModel.initial()));
  Future<void> addQuatity(
     
       List<Map<String, dynamic>> selectedData,
    ) async {
    final loadingState = ref.read(loadingProvider.notifier);
    print(
        'data...===== $selectedData');
    try {
      loadingState.state = true;
     
      final prefs = await SharedPreferences.getInstance();
      String? userDataString = prefs.getString('userData');
      final apiUrl = Uri.parse(Bbapi.requestProduct);

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

      
      // final  request= await client.post(
      //   apiUrl,
      //   headers: {
      //     "Authorization": "Bearer $token",
      //     "Content-Type": "application/json",
      //   },
      //   body: jsonEncode({
      //     'products':selectedData,
          
      //   }),
        
      // );
      final cleanedProducts = selectedData.map((item) => {
  'productId': item['productId'],
  'price': item['price'],
  'quantity': item['quantity'],
}).toList();

final request = await client.post(
  apiUrl,
  headers: {
    "Authorization": "Bearer $token",
    "Content-Type": "application/json",
  },
  body: jsonEncode({'products': cleanedProducts}),
);

      
      

      

      
      // Sending Request
     
      // final streamedResponse = await client.send(request as http.BaseRequest);
      // final response = await http.Response.fromStream(streamedResponse);
      // // Reading Response
      // // final responseBody = await response.stream.bytesToString();
      // print('Response Status Code: ${response.statusCode}');
      // print('Response Body: ${response.body}');
      // try {
      //   final Map<String, dynamic> responseBody = jsonDecode(response.body);
      //   // Continue with the usual process
      // } catch (e) {
      //   print('Error decoding response body: $e');
      //   // Handle error or throw an exception
      // }

      if (request.statusCode == 201 || request.statusCode == 200) {
        print("Quatity added successfully!");
        // getProducts(); 
         
      } else {
        final errorBody = jsonDecode(request.body);
        final errorMessage =
            errorBody['message'] ?? 'Unexpected error occurred.';
        throw Exception("Error adding Quantity: $errorMessage");
      }
    } catch (error) {
      print("Failed to add Quantity: $error");
      rethrow;
    } finally {
      loadingState.state = false;
    }
  }
}
final quantityPartsProvider =
    StateNotifierProvider<QuantityPartsProvider, QuantityPartsModel>((ref) {
  return QuantityPartsProvider(ref);
});
