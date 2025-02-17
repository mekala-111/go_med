import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../providers/products.dart';
import '../providers/serviceProvider.dart';

class ServicesPageEdit extends ConsumerStatefulWidget {
  const ServicesPageEdit({super.key});

  @override
  _ServicesPageEditState createState() => _ServicesPageEditState();
}

class _ServicesPageEditState extends ConsumerState<ServicesPageEdit> {
  final TextEditingController serviceController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  List<String> selectedProducts = []; // Stores selected product names
  Map<String, String> productMap = {};
  // Stores {productName: productId}
  List filteredProductsList = [];
  String? type;
  List<String>? productId;
  String? serviceId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final serviceState = ref.watch(serviceProvider).data ?? [];
    filteredProductsList = serviceState;

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      setState(() {
        serviceController.text = args['name'] ?? '';
        priceController.text = args['price'] ?? '';
        descriptionController.text = args['details'] ?? '';
        productId = args['productIds'] ?? '';
        type = args['type'] ?? '';
        serviceId = args['serviceId'] ?? '';
      });
    }
    print('description---------------------$descriptionController');
    print('  productId--------------------$productId');
    print('serviceId--------------------$serviceId');
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productProvider).data ?? [];

    // Map product names to product IDs
    productMap = {
      for (var p in products) p.productName ?? "Unknown": p.productId ?? ""
    };

    List<String> productNames =
        productMap.keys.toList(); // Show only names in dropdown

    return Scaffold(
      backgroundColor: const Color(0xFFE8F7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6BC37A),
        title: const Text("Services"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: const [
          Icon(Icons.notifications),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type == 'edit' ? 'Edit service' : 'Add service',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                buildLabel("Select Products"),

                // Multi-Select Dropdown (Displays and Stores Only Names)
                MultiSelectDialogField(
                  items: productNames
                      .map((name) => MultiSelectItem<String>(name, name))
                      .toList(),
                  title: const Text("Select Products"),
                  buttonText: const Text(
                      // selectedProducts.isEmpty
                      // ?
                      "Choose Products"

                      // : selectedProducts.join(", "),
                      // overflow: TextOverflow.ellipsis,
                      ),
                  searchable: true,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  initialValue: selectedProducts,
                  chipDisplay: MultiSelectChipDisplay.none(),
                  onConfirm: (values) {
                    setState(() {
                      selectedProducts =
                          values.cast<String>(); // Store only names
                    });

                    print("Selected Product Names: $selectedProducts");
                    print(
                        "Corresponding Product IDs: ${selectedProducts.map((name) => productMap[name]).toList()}");
                  },
                ),

                const SizedBox(height: 10),
                // Display Selected Products as Chips (Only Names)
                Wrap(
                  spacing: 8,
                  children: selectedProducts.map((name) {
                    return Chip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(name,
                              style: const TextStyle(color: Colors.white)),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedProducts
                                    .remove(name); // Remove name only
                              });
                              print("Product removed: $name");
                              print(
                                  "Updated Selected Products: $selectedProducts");
                            },
                            child: const Icon(Icons.close,
                                size: 16, color: Colors.white),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.green,
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),
                buildLabel("Service Name"),
                TextFormField(
                  controller: serviceController,
                  decoration: buildInputDecoration(),
                  validator: (value) =>
                      value!.isEmpty ? 'Service name is required' : null,
                ),
                const SizedBox(height: 10),
                buildLabel("Price"),
                TextFormField(
                  controller: priceController,
                  decoration: buildInputDecoration(),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) return 'Price is required';
                    if (double.tryParse(value) == null)
                      return 'Enter a valid number';
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                buildLabel("Description"),
                TextFormField(
                  controller: descriptionController,
                  decoration: buildInputDecoration(),
                  keyboardType: TextInputType.text,
                  validator: (value) =>
                      value!.isEmpty ? 'Description is required' : null,
                ),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          List<String> productIds = selectedProducts
                              .map((name) => productMap[name]!)
                              .toList();
                          print(
                              "Final Selected Product Names: $selectedProducts");
                          print("Final Product IDs: $productIds");

                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   // const SnackBar(content: Text("Service Added")),
                          // );
                          final double? parsedPrice =
                              double.tryParse(priceController.text);

                          if (type == 'edit') {
                            try {
                              await ref
                                  .read(serviceProvider.notifier)
                                  .updateService(
                                    serviceController.text,
                                    descriptionController.text,
                                    parsedPrice,
                                    productIds,
                                    serviceId,
                                  );
                              serviceController.clear();
                              descriptionController.clear();
                              priceController.clear();
                            } catch (e) {
                              print('catch exicuted..$e');
                            }
                          } else {
                            try {
                              await ref
                                  .read(serviceProvider.notifier)
                                  .addService(
                                      serviceController.text,
                                      descriptionController.text,
                                      parsedPrice,
                                      productIds

                                      // productIds
                                      );
                              serviceController.clear();
                              descriptionController.clear();
                              priceController.clear();
                              // _showSnackBar(
                              //     context, "Service added successfully!");
                              Navigator.of(context).pop();
                            } catch (e) {
                              print('Error: $e');
                            }
                          }
                        } else {
                          _showSnackBar(context, "Please fill all fields.");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6BC37A),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                      ),
                      child: Text(
                          type == 'edit' ? 'Update Srvice' : 'Add Service'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  InputDecoration buildInputDecoration() {
    return const InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            message == "Please fill all fields." ? Colors.red : Colors.blue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
