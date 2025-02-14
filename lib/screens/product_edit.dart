import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  final TextEditingController sparePartsContoller = TextEditingController();
  bool isLoading = false;
  List filteredProductsList = [];
  final TextEditingController _searchController = TextEditingController();
  String? productId;
  String? type;

  // Local variable for selected dropdown item
  String? selectedProduct;

  // Image Picker variables
  List<File> _image=[];
  final ImagePicker _picker = ImagePicker();

  // Track checkbox state
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        filteredProductsList = [];
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final productState = ref.watch(productProvider).data ?? [];
    filteredProductsList = productState;

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

    _searchController.addListener(() {
      setState(() {
        filteredProductsList = productState
            .where((product) => product.productName!
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
            _image = [imageFile];
            // _image.add(File(imageFile.path));
          });
        }
      }
    } catch (e) {
      _showAlertDialog('Error', 'Failed to pick image: $e');
    }
  }

  void _showNoSparePartsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("No Spare Parts Available"),
          content: const Text(
              "There are no spare parts available. Would you like to add a new product?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const AddProductScreen()), // Navigate to Add Product page
                );
              },
              child: const Text("Add Product"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productProvider).data ?? [];
    final filteredProducts =
        productState.where((product) => product.spareParts == false).toList();


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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      type == 'edit' ? 'Edit Products' : 'Add Products',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 70),
                    Row(
                      children: [
                        Checkbox(
                          value: isChecked,
                          onChanged: (bool? value) async {
                            setState(() {
                              isChecked = value ?? false;
                            });
                            if (isChecked && productState.isEmpty) {
                              _showNoSparePartsDialog();
                            }
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isChecked = !isChecked;
                            });
                            if (isChecked && productState.isEmpty) {
                              _showNoSparePartsDialog();
                            }
                          },
                          child: const Text(
                            'SpareParts',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 0),
                if (isChecked && filteredProducts.isNotEmpty)
                  Column(
                    children: [
                      // Display selected product above the search bar
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    if (selectedProduct != null)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("selectedProduct!: $selectedProduct"),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        controller: _searchController,
                                    //     onChanged: (query) {
                                    //    setState(() {
                                    //   filteredProducts = allProducts
                                    //  .where((product) => product.productName!
                                    //   .toLowerCase()
                                    //   .contains(query.toLowerCase()))
                                    //   .toList();
                                    //        });
                                    //        },
                                       
                                        decoration: InputDecoration(
                                          labelText: "Search Products",
                                          filled: true,
                                          fillColor: Colors.grey[200],
                                          prefixIcon: const Icon(Icons.search),
                                        ),
                                      ),
                                    ),
                                    // Added scrollable section here
                                    Expanded(
                                      
                                      child: ListView.builder(
                                        
                                        itemCount: filteredProducts.isEmpty
                                            ? 1
                                            : filteredProducts.length,
                                        itemBuilder: (context, index) {
                                          if (filteredProducts.isEmpty) {
                                            return const Center(
                                                child:
                                                    Text('No products found.'));
                                          } else {
                                            final product =
                                                filteredProducts[index];
                                            return ListTile(
                                              title: Text(product.productName!),
                                              onTap: () {
                                                setState(() {
                                                  selectedProduct =
                                                      product.productName;
                                                  sparePartsContoller.text =
                                                      product.productName!;
                                                });
                                                Navigator.pop(context);
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ListTile(
                            title: Text(
                              selectedProduct ?? 'Select Product',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _showImagePickerOptions,
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    child:  _image.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(_image.first, fit: BoxFit.cover),
                          )
                        : const Center(
                            child: Icon(Icons.add_a_photo,
                                size: 40, color: Colors.grey),
                          ),
                  ),
                ),
                const SizedBox(height: 8),
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
                const SizedBox(height: 8),
                _buildTextField(
                  controller: priceController,
                  labelText: "Price",
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Price is required.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: descriptionController,
                  labelText: "Description",
                  maxLines: 3,
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: categoryController,
                  labelText: "Category",
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (!isChecked) // Show Add Product button when checkbox is unchecked
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
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
                                          sparePartsContoller.text);

                                  // Clear form fields
                                  productNameController.clear();
                                  priceController.clear();
                                  descriptionController.clear();
                                  categoryController.clear();
                                  sparePartsContoller.clear();

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
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: Text(type == 'edit'
                              ? 'Update Product'
                              : 'Add Product'),
                        ),
                      ),
                    if (isChecked) // Show Add SparePart button when checkbox is checked
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  print(
                                      'sparepartbutton works.......................');
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    final double? parsedPrice =
                                        double.tryParse(priceController.text);
                                    print('printed...........');
                                    if (parsedPrice == null) {
                                      _showSnackBar(context,
                                          "Please enter a valid price.");
                                      print('printes.................');
                                      return;
                                    }

                                    try {
                                      print('Parsed price: $parsedPrice');
                                      print('Product Name: ${productNameController.text}');
                                      print('Description: ${descriptionController.text}');
                                      print('Selected Product: $selectedProduct');
                                      print('Image: $_image');

                                      await ref
                                          .read(productProvider.notifier)
                                          .addSpareParts(
                                              productNameController.text,
                                              descriptionController.text,
                                              parsedPrice,
                                              selectedProduct,
                                              _image);
                                      print('try exicuted==========');

                                      // Clear form fields
                                      productNameController.clear();
                                      priceController.clear();
                                      descriptionController.clear();

                                      _showSnackBar(context,
                                          "Sparepart added successfully!");
                                      Navigator.of(context).pop();
                                    } catch (e, stackTrace) {
                                      print('Error: $e');
                                      print('Stack Trace: $stackTrace');
                                      _showSnackBar(context, e.toString());
                                       }

                                  } else {
                                    _showSnackBar(
                                        context, "Please fill all fields.");
                                    print('else executed');
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0x801BA4CA),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text('Add SparePart'),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
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