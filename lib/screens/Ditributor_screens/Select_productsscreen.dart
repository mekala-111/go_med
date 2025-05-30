import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_med/providers/Distributor_provider/Quantity_parts_provider.dart';
import '../../model/DIstributor_models/Distributor_products_model.dart';
import '../../providers/Distributor_provider/Distributor_products_provider.dart';
import 'products_scrren.dart';

class SelectedProductsScreen extends ConsumerStatefulWidget {
  final List<Data> selectedProducts;

  const SelectedProductsScreen({super.key, required this.selectedProducts});

  @override
  ConsumerState<SelectedProductsScreen> createState() =>
      _SelectedProductsScreenState();
}

class _SelectedProductsScreenState
    extends ConsumerState<SelectedProductsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(distributorProductProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFE8F7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6BC37A),
        title: const Text('Product Bookings', style: TextStyle(color: Colors.black)),
      ),
      body: Form(
        key: _formKey,
        child: productState.data == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: widget.selectedProducts.map((product) {
                    // Filter the linked spare parts for the specific product
                    List<LinkedSpareParts> linkedSpareParts =
                        product.linkedSpareParts ?? [];
                    return _buildProductCard(product, linkedSpareParts);
                  }).toList(),
                ),
              ),
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildProductCard(Data product, List<LinkedSpareParts> linkedSpareParts) {
    bool isSelected = true;
    final qtyController = TextEditingController(text: "0");
    final priceController =
        TextEditingController(text: product.price?.toString() ?? "0");

    List<bool> selectedChildren = List.filled(linkedSpareParts.length, false);
    List<TextEditingController> qtyControllers = List.generate(
      linkedSpareParts.length,
      (_) => TextEditingController(text: "0"),
    );
    List<TextEditingController> priceControllers = List.generate(
      linkedSpareParts.length,
      (index) =>
          TextEditingController(text: linkedSpareParts[index].price.toString()),
    );

    void updateOrAdd(Map<String, dynamic> item) {
      final id = item["productId"];
      final index = selectedItems.indexWhere((e) => e["productId"] == id);
      if (index != -1) {
        selectedItems[index] = item;
      } else {
        selectedItems.add(item);
      }
    }

    updateOrAdd({
      "productId": product.productId,
      "productName": product.productName,
      "price": priceController.text,
      "quantity": qtyController.text,
      "parentId": null,
    });

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: isSelected,
                    onChanged: (value) {
                      setState(() => isSelected = value!);
                      if (!value!) {
                        selectedItems.removeWhere(
                            (e) => e["productId"] == product.productId);
                      } else {
                        updateOrAdd({
                          "productId": product.productId,
                          "productName": product.productName,
                          "price": priceController.text,
                          "quantity": qtyController.text,
                          "parentId": null,
                        });
                      }
                    },
                  ),
                  Expanded(
                    child: Text(
                      product.productName ?? 'Unknown Product',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: "Price", border: OutlineInputBorder()),
                      onChanged: (val) => updateOrAdd({
                        "productId": product.productId,
                        "productName": product.productName,
                        "price": val,
                        "quantity": qtyController.text,
                        "parentId": null,
                      }),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          final current = int.tryParse(qtyController.text) ?? 1;
                          if (current > 1) {
                            qtyController.text = (current - 1).toString();
                            updateOrAdd({
                              "productId": product.productId,
                              "productName": product.productName,
                              "price": priceController.text,
                              "quantity": qtyController.text,
                              "parentId": null,
                              
                            });
                          }
                        },
                      ),
                      SizedBox(
                        width: 70,
                        child: TextFormField(
                          controller: qtyController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: "Qty", border: OutlineInputBorder()),
                          onChanged: (val) => updateOrAdd({
                            "productId": product.productId,
                            "productName": product.productName,
                            "price": priceController.text,
                            "quantity": val,
                            "parentId": null, 
                          }),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          final current = int.tryParse(qtyController.text) ?? 1;
                          qtyController.text = (current + 1).toString();
                          updateOrAdd({
                            "productId": product.productId,
                            "productName": product.productName,
                            "price": priceController.text,
                            "quantity": qtyController.text,
                            "parentId": null,
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (linkedSpareParts.isNotEmpty) ...[
                const Text("Linked Spare Parts",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ...List.generate(linkedSpareParts.length, (index) {
                  final linkedSparePart = linkedSpareParts[index];
                  // Convert LinkedSpareParts to Data object
                  final data = Data(
                    productId: linkedSparePart.productId,
                    productName: linkedSparePart.productName,
                    price: linkedSparePart.price,
                    productImages: linkedSparePart.productImages,

                    linkedSpareParts: [],
                  );

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Checkbox(
                            value: selectedChildren[index],
                            onChanged: (value) {
                              setState(() => selectedChildren[index] = value!);
                              final map = {
                                "productId": data.productId,
                                "productName": data.productName,
                                "price": priceControllers[index].text,
                                "quantity": qtyControllers[index].text,
                                "parentId":linkedSparePart.parentId
                              };
                              if (value!) {
                                updateOrAdd(map);
                              } else {
                                selectedItems.removeWhere(
                                    (e) => e["productId"] == data.productId);
                              }
                            },
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data.productName ?? 'Unknown',
                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 90,
                                      child: TextFormField(
                                        controller: priceControllers[index],
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                            labelText: "Price",
                                            border: OutlineInputBorder()),
                                        onChanged: (val) {
                                          final idx = selectedItems.indexWhere(
                                              (e) => e["productId"] == data.productId);
                                          if (idx != -1) {
                                            selectedItems[idx]["price"] = val;
                                          }
                                        },
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () {
                                        final current =
                                            int.tryParse(qtyControllers[index].text) ?? 1;
                                        if (current > 1) {
                                          qtyControllers[index].text =
                                              (current - 1).toString();
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      width: 60,
                                      child: TextFormField(
                                        controller: qtyControllers[index],
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                            labelText: "Qty", border: OutlineInputBorder()),
                                        onChanged: (val) {
                                          final idx = selectedItems.indexWhere(
                                              (e) => e["productId"] == data.productId);
                                          if (idx != -1) {
                                            selectedItems[idx]["quantity"] = val;
                                          }
                                        },
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        final current =
                                            int.tryParse(qtyControllers[index].text) ?? 1;
                                        qtyControllers[index].text =
                                            (current + 1).toString();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                })
              ]
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            print("Selected Items: $selectedItems");
            try {
              await ref.read(quantityPartsProvider.notifier).addQuatity(selectedItems);

               ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                                    content: Text(
                                                                        "Products and Spareparts Requested To Admin",style: TextStyle(color: Colors.blue),)
                                                                        ));
              // Navigate to next screen after successful booking
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductScreen()), // Replace with your actual screen
        );
            } catch (e) {
              print("Error booking items: $e");
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('Request to Book', style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}
