import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/gomed_api.dart';
import '../auth_provider.dart';
import 'package:go_med/model/Serviceengineer_model/servicesState.dart';
import 'package:go_med/providers/loader.dart';

class WalletDataProvider extends StateNotifier<ServiceModel> {
  final Ref ref;
  WalletDataProvider(this.ref) : super(ServiceModel.initial());

  Future<void> addWalletData(
    String distributorId,
    String? amount,
    String? name,
    String? selectedMethod, {
    required upi,
    String? ifscNumber,
    String? accountNUmber,
  }) async {
    print(
        'wallet details data: name:$name,accountnumber:$accountNUmber,ifsc:$ifscNumber,amount:$amount,distributorId:$distributorId,upi:$upi');

    final loadingState = ref.read(loadingProvider.notifier);

    try {
      loadingState.state = true;

      final prefs = await SharedPreferences.getInstance();
      String? userDataString = prefs.getString('userData');

      print('printed.................');

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

      final client = RetryClient(
        http.Client(),
        retries: 3,
        when: (response) =>
            response.statusCode == 400 || response.statusCode == 401,
        onRetry: (req, res, retryCount) async {
          if (retryCount == 0 && (res?.statusCode == 400 || res?.statusCode == 401)) {
            String? newAccessToken =
                await ref.read(loginProvider.notifier).restoreAccessToken();

            print('Restored Token::::::::::::::: $newAccessToken');
            req.headers['Authorization'] = 'Bearer $newAccessToken';
          }
        },
      );

      final requestBody = {
        'userId': distributorId,
        'amount': int.tryParse(amount ?? '0') ?? 0,
        'name': name,
        if (ifscNumber != null) 'ifsc': ifscNumber,
        if (accountNUmber != null) 'accountNumber': accountNUmber,
        if (upi != null) 'upiId': upi,
      };

      print("🔁 Final Sent Body: ${jsonEncode(requestBody)}");

      final response = await client.post(
        Uri.parse(Bbapi.transactionAdd),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestBody),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body (raw): "${response.body}"');

     
      
        if (response.statusCode == 200 || response.statusCode == 201) {
          
          print("✅ Wallet data successfully sent to the API.");
          // Update state or do other processing if needed here
        } else {
          print(
              "❌ Failed to send data to the API. Status code: ${response.statusCode}");
        }
      
    } catch (e) {
      print('❌ Invalid response format: $e');
      throw Exception("Invalid response format.");
    } finally {
      loadingState.state = false;
    }
  }
}

final walletDataProvider =
    StateNotifierProvider<WalletDataProvider, ServiceModel>((ref) {
  return WalletDataProvider(ref);
});
