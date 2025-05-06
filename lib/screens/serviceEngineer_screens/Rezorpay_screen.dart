import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_med/providers/Distributor_provider/spareparetbookingprovider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayPaymentPage extends ConsumerStatefulWidget {
  
  final String address;
  final String location;
  final String sparepartIds;
  final String engineerId;
  final double? quantity;
  final String? parentId;
  final double? price;
  final String? distributorId;

  const RazorpayPaymentPage({
    Key? key,
   
    required this.address,
    required this.location,
    required this.sparepartIds,
    required this.engineerId,
    required this.quantity,
    this.parentId,
    this.price,
    this.distributorId
  }) : super(key: key);

  @override
  ConsumerState<RazorpayPaymentPage> createState() => _RazorpayPaymentPageState();
}

class _RazorpayPaymentPageState extends ConsumerState<RazorpayPaymentPage> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternal);
    _startPayment();
  }

  void _startPayment() {
    var options = {
      'key': 'rzp_live_6tvrYJlTwFFGiV', // your actual Razorpay key
      'amount': (widget.price),
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
      print('Error: $e');
      Navigator.pop(context);
    }
  }

  void _handleSuccess(PaymentSuccessResponse response) async {
  try {
    // Make your API call here using any HTTP client
    await ref.read(sparepartBookingProvider.notifier).addSparepartBooking(
          widget.address,
          widget.location,
          widget.sparepartIds,
          widget.engineerId,
          widget.quantity,
          widget.parentId,
          widget.distributorId
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Spare part booked successfully!')),
    );

    Navigator.pop(context); // Go back after success
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error sending data: $e')),
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
    Navigator.pop(context);
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
