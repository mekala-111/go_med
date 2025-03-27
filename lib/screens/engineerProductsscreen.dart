import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sparepartProvider.dart';
import '../providers/serviceengineerprovider.dart';
import '../screens/serviceengineersparepartsscreen.dart';
import '../screens/BottomNavBar.dart';
import '../screens/serviceEnginnerAddressScreen.dart';
import '../screens/serviceEnginnersparepartbooking.dart';

class ServiceEngineerProductsPage extends ConsumerStatefulWidget {
  const ServiceEngineerProductsPage({super.key});

  @override
  ConsumerState<ServiceEngineerProductsPage> createState() =>
      _ServiceScreenState();
}

class _ServiceScreenState extends ConsumerState<ServiceEngineerProductsPage> {
   String? sparepartId;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(serciceEngineerProductProvider.notifier).fetchProducts();
      ref.read(sparepartProvider.notifier).getSpareParts(); // Fetch spare parts
    });
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(serciceEngineerProductProvider);
    final sparePartsState = ref.watch(sparepartProvider);
    final isLoading = productState.statusCode == 0;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    

    return Scaffold(
      appBar:AppBar(
  backgroundColor: const Color(0xFF6BC37A),
  elevation: 0,
  title: const Text(
    'Products',
    style: TextStyle(color: Colors.black),
  ),
  

  actions: [
    SizedBox(
      width: MediaQuery.of(context).size.width * 0.3,  height:MediaQuery.of(context).size.width * 0.1,// Using MediaQuery for screen width
      child: ElevatedButton(
        onPressed: () {
          setState(() {
           
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Serviceenginnersparepartbooking(),

            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 242, 231, 231),
          minimumSize: Size(MediaQuery.of(context).size.width * 0.05, MediaQuery.of(context).size.height * 0.03),
        ),
        child: Text(
          "Sparepart Booking",
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.018,
            color: const Color.fromARGB(255, 22, 20, 20),
          ),
        ),
      ),
    ),
  ],
),

      
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : productState.data == null || productState.data!.isEmpty
              ? const Center(child: Text("No products available."))
              : ListView.builder(
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  itemCount: productState.data!.length,
                  itemBuilder: (context, index) {
                    final product = productState.data![index];
                    final spareParts = sparePartsState.data
                            ?.where((sp) => sp.productId == product.productId)
                            .toList() ??
                        [];
                    return Card(
                      margin:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 2,
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.productName ?? "Unknown",
                              style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: product.productImages != null &&
                                      product.productImages!.isNotEmpty
                                  ? Image.network(
                                      product.productImages!.first,
                                      width: double.infinity,
                                      height: screenHeight * 0.18,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          height: screenHeight * 0.18,
                                          color: Colors.grey[300],
                                          child: const Center(
                                              child:
                                                  Icon(Icons.image, size: 40)),
                                        );
                                      },
                                    )
                                  : Container(
                                      height: screenHeight * 0.18,
                                      color: Colors.grey[300],
                                      child: const Center(
                                          child: Icon(Icons.image, size: 40)),
                                    ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              "₹${product.price?.toStringAsFixed(2) ?? "0.00"}",
                              style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              "Description: ${product.productDescription ?? "No description"}",
                              style: TextStyle(fontSize: screenWidth * 0.035),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              "Category: ${product.category ?? "No category"}",
                              style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blueGrey),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            spareParts.isEmpty
                                ? const Text(
                                    "No spare parts available.",
                                    style: TextStyle(color: Colors.red),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Spare Parts:",
                                        style: TextStyle(
                                            fontSize: screenWidth * 0.04,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: screenHeight * 0.005),
                                      SizedBox(
                                        height: screenHeight * 0.24,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: spareParts.length,
                                          itemBuilder: (context, index) {
                                            final sparePart = spareParts[index];
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        SparePartDetailScreen(
                                                            sparePart:
                                                                sparePart),
                                                  ),
                                                );
                                              },
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                elevation: 2,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal:
                                                        screenWidth * 0.02),
                                                child: Padding(
                                                  padding: EdgeInsets.all(
                                                      screenWidth * 0.02),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        child: sparePart.sparePartImages !=
                                                                    null &&
                                                                sparePart
                                                                    .sparePartImages!
                                                                    .isNotEmpty
                                                            ? Image.network(
                                                                sparePart
                                                                    .sparePartImages![0],
                                                                width:
                                                                    screenWidth *
                                                                        0.20,
                                                                height:
                                                                    screenWidth *
                                                                        0.10,
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : Container(
                                                                width:
                                                                    screenWidth *
                                                                        0.15,
                                                                height:
                                                                    screenWidth *
                                                                        0.15,
                                                                color: Colors
                                                                    .grey[300],
                                                                child: const Center(
                                                                    child: Icon(
                                                                        Icons
                                                                            .image,
                                                                        size:
                                                                            30)),
                                                              ),
                                                      ),
                                                      SizedBox(
                                                          height: screenHeight *
                                                              0.005),
                                                      SizedBox(
                                                        width:
                                                            screenWidth * 0.2,
                                                        child: Text(
                                                          sparePart
                                                                  .sparepartName ??
                                                              "Unknown",
                                                          style: TextStyle(
                                                              fontSize:
                                                                  screenWidth *
                                                                      0.03,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                                Text(
                                                      "₹${sparePart.price ?? "0.00"}",
                                                      style: TextStyle(
                                                          fontSize: screenWidth * 0.02,
                                                          color: Colors.green),
                                                    ),
                                                    SizedBox(height: screenHeight * 0.005),
                                                    SizedBox(
                                                      width: screenWidth * 0.2,
                                                      child: LayoutBuilder(
                                                              builder: (context, constraints) {
                                                                return SizedBox(
                                                                  width: constraints.maxWidth * 0.5, // Limits text width to half of available space
                                                                  child: Text(
                                                                    sparePart.description ?? "No description",
                                                                    style: TextStyle(fontSize: screenWidth * 0.025),
                                                                    maxLines: 2, // Display only 2 lines
                                                                    overflow: TextOverflow.ellipsis, // Hide extra text with "..."
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                    ),
                                                    SizedBox(
                                                      width: screenWidth * 0.2,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                       sparepartId = sparePart.sparepartId; // Store the selected spare part ID
                                                                      });
                                                            // Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddressScreen()));
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => const AddressScreen(),
                                                                  settings: RouteSettings(
                                                                    arguments: {'sparePartIds': sparePart.sparepartId}, // ✅ Pass argument
                                                                  ),
                                                                ),
                                                              );

                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: const Color.fromARGB(255, 150, 170, 238),
                                                          minimumSize: Size(screenWidth * 0.05, screenHeight * 0.03),
                                                        ),
                                                        child: Text("Buy Now", style: TextStyle(fontSize: screenWidth * 0.015,color: Colors.white)),
                                                      ),
                                                    ),

                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                            SizedBox(height: screenHeight * 0.005),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                 bottomNavigationBar:  BottomNavBar(),
    );
  }
}
