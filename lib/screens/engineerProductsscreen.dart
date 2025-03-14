import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_med/providers/serviceengineerprovider.dart';
import 'package:go_med/screens/BottomNavBar.dart';

class ServiceEngineerProductsPage extends ConsumerStatefulWidget {
  const ServiceEngineerProductsPage({super.key});

  @override
  ConsumerState<ServiceEngineerProductsPage> createState() => ServiceScreenState();
}

class ServiceScreenState extends ConsumerState<ServiceEngineerProductsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.watch(serciceEngineerProductProvider.notifier).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(serciceEngineerProductProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6BC37A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Products',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: productState.data != null
          ? const Center(child: CircularProgressIndicator()) // Show loading state
          : productState.messages != null
              ? Center(child: Text("Error: ${productState.data}")) // Show error
              : productState.data == null || productState.data!.isEmpty
                  ? const Center(child: Text("No products available."))
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: productState.data!.length,
                      itemBuilder: (context, index) {
                        final product = productState.data![index]; // Fetch data from state

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product Name
                                Text(
                                  product.productName ?? "Unknown",
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),

                                // Product Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    product.productImage ?? "", // Handle null image
                                    width: double.infinity,
                                    height: 150,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 150,
                                        color: Colors.grey[300],
                                        child: const Center(child: Icon(Icons.image, size: 50)),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Description & Price
                                Text(
                                  "Description: ${product.productDescription ?? "No description"}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  "Price: ₹${product.price?.toStringAsFixed(2) ?? "0.00"}",
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                                ),

                                const SizedBox(height: 10),

                                // Spare Parts Section
                                product.spareParts == true
                                    ? Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Spare Parts Available",
                                            style: TextStyle(
                                                fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 5),
                                          ElevatedButton(
                                            onPressed: () {
                                              // Handle Spare Parts Action
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: const Text("View Spare Parts"),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
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
