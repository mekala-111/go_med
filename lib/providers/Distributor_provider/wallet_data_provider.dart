import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:go_med/model/Serviceengineer_model/servicesState.dart';
import 'package:go_med/providers/loader.dart';
import 'package:http/http.dart' as http;
// import 'package:me';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/gomed_api.dart';
import 'package:http/retry.dart';
import '../auth_provider.dart';

class WalletDataProvider extends StateNotifier<ServiceModel> {
  final Ref ref;
  WalletDataProvider(this.ref) : super((ServiceModel.initial()));

  Future<void> addWalletData(String distributorId, String? amount,
     String? name,String? selectedMethod,
      {required upi,  String? ifscNumber, String? accountNUmber,}) async {
    print(
        'wallet details data: name:$name,accountnumber:$accountNUmber,ifsc:$ifscNumber,amount:$amount,distributorId:$distributorId,upi:$upi');

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

      final response = await client.post(Uri.parse(Bbapi.transactionAdd),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({
            'userId': distributorId,
            'amount': int.tryParse(amount ?? '0') ?? 0,
            'name': name,
            if(selectedMethod=='Banking')'ifsc': ifscNumber,
             if(selectedMethod=='Banking')'accountNumber': accountNUmber,
             if(selectedMethod=='UPI')'upiId':upi
            
          }));

      print("Response Body: ${response.body}");

      //  final streamedResponse = await client.send(response);
      // final responseBody = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final int withdrawAmount = int.tryParse(amount ?? '0') ?? 0;

        final DatabaseReference dbRef =
            FirebaseDatabase.instance.ref().child('bookings');
        final DatabaseReference distributorRef = dbRef.child(distributorId);

        final DataSnapshot snapshot = await distributorRef.get();

        if (snapshot.exists) {
          final currentData = snapshot.value as Map;
          final int currentWallet =
              int.tryParse(currentData['wallet'].toString()) ?? 0;

          if (withdrawAmount > currentWallet) {
            print(
                '❌ Withdraw amount ₹$withdrawAmount exceeds current wallet balance ₹$currentWallet');
          } else {
            final int updatedWallet = currentWallet - withdrawAmount;
            await distributorRef.update({'wallet': updatedWallet});
            print('✅ Withdraw successful. New wallet balance: ₹$updatedWallet');
          }
        } else {
          print('❌ Wallet data not found for distributor $distributorId');
        }

        print(" wallet Data successfully sent to the API.");

        var withDrawDetails = json.decode(response.body);
        print('wallet data add responce body $withDrawDetails');
      } else {
        print(
            "Failed to send data to the API. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print('❌ Invalid response format: $e');
  throw Exception("Invalid response format.");
    }
  }
}

final walletDataProvider =
    StateNotifierProvider<WalletDataProvider, ServiceModel>((ref) {
  return WalletDataProvider(ref);
});
