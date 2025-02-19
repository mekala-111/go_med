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

  List<String> selectedProducts = [];
  Map<String, String> productMap = {};
  List<String> productNames = [];
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
        productId = List<String>.from(args['productIds'] ?? []);
        type = args['type'] ?? '';
        serviceId = args['serviceId'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productProvider).data ?? [];

    productMap = {
      for (var p in products) p.productId ?? "": p.productName ?? "Unknown"
    };

    productNames = productMap.values.toList();

    if (productId != null) {
      selectedProducts = productId!
          .map((id) => productMap[id] ?? "Unknown")
          .where((name) => name != "Unknown")
          .toList();
    }

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

                MultiSelectDialogField(
                  items: productNames
                      .map((name) => MultiSelectItem<String>(name, name))
                      .toList(),
                  title: const Text("Select Products"),
                  buttonText: const Text("Choose Products"),
                  searchable: true,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  initialValue: selectedProducts,
                  chipDisplay: MultiSelectChipDisplay.none(),
                  onConfirm: (values) {
                    setState(() {
                      selectedProducts = values.cast<String>();
                    });
                  },
                ),

                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: selectedProducts.map((name) {
                    return Chip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(name, style: const TextStyle(color: Colors.white)),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedProducts.remove(name);
                              });
                            },
                            child: const Icon(Icons.close, size: 16, color: Colors.white),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.green,
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: 16),
                buildLabel("Service Name"),
                TextFormField(controller: serviceController, decoration: buildInputDecoration()),
                const SizedBox(height: 10),
                buildLabel("Price"),
                TextFormField(controller: priceController, decoration: buildInputDecoration(), keyboardType: TextInputType.number),
                const SizedBox(height: 10),
                buildLabel("Description"),
                TextFormField(controller: descriptionController, decoration: buildInputDecoration()),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          List<String> productIds = selectedProducts
                              .map((name) => productMap.entries
                                  .firstWhere((entry) => entry.value == name, orElse: () => MapEntry("", ""))
                                  .key)
                              .toList();

                          final double? parsedPrice = double.tryParse(priceController.text);

                          if (type == 'edit') {
                            await ref.read(serviceProvider.notifier).updateService(
                              serviceController.text, descriptionController.text, parsedPrice, productIds, serviceId,
                            );
                          } else {
                            await ref.read(serviceProvider.notifier).addService(
                              serviceController.text, descriptionController.text, parsedPrice, productIds,
                            );
                            Navigator.of(context).pop();
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6BC37A)),
                      child: Text(type == 'edit' ? 'Update Service' : 'Add Service'),
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
    return Text(text, style: const TextStyle(fontWeight: FontWeight.bold));
  }

  InputDecoration buildInputDecoration() {
    return const InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
    );
  }
}
