import 'package:flutter/material.dart';
import 'package:go_med/screens/engineerProductsscreen.dart';
import '../model/sparepartState.dart';
import '../screens/serviceEnginnerAddressScreen.dart';

class SparePartDetailScreen extends StatefulWidget {
  final Data sparePart;

  const SparePartDetailScreen({super.key, required this.sparePart});

  @override
  _SparePartDetailScreenState createState() => _SparePartDetailScreenState();
}

class _SparePartDetailScreenState extends State<SparePartDetailScreen> {
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title:const Text("Spare Part Details"),
        backgroundColor: const Color(0xFF6BC37A),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: widget.sparePart.sparePartImages != null && widget.sparePart.sparePartImages!.isNotEmpty
                    ? Image.network(
                        widget.sparePart.sparePartImages![0],
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
              Text(
                widget.sparePart.sparepartName ?? "Unknown",
                style: TextStyle(fontSize: screenWidth * 0.09, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                "Price: ₹${widget.sparePart.price ?? "0.00"}",
                style: TextStyle(fontSize: screenWidth * 0.045, color: Colors.green, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                "Description:",
                style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.sparePart.description ?? "No description available",
                style: TextStyle(fontSize: screenWidth * 0.035),
              ),
              SizedBox(height: screenHeight * 0.02),
        
              // Star Rating
              Text(
                "Rate this spare part:",
                style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold),
              ),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1.0;
                      });
                    },
                  );
                }),
              ),
        
              SizedBox(height: screenHeight * 0.02),
        
              // Buy Now Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 150, 170, 238),
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
