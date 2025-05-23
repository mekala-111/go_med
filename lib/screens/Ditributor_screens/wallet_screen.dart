import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_med/providers/Distributor_provider/wallet_data_provider.dart';
import '../../providers/Distributor_provider/wallet_provider.dart';
import '../../providers/auth_provider.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModel = ref.watch(loginProvider);
    final distributorId = userModel.data?.first.details?.sId ?? '';
    print('DistributorId........$distributorId');
    final walletAsync = ref.watch(walletProvider(distributorId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wallet'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: walletAsync.when(
                data: (wallet) {
                  print('walletAmount....$wallet');
                  if (wallet != null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.account_balance_wallet,
                            size: 80, color: Colors.green),
                        const SizedBox(height: 20),
                        // wallet == null
                            // ? const CircularProgressIndicator()
                            Text('₹${wallet.toString()}'),
                        const SizedBox(height: 10),
                        Text(
                          '₹ $wallet',
                          style: const TextStyle(
                              fontSize: 32, color: Colors.black87),
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
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    _showWithdrawConfirmation(context, ref, distributorId);
                  },
                  child: const Text(
                    'Withdraw',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showWithdrawConfirmation(
      BuildContext context, WidgetRef ref, String distributorId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Withdraw Money'),
        content: const Text('Do you want to withdraw money?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              _showWithdrawForm(context, ref, distributorId);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _showWithdrawForm(
      BuildContext context, WidgetRef ref, String distributorId) {
    final walletBalance = ref.read(walletProvider(distributorId)).value ?? 0;

    final _formKey = GlobalKey<FormState>();
    final amountController = TextEditingController();
    final ifscController = TextEditingController();
    final accountNumberController = TextEditingController();
    final nameController = TextEditingController();
    final upiIdController = TextEditingController();

    ValueNotifier<String> method = ValueNotifier<String>('Banking');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 24,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: ValueListenableBuilder<String>(
              valueListenable: method,
              builder: (context, selectedMethod, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Withdraw Details',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Radio Buttons
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Banking',
                          groupValue: selectedMethod,
                          onChanged: (value) => method.value = value!,
                        ),
                        const Text('Banking'),
                        Radio<String>(
                          value: 'UPI',
                          groupValue: selectedMethod,
                          onChanged: (value) => method.value = value!,
                        ),
                        const Text('UPI'),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Amount Field
                    TextFormField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Amount (₹)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final amount = double.tryParse(value ?? '');
                        if (amount == null ||
                            amount <= 0 ||
                            value!.trim().isEmpty) {
                          return 'Enter a valid amount';
                        }
                        if (amount > walletBalance) {
                          return 'Amount exceeds wallet balance ₹$walletBalance';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Common Field: Name
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Account Holder Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter account holder name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Banking-specific fields
                    if (selectedMethod == 'Banking') ...[
                      TextFormField(
                        controller: ifscController,
                        decoration: const InputDecoration(
                          labelText: 'IFSC Code',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 5) {
                            return 'Enter valid IFSC code';
                          }
                          final pattern = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
                          // if (!pattern.hasMatch(value.trim().toUpperCase())) {
                          //   return 'Enter a valid IFSC code';
                          // }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: accountNumberController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Account Number',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return 'Enter valid account number';
                          }
                          return null;
                        },
                      ),
                    ],

                    // UPI-specific fields
                    if (selectedMethod == 'UPI') ...[
                      TextFormField(
                        controller: upiIdController,
                        decoration: const InputDecoration(
                          labelText: 'UPI ID',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || !value.contains('@')) {
                            return 'Enter valid UPI ID';
                          }
                          return null;
                        },
                      ),
                    ],

                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              if (selectedMethod == 'Banking') {
                                await ref
                                    .read(walletDataProvider.notifier)
                                    .addWalletData(
                                        distributorId,
                                        amountController.text,
                                        nameController.text,
                                        ifscNumber: ifscController.text,
                                        accountNUmber:
                                            accountNumberController.text,
                                        upi: null,
                                        selectedMethod);
                              } else {
                                await ref
                                    .read(walletDataProvider.notifier)
                                    .addWalletData(
                                        distributorId,
                                        amountController.text,
                                        nameController.text,
                                        upi: upiIdController.text,
                                        ifscNumber: null,
                                        accountNUmber: null,
                                        selectedMethod);
                              }

                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        '✅ Withdrawal request submitted!')),
                              );
                            } catch (e) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          }
                        },
                        child: const Text('Submit Withdrawal'),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
