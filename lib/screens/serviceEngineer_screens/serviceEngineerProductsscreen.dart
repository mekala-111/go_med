import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/Serviceenginner_ptovider/serviceEnginnerProductsprovider.dart';
import 'serviceEnginnersparepartbooking.dart';
import 'serviceEnginnerAddressScreen.dart';
import '../BottomNavBar.dart';
import 'serviceengineersparepartsDetails.dart';

class ServiceEngineerProductsPage extends ConsumerStatefulWidget {
  const ServiceEngineerProductsPage({super.key});

  @override
  ConsumerState<ServiceEngineerProductsPage> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends ConsumerState<ServiceEngineerProductsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(serviceEngineerProductsProvider.notifier).getServiceEnginnerProducts();
      print("Fetching service engineer products...");
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Building ServiceEngineerProductsPage...");

    final productState = ref.watch(serviceEngineerProductsProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final isLoading = productState.statusCode == 0;
    final hasError = productState.statusCode == -1;

    final allItems = productState.data ?? [];
    final mainProducts = allItems.where((item) => item.parentId == null).toList();
    final spareParts = allItems.where((item) => item.parentId != null).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6BC37A),
        elevation: 0,
        title: const Text('Products', style: TextStyle(color: Colors.black)),
        actions: [
          SizedBox(
            width: screenWidth * 0.3,
            height: screenWidth * 0.1,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Serviceenginnersparepartbooking()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:  const Color.fromARGB(255, 211, 218, 241)
              ),
              child: Text(
                "Sparepart Booking",
                style: TextStyle(
                  fontSize: screenWidth * 0.019,
                  color: const Color.fromARGB(255, 22, 20, 20),
                ),
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? const Center(child: Text("Something went wrong."))
              : mainProducts.isEmpty
                  ? const Center(child: Text("No products available."))
                  : ListView.builder(
                      padding: EdgeInsets.all(screenWidth * 0.03),
                      itemCount: mainProducts.length,
                      itemBuilder: (context, index) {
                        final product = mainProducts[index];
                        final relatedSpareParts = spareParts
                            .where((sp) => sp.parentId == product.productId)
                            .toList();

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 2,
                          color: const Color.fromARGB(255, 204, 213, 230),
                          child: Padding(
                            padding: EdgeInsets.all(screenWidth * 0.03),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.productName ?? "Unknown",
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.045,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.005),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: product.productImages != null && product.productImages!.isNotEmpty
                                      ? Image.network(
                                          product.productImages!.first,
                                          width: double.infinity,
                                          height: screenHeight * 0.18,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          height: screenHeight * 0.18,
                                          color: Colors.grey[300],
                                          child: const Center(child: Icon(Icons.image, size: 40)),
                                        ),
                                ),
                                SizedBox(height: screenHeight * 0.005),
                                Text(
                                  "₹${product.price?.toStringAsFixed(2) ?? "0.00"}",
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.005),
                                Text(
                                  "Description: ${product.productDescription ?? "No description"}",
                                  style: TextStyle(fontSize: screenWidth * 0.035),
                                ),
                                SizedBox(height: screenHeight * 0.005),
                                Text(
                                  "Category: ${product.categoryName ?? "No category"}",
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                relatedSpareParts.isEmpty
                                    ? const Text("No spare parts available.", style: TextStyle(color: Colors.red))
                                    : Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Spare Parts:",
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.04,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: screenHeight * 0.005),
                                          SizedBox(
                                            height: screenHeight * 0.24,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: relatedSpareParts.length,
                                              itemBuilder: (context, spIndex) {
                                                final sparePart = relatedSpareParts[spIndex];
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
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    elevation: 2,
                                                    margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(screenWidth * 0.02),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius: BorderRadius.circular(6),
                                                            child: sparePart.productImages != null &&
                                                                    sparePart.productImages!.isNotEmpty
                                                                ? Image.network(
                                                                    sparePart.productImages!.first,
                                                                    width: screenWidth * 0.2,
                                                                    height: screenWidth * 0.1,
                                                                    fit: BoxFit.cover,
                                                                  )
                                                                : Container(
                                                                    width: screenWidth * 0.15,
                                                                    height: screenWidth * 0.15,
                                                                    color: Colors.grey[300],
                                                                    child: const Center(
                                                                      child: Icon(Icons.image, size: 30),
                                                                    ),
                                                                  ),
                                                          ),
                                                          SizedBox(height: screenHeight * 0.005),
                                                          SizedBox(
                                                            width: screenWidth * 0.2,
                                                            child: Text(
                                                              sparePart.productName ?? "Unknown",
                                                              style: TextStyle(
                                                                fontSize: screenWidth * 0.03,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                          Text(
                                                            "₹${sparePart.price?.toStringAsFixed(2) ?? "0.00"}",
                                                            style: TextStyle(
                                                              fontSize: screenWidth * 0.025,
                                                              color: Colors.green,
                                                            ),
                                                          ),
                                                          SizedBox(height: screenHeight * 0.005),
                                                          SizedBox(
                                                            width: screenWidth * 0.2,
                                                            child: Text(
                                                              sparePart.productDescription ?? "No description",
                                                              style: TextStyle(fontSize: screenWidth * 0.025),
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: screenWidth * 0.2,
                                                            child: ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) =>  SparePartDetailScreen(sparePart:
                                                                sparePart),
                                                                    // settings: RouteSettings(arguments: {
                                                                    //   'sparePartIds': sparePart.productId,
                                                                    //   'quantity':sparePart.quantity
                                                                    // }),
                                                                  ),
                                                                );
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor:
                                                                    const Color.fromARGB(255, 150, 170, 238),
                                                              ),
                                                              child: Text(
                                                                "Next",
                                                                style: TextStyle(
                                                                
                                                                  fontSize: screenWidth * 0.03,
                                                                  color: const Color.fromARGB(255, 17, 16, 16),
                                                                ),
                                                              ),
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
                                SizedBox(height: screenHeight * 0.01),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
