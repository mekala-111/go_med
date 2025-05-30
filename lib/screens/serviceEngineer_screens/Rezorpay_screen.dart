import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_med/providers/Distributor_provider/spareparetbookingprovider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../screens/serviceEngineer_screens/serviceEngineerProductsscreen.dart';

class RazorpayPaymentPage extends ConsumerStatefulWidget {
  final String address;
  final String location;
  final String sparepartIds;
  final String engineerId;
  final double? quantity;
  final String? parentId;
  final String distributorId;
  final int? originalPrice;
  final double? totalPrice;
  final double? finalPrice;
  final double? finalUnitPrice;
  final String? paymentMethod;

  const RazorpayPaymentPage({
    Key? key,
    required this.address,
    required this.location,
    required this.sparepartIds,
    required this.engineerId,
    required this.quantity,
    this.parentId,
    this.originalPrice,
    this.totalPrice,
    this.finalPrice,
    this.finalUnitPrice,
    this.paymentMethod,
    required this.distributorId,
  }) : super(key: key);

  @override
  ConsumerState<RazorpayPaymentPage> createState() =>
      _RazorpayPaymentPageState();
}

class _RazorpayPaymentPageState extends ConsumerState<RazorpayPaymentPage> {
  late Razorpay _razorpay;
  bool _paymentStarted = false;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay()
      ..on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess)
      ..on(Razorpay.EVENT_PAYMENT_ERROR, _handleError)
      ..on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternal);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_paymentStarted) {
        _startPayment();
        _paymentStarted = true;
      }
    });
  }

  void _startPayment() {
    final isCOD = widget.paymentMethod == 'cod';
    final amount = isCOD ? widget.finalUnitPrice ?? 0 : widget.totalPrice ?? 0;
    final amountInPaise = (amount * 100).toInt();

    if (amountInPaise <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid payment amount")),
      );
      Navigator.pop(context);
      return;
    }

    var options = {
      'key': 'rzp_live_6tvrYJlTwFFGiV',
      'amount': amountInPaise,
      'name': 'Gomed',
      'description': 'Product Booking',
      'prefill': {
        'contact': '9391696616',
        'email': 'ravya@gmail.com',
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment error: $e')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _handleSuccess(PaymentSuccessResponse response) async {
    try {
      final isCod = widget.paymentMethod == 'cod';

      await ref.read(sparepartBookingProvider.notifier).addSparepartBooking(
            widget.address,
            widget.location,
            widget.sparepartIds,
            widget.engineerId,
            widget.quantity,
            widget.parentId,
            widget.distributorId,
            widget.originalPrice ,
            widget.finalPrice,
            widget.totalPrice,
            isCod ? widget.finalUnitPrice : null,
            widget.paymentMethod,
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Spare part booked successfully!')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ServiceEngineerProductsPage()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Failed to book: $e')),
      );
      Navigator.pop(context);
    }
  }

  void _handleError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('❌ Payment failed')),
    );
    Navigator.pop(context);
  }

  void _handleExternal(ExternalWalletResponse response) {
    debugPrint("External wallet selected: ${response.walletName}");
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
