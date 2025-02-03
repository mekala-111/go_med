import 'dart:io';

import 'package:flutter/material.dart';
import 'BottomNavBar.dart';
import '../providers/products.dart';
import '../providers/loader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

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
  final TextEditingController SparePartsContoller = TextEditingController();
  final bool isLoading = false;
  String? productId;
  String? type;

  // Local variable to manage the checkbox state
  bool isChecked = false;

  // Image Picker variables
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // Local variable for selected dropdown item
  String? selectedProduct;
   // Show popup for selecting camera or gallery
  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take a Photo"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }
   void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        final fileSizeInBytes = await imageFile.length();
        final maxFileSize = 2 * 1024 * 1024; // 2MB

        if (fileSizeInBytes > maxFileSize) {
          _showAlertDialog(
              'Error', 'File size exceeds 2MB. Please select a smaller file.');
        } else {
          setState(() {
            _image = imageFile;
          });
        }
      }
    } catch (e) {
      _showAlertDialog('Error', 'Failed to pick image: $e');
    }
  }



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
    final productState = ref.watch(productProvider).data ?? []; // Product state from provider
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
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 70), // Spacing between elements

                    // Checkbox
                    Row(
                      children: [
                        Checkbox(
                          value: isChecked,
                          onChanged: (bool? value) async {
                            setState(() {
                              isChecked = value ?? false;
                            });
                          },
                        ),
                        // Clickable Text to toggle checkbox state
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isChecked = !isChecked; // Toggle the checkbox state
                            });
                          },
                          child: const Text(
                            'SpareParts',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Conditionally show the Dropdown when checkbox is checked
                if (isChecked)
                  DropdownButton<String>(
                    value: selectedProduct,
                    hint: const Text("Select a Product"),
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedProduct = newValue;
                      });
                    },
                    items: productState.map<DropdownMenuItem<String>>((product) {
                      return DropdownMenuItem<String>(
                        // value: product[''], // Assuming `product` has a 'name' field
                        // child: Text(product['name']), 
                        value: product.productName, // The entire Data object is passed as the value
                       child:  Text('${product.productName}'), // Display the name of the product// Display name of product
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 16),

                // Image Picker Section
                GestureDetector(
                  onTap: _showImagePickerOptions, // Open popup when tapped
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    child: _image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(_image!, fit: BoxFit.cover),
                          )
                        : const Center(
                            child: Icon(Icons.add_a_photo,
                                size: 40, color: Colors.grey),
                          ),
                  ),
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
                                        productId,
                                        _image);

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
                                      _image,
                                      SparePartsContoller.text // Pass the image path
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
