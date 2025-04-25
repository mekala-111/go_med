import 'package:flutter/material.dart';
import 'package:go_med/model/ServiceEngineerProductsModel.dart';
import 'package:go_med/screens/serviceEnginnerAddressScreen.dart';

class SparePartDetailScreen extends StatefulWidget {
  final Data sparePart;

  const SparePartDetailScreen({super.key, required this.sparePart});

  @override
  _SparePartDetailScreenState createState() => _SparePartDetailScreenState();
}

class _SparePartDetailScreenState extends State<SparePartDetailScreen> {
  final TextEditingController _quantityController = TextEditingController();
  double? _enteredQuantity;
  String? _errorText;

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // final availableStock = double.tryParse(widget.sparePart.quantity as String );
    // final enteredQuantity = (args['enteredQuantity'] as num?)?.toInt();
    final availableStock = (widget.sparePart.quantity is num)
    ? (widget.sparePart.quantity as num).toDouble()
    : double.tryParse(widget.sparePart.quantity.toString());


    return Scaffold(
      appBar: AppBar(
        title: const Text("Spare Part Details"),
        backgroundColor: const Color(0xFF6BC37A),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Center(
                child: widget.sparePart.productImages != null &&
                        widget.sparePart.productImages!.isNotEmpty
                    ? Image.network(
                        widget.sparePart.productImages![0],
                        width: screenWidth * 0.95,
                        height: screenHeight * 0.35,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: screenWidth * 0.6,
                        height: screenHeight * 0.3,
                        color: Colors.grey[300],
                        child: const Center(child: Icon(Icons.image, size: 50)),
                      ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Name & Price
              Text(
                widget.sparePart.productName ?? "Unknown",
                style: TextStyle(fontSize: screenWidth * 0.08, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                "Price: ₹${widget.sparePart.price ?? "0.00"}",
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.015),

              // Description
              Text("Description:", style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold)),
              Text(
                widget.sparePart.productDescription ?? "No description available",
                style: TextStyle(fontSize: screenWidth * 0.035),
              ),
              SizedBox(height: screenHeight * 0.015),

              // Available Stock
              Text(
                "Available Stock: ${widget.sparePart.quantity ?? "0"}",
                style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.015),

              // Quantity input
              TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter Quantity",
                  border: OutlineInputBorder(),
                  errorText: _errorText,
                ),
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  setState(() {
                    if (parsed == null || parsed <= 0) {
                      _errorText = "Enter a valid quantity";
                      _enteredQuantity = null;
                    } else if (parsed > availableStock!) {
                      _errorText = "Please select based on available stock";
                      _enteredQuantity = null;
                    } else {
                      _errorText = null;
                      _enteredQuantity = parsed;
                    }
                  });
                },
              ),
              SizedBox(height: screenHeight * 0.03),

              // Buy Now button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_enteredQuantity != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddressScreen(),
                          settings: RouteSettings(
                            arguments: {
                              'sparePartId': widget.sparePart.productId,
                              'enteredQuantity': _enteredQuantity,
                              'parentId':widget.sparePart.parentId,
                            },
                          ),
                        ),
                      );
                    } else {
                      setState(() {
                        _errorText = "Please enter a valid quantity";
                      });
                    }
                  },
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
      ),
    );
  }
}
