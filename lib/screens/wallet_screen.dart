import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/wallet_provider.dart';
import '../providers/auth_provider.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModel = ref.watch(loginProvider);
    final distributorId = userModel.data?.first.details?.sId ?? '';

    final walletAsync = ref.watch(walletProvider(distributorId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wallet'),
      ),
      body: Center(
        child: walletAsync.when(
          data: (wallet) {
            if (wallet != null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.account_balance_wallet, size: 80, color: Colors.green),
                  const SizedBox(height: 20),
                  const Text(
                    'Wallet Balance:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '₹ $wallet',
                    style: const TextStyle(fontSize: 32, color: Colors.black87),
                  ),
                ],
              );
            } else {
              return const Text('Wallet not found for this distributor');
            }
          },
          loading: () => const CircularProgressIndicator(),
          error: (err, stack) => Text('Error: $err'),
        ),
      ),
    );
  }
}
