import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/Distributor_products_model.dart';
import '../providers/Distributor_products_provider.dart';
import '../screens/BottomNavBar.dart';
import '../screens/Select_productsscreen.dart';
import '../screens/request_accepted_list_.dart';

class ProductScreen extends ConsumerStatefulWidget {
  const ProductScreen({super.key});

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  final List<Data> selectedProducts = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(distributorProductProvider.notifier).getDistributorProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(distributorProductProvider);
    final products = productState.data ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFE8F7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6BC37A),
        elevation: 0,
        title: const Text(
          'Products',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.width * 0.1,
            child: ElevatedButton(
              onPressed: () {
                // Implement your booking functionality here
                 Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>RequestAcceptProductScreen() 
                      ),
                    );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0x801BA4CA),
                minimumSize: Size(
                  MediaQuery.of(context).size.width * 0.05,
                  MediaQuery.of(context).size.height * 0.03,
                ),
              ),
              child: Text(
                "Bookings",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  color: const Color.fromARGB(255, 22, 20, 20),
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: products.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return _buildProductCard(context, product);
                    },
                  ),
          ),
          _buildBottomButtons(),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildProductCard(BuildContext context, Data product) {
    bool isSelected = selectedProducts.contains(product);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  selectedProducts.add(product);
                } else {
                  selectedProducts.remove(product);
                }
              });
            },
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x401BA4CA),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  if (product.productImages != null &&
                      product.productImages!.isNotEmpty)
                    Image.network(
                      product.productImages![0],
                      height: 150,
                      width: 280,
                      fit: BoxFit.cover,
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.productName ?? 'Unknown Product',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Category: ${product.categoryName ?? 'Unknown'}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Description: ${product.productDescription ?? ''}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 5),
                        ElevatedButton(
                          onPressed: () =>
                              _showLinkedSparePartsDialog(context, product),
                          child: const Text("View Linked Spare Parts"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLinkedSparePartsDialog(BuildContext context, Data product) {
    final linkedSpareParts = product.linkedSpareParts ?? [];

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Spare Parts',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                linkedSpareParts.isEmpty
                    ? const Center(child: Text("No spare parts available"))
                    : SizedBox(
                        height: 250,
                        child: ListView.builder(
                          itemCount: linkedSpareParts.length,
                          itemBuilder: (context, index) {
                            final sparePart = linkedSpareParts[index];
                            return _buildLinkedSparePartItem(
                                context, sparePart);
                          },
                        ),
                      ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLinkedSparePartItem(BuildContext context, LinkedSpareParts sparePart) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(175, 193, 199, 201),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (sparePart.productImages != null &&
              sparePart.productImages!.isNotEmpty)
            Image.network(
              sparePart.productImages![0],
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          const SizedBox(height: 5),
          Text(
            sparePart.productName ?? 'Unknown Spare Part',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            sparePart.productDescription ?? 'No Description Available',
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: selectedProducts.isEmpty
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectedProductsScreen(
                          selectedProducts: selectedProducts,
                        ),
                      ),
                    );
                  },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child:
                const Text("Continue", style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement email functionality if required
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text("Email", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
