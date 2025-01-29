import 'package:flutter/material.dart';
import 'BottomNavBar.dart';
import '../providers/products.dart';
import '../providers/loader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddProductScreen> createState() => ProductScreenState();
}

class ProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final bool isLoading = false;
  String? productId;
  String? type;
  
  // Local variable to manage the checkbox state
  bool isChecked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch arguments using ModalRoute
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      setState(() {
        productNameController.text = args['productName'] ?? '';
        priceController.text = args['price'] ?? '';
        descriptionController.text = args['description'] ?? '';
        categoryController.text = args['category'] ?? '';
        type = args['type'] ?? '';
        productId = args['productId'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6BC37A),
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Checkbox and label row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Main Text
                    Text(
                      type == 'edit' ? 'edit products' : 'Add Products',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 70), // Spacing between elements

                    // Checkbox
                    Checkbox(
                      value: isChecked, // Use the local variable to track state
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value ?? false; // Update the checkbox state
                        });
                      },
                    ),

                    // Clickable text
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isChecked = !isChecked; // Toggle the checkbox state when the text is tapped
                        });
                      },
                      child: const Text(
                        'SpareParts',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                _buildTextField(
                  controller: productNameController,
                  labelText: "Product Name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Product name is required.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: priceController,
                  labelText: "Price",
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Price is required.";
                    }
                    if (double.tryParse(value) == null) {
                      return "Enter a valid number.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: descriptionController,
                  labelText: "Description",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Description is required.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: categoryController,
                  labelText: "Category",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Category is required.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            final double? parsedPrice =
                                double.tryParse(priceController.text);

                            if (parsedPrice == null) {
                              _showSnackBar(
                                  context, "Please enter a valid price.");
                              return;
                            }

                            if (type == 'edit') {
                              try {
                                await ref
                                    .read(productProvider.notifier)
                                    .updateProduct(
                                        productNameController.text,
                                        descriptionController.text,
                                        parsedPrice,
                                        categoryController.text,
                                        productId);

                                // Clear form fields
                                productNameController.clear();
                                priceController.clear();
                                descriptionController.clear();
                                categoryController.clear();

                                _showSnackBar(
                                    context, "Product updated successfully!");
                                Navigator.of(context).pop();
                              } catch (e) {
                                _showSnackBar(context, e.toString());
                              }
                            } else {
                              try {
                                await ref
                                    .read(productProvider.notifier)
                                    .addProduct(
                                      productNameController.text,
                                      descriptionController.text,
                                      parsedPrice,
                                      categoryController.text,
                                    );

                                // Clear form fields
                                productNameController.clear();
                                priceController.clear();
                                descriptionController.clear();
                                categoryController.clear();

                                _showSnackBar(
                                    context, "Product added successfully!");
                                Navigator.of(context).pop();
                              } catch (e) {
                                _showSnackBar(context, e.toString());
                              }
                            }
                          } else {
                            _showSnackBar(context, "Please fill all fields.");
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0x801BA4CA),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(type == 'edit' ? 'update product' : 'Add Product'),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: const Color.fromARGB(255, 229, 234, 230),
      ),
      keyboardType: keyboardType,
      validator: validator,
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
