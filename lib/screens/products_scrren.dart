import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_med/providers/Distributor_products_provider.dart';

import '../model/Distributor_products_model.dart'; // Import your model here
import '../screens/Distributor_sparepartbookings.dart';
import '../screens/BottomNavBar.dart';

class ProductScreen extends ConsumerStatefulWidget {
  const ProductScreen({super.key});

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.watch(distributorProductProvider.notifier).getDistributorProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(distributorProductProvider);
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DistributorSparepartbookings(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0x801BA4CA),
                minimumSize: Size(MediaQuery.of(context).size.width * 0.05,
                    MediaQuery.of(context).size.height * 0.03),
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
          const SizedBox(width: 15)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderActions(context),
            const SizedBox(height: 16),
            Expanded(
              child: productState.data == null || productState.data!.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _buildProductList(productState.data!),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildHeaderActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [],
    );
  }

  Widget _buildProductList(List<Data> productState) {
    if (productState.isEmpty) {
      return const Center(
        child: Text(
          'No products available',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }

    return ListView.builder(
      itemCount: productState.length,
      itemBuilder: (context, index) {
        final product = productState[index];
        return _buildProductCard(context, product);
      },
    );
  }

  Widget _buildProductCard(BuildContext context, Data product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x401BA4CA),
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
          // Display the product image
          if (product.productImages != null &&
              product.productImages!.isNotEmpty)
            Image.network(
              product.productImages![0], // Assuming we show the first image
              height: 200,
              width: 300,
              fit: BoxFit.cover,
            ),
          SizedBox(height: 5),

          Text(
            product.productName ?? '',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 5),
          Text(
            '₹${product.price ?? 0}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          // const SizedBox(height: 8),
          Text('Category: ${product.category ?? 'Unknown'}',
              style: const TextStyle(fontSize: 14)),
          Text('Description: ${product.productDescription ?? ''}',
              style: const TextStyle(fontSize: 14)),
          Text(
            'Status: ${product.activated == true ? "Active" : "Inactive"}',
            style: TextStyle(
              color: product.activated == true ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButtonCard(context, 'View Spare Parts', Colors.green,
                  () {
                _showSparePartsDialog(
                    context, product.productId, product.spareParts);
              }),
              _buildActionButtonCard(context, 'Request', Colors.red, () {
                _showRequestDialog(context, product, product.spareParts ?? []);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtonCard(
      BuildContext context, String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }

  void _showSparePartsDialog(
      BuildContext context, String? productId, List<SpareParts>? spareParts) {
    final productSpareParts = spareParts ?? [];

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
                productSpareParts.isEmpty
                    ? const Center(child: Text("No Spare Parts Available"))
                    : ListView(
                        shrinkWrap: true,
                        children: productSpareParts
                            .map((part) => _buildSparePartItem(context, part))
                            .toList(),
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

  Widget _buildSparePartItem(BuildContext context, SpareParts sparePart) {
    String truncateText(String text, {int maxLength = 20}) {
      return (text.length > maxLength)
          ? '${text.substring(0, maxLength)}...'
          : text;
    }

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
          Text(
            truncateText(sparePart.sparepartName ?? 'Unknown', maxLength: 25),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '₹${sparePart.sparepartPrice ?? 'N/A'}',
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          const SizedBox(height: 8),
          Text(
            truncateText(sparePart.description ?? '', maxLength: 50),
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showRequestDialog(
      BuildContext context, Data product, List<SpareParts> sparePartsState) {
    int productQuantity = 0;
    final productQuantityController =
        TextEditingController(text: productQuantity.toString());
    final productPriceController = TextEditingController();

    // Filter spare parts related to this product
    final spareParts =
        sparePartsState.where((sp) => sp.sId == product.productId).toList();

    List<int> sparePartQuantities = List.filled(spareParts.length, 1);
    List<TextEditingController> sparePartQuantityControllers = List.generate(
      spareParts.length,
      (index) =>
          TextEditingController(text: sparePartQuantities[index].toString()),
    );
    List<TextEditingController> sparePartPriceControllers =
        List.generate(spareParts.length, (index) => TextEditingController());
    List<bool> selectedSpareParts = List.filled(spareParts.length, false);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(product.productName ?? 'Unknown Product'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Product Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: productPriceController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  label: Text("Price"),
                                  hintText: "Enter Price",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    if (productQuantity > 1) {
                                      setState(() {
                                        productQuantity--;
                                        productQuantityController.text =
                                            productQuantity.toString();
                                      });
                                    }
                                  },
                                ),
                                SizedBox(
                                  width: 50,
                                  child: TextField(
                                    controller: productQuantityController,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration:
                                        const InputDecoration(labelText: "Qty"),
                                    onChanged: (value) {
                                      setState(() {
                                        productQuantity =
                                            int.tryParse(value) ?? 1;
                                      });
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      productQuantity++;
                                      productQuantityController.text =
                                          productQuantity.toString();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Spare Parts Section
                    const Text(
                      'Spare Parts:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.indigo),
                    ),
                    spareParts.isEmpty
                        ? const Text('No spare parts available')
                        : Column(
                            children: List.generate(spareParts.length, (index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: selectedSpareParts[index],
                                        onChanged: (value) {
                                          setState(() {
                                            selectedSpareParts[index] =
                                                value ?? false;
                                          });
                                        },
                                      ),
                                      Expanded(
                                        child: Text(
                                          spareParts[index].sparepartName ??
                                              'Unknown Part',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller:
                                              sparePartPriceControllers[index],
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            labelText: "Price",
                                            hintText: "Enter Price",
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove),
                                            onPressed: () {
                                              if (sparePartQuantities[index] >
                                                  1) {
                                                setState(() {
                                                  sparePartQuantities[index]--;
                                                  sparePartQuantityControllers[
                                                              index]
                                                          .text =
                                                      sparePartQuantities[index]
                                                          .toString();
                                                });
                                              }
                                            },
                                          ),
                                          SizedBox(
                                            width: 50,
                                            child: TextField(
                                              controller:
                                                  sparePartQuantityControllers[
                                                      index],
                                              keyboardType:
                                                  TextInputType.number,
                                              textAlign: TextAlign.center,
                                              decoration: const InputDecoration(
                                                  labelText: "Qty"),
                                              onChanged: (value) {
                                                setState(() {
                                                  sparePartQuantities[index] =
                                                      int.tryParse(value) ?? 1;
                                                });
                                              },
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.add),
                                            onPressed: () {
                                              setState(() {
                                                sparePartQuantities[index]++;
                                                sparePartQuantityControllers[
                                                            index]
                                                        .text =
                                                    sparePartQuantities[index]
                                                        .toString();
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              );
                            }),
                          ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Send Request',
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0x801BA4CA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
