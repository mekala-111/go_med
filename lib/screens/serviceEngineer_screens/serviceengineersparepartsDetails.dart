import 'package:flutter/material.dart';
import 'package:go_med/model/Serviceengineer_model/ServiceEngineerProductsModel.dart';
import 'package:go_med/screens/serviceEngineer_screens/serviceEnginnerAddressScreen.dart';

class SparePartDetailScreen extends StatefulWidget {
  final Data sparePart;
  final double finalPrice;
  final  int? originalPrice;

  const SparePartDetailScreen({
    super.key,
    required  this.originalPrice,
    required this.sparePart,
    required this.finalPrice,
  });

  @override
  State<SparePartDetailScreen> createState() => _SparePartDetailScreenState();
}

class _SparePartDetailScreenState extends State<SparePartDetailScreen> {
  final TextEditingController _quantityController = TextEditingController();
  double? _enteredQuantity;
  String? _errorText;
  double? _totalPrice;
  String? _selectedPaymentMethod;

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _calculateTotalPrice() {
    final parsedQuantity = double.tryParse(_quantityController.text.trim());
    final stock = (widget.sparePart.quantity is num)
        ? (widget.sparePart.quantity as num).toDouble()
        : double.tryParse(widget.sparePart.quantity.toString()) ?? 0;

    if (parsedQuantity == null || parsedQuantity <= 0) {
      setState(() {
        _errorText = "Enter a valid quantity";
        _enteredQuantity = null;
        _totalPrice = null;
      });
    } else if (parsedQuantity > stock) {
      setState(() {
        _errorText = "Please select based on available stock";
        _enteredQuantity = null;
        _totalPrice = null;
      });
    } else {
      final priceWithCharge = widget.finalPrice * 1.025; // Add 2.5%
      setState(() {
        _errorText = null;
        _enteredQuantity = parsedQuantity;
        _totalPrice = parsedQuantity * priceWithCharge;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final stock = widget.sparePart.quantity?.toString() ?? "0";
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Spare Part Details"),
        backgroundColor: const Color(0xFF6BC37A),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Center(
              child: (widget.sparePart.productImages?.isNotEmpty ?? false)
                  ? Image.network(
                      widget.sparePart.productImages!.first,
                      width: screenWidth * 0.95,
                      height: screenHeight * 0.35,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: screenWidth * 0.6,
                      height: screenHeight * 0.3,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 50),
                    ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Product Name & Price
            Text(
              widget.sparePart.productName ?? "Unknown Product",
              style: TextStyle(
                fontSize: screenWidth * 0.08,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              "Price: ₹${widget.finalPrice.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Description
            Text("Description:",
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.bold,
                )),
            Text(
              widget.sparePart.productDescription ?? "No description available",
              style: TextStyle(fontSize: screenWidth * 0.035),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Stock
            Text(
              "Available Stock: $stock",
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.015),

            // Quantity Input
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter Quantity",
                border: const OutlineInputBorder(),
                errorText: _errorText,
              ),
              onChanged: (_) => _calculateTotalPrice(),
            ),
            SizedBox(height: screenHeight * 0.015),

            // Total Price
            if (_totalPrice != null)
              Text(
                "Total Price (incl. 2.5%): ₹${_totalPrice!.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),

            SizedBox(height: screenHeight * 0.03),

            // Payment Method
            Text(
              "Select Payment Method:",
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
            RadioListTile<String>(
              title: const Text("Net Banking"),
              value: "Net Banking",
              groupValue: _selectedPaymentMethod,
              onChanged: (value) => setState(() => _selectedPaymentMethod = value),
            ),
            RadioListTile<String>(
              title: const Text("COD"),
              value: "COD",
              groupValue: _selectedPaymentMethod,
              onChanged: (value) => setState(() => _selectedPaymentMethod = value),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Buy Now Button
            Center(
              child: ElevatedButton(
                onPressed: (_enteredQuantity != null && _selectedPaymentMethod != null)
                    ? () {
                        double finalUnitPrice;

                        if (_selectedPaymentMethod == "COD") {
                          // final price = widget.sparePart.price ?? 0;
                          // final discounted = price * 0.90; // 10% off
                          // finalUnitPrice = discounted * 1.025; // +2.5% tax
                          final price = widget.sparePart.price ?? 0;
                          final discounted = price * 0.90; // 10% discount
                          final tax = _totalPrice! * 0.025; // 2.5% of _totalPrice
                          finalUnitPrice = discounted + tax;

                        } else {
                          finalUnitPrice = widget.finalPrice;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddressScreen(),
                            settings: RouteSettings(arguments: {
                              'sparePartId': widget.sparePart.productId,
                              'enteredQuantity': _enteredQuantity,
                              'parentId': widget.sparePart.parentId,
                              'totalPrice': _totalPrice,
                              'finalPrice': widget.finalPrice,
                              'finalUnitPrice': finalUnitPrice,
                              'originalPrice': widget.originalPrice
                              ,
                              'distributorId': widget.sparePart.distributorId,
                              'paymentMethod': _selectedPaymentMethod,
                            }),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF96AAEE),
                  minimumSize: Size(screenWidth * 0.4, screenHeight * 0.06),
                ),
                child: Text(
                  "Buy Now",
                  style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
