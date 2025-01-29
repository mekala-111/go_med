import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_med/providers/products.dart';
import 'package:go_med/screens/BottomNavBar.dart';
import 'package:go_med/screens/dashboard.dart';
import 'package:go_med/screens/product_edit.dart';
import 'Bookings.dart';
import '../model/product_state.dart';

class ProductScreen extends ConsumerStatefulWidget {
  const ProductScreen({super.key});

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch products when the widget is loaded
    ref.read(productProvider.notifier).getProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productProvider).data ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFE8F7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6BC37A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
          },
        ),
        title: const Text(
          'Products',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              // Handle notifications action here
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderActions(context),
            const SizedBox(height: 16),
            const Text(
              'Products',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(child: _buildProductList(productState)),
            const SizedBox(height: 16),
            // _buildSubmitButton(),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(
        currentIndex: 3,
      ),
    );
  }

  Widget _buildHeaderActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionButton(
          context,
          'Add New \nProducts',
          const AddProductScreen(),
        ),
        _buildActionButton(
          context,
          'Manage \nInventory',
          const BookingsPage(),
        ),
      ],
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

  // Widget _buildSubmitButton() {
  //   return Center(
  //     child: ElevatedButton(
  //       onPressed: () {
  //         // Handle submit action here
  //       },
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: const Color(0x801BA4CA),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(8),
  //         ),
  //         padding: const EdgeInsets.symmetric(
  //           vertical: 12,
  //           horizontal: 40,
  //         ),
  //       ),
  //       child: const Text(
  //         'Submit',
  //         style: TextStyle(fontSize: 16, color: Colors.black),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildActionButton(BuildContext context, String label, Widget page) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0x801BA4CA),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.black),
      ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                product.productName ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Price: ₹${product.price ?? 0}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Category: ${product.category ?? 'Unknown'}',
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            'Description: ${product.productDescription ?? ''}',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildActionButtonCard(context, 'Restock', Colors.green, () {
                _showConfirmationDialog(
                    context, 'Restock', 'Are you sure you want to restock?',
                    () {
                  // Handle restock action
                });
              }),
              const SizedBox(width: 8),
              _buildActionButtonCard(context, 'Edit', Colors.grey, () {
                Navigator.pushNamed(
                  context,
                  'addproductscreen',
                  arguments: {
                    'type': "edit",
                    'productName': product.productName,
                    'price': product.price.toString(),
                    'category': product.category,
                    'description': product.productDescription,
                    'productId': product.productId
                  },
                );
              }),
              const SizedBox(width: 8),
              _buildActionButtonCard(context, 'Delete', Colors.red, () {
                _showConfirmationDialog(context, 'Delete',
                    'Are you sure you want to delete this product?', () {
                  // Handle delete action
                  ref.read(productProvider.notifier).deleteProduct( product.productId);
                });
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtonCard(
      BuildContext context, String label, Color color, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, String action,
      String message, VoidCallback onConfirmed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(action),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirmed();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
