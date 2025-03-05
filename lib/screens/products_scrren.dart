import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_med/providers/products.dart';
import 'package:go_med/providers/sparepartProvider.dart';
import 'package:go_med/screens/BottomNavBar.dart';
import 'package:go_med/screens/dashboard.dart';
import 'package:go_med/screens/product_edit.dart';
import 'Bookings.dart';
import '../model/product_state.dart' as product_model;
import '../model/sparepartState.dart' as sparepart_model;
import '../screens/product_edit.dart';
import '../providers/loader.dart';

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
      ref.watch(productProvider.notifier).getProducts();
      ref.watch(sparepartProvider.notifier).getSpareParts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<product_model.Data> productState =
        ref.watch(productProvider).data ?? [];
    print('productsstate.....................................$productState');
    final List<sparepart_model.Data> sparePartsState =
        ref.watch(sparepartProvider).data ?? [];
    print(
        'sparepartstate.....................................$sparePartsState');

    return Scaffold(
      backgroundColor: const Color(0xFFE8F7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6BC37A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context,
                MaterialPageRoute(builder: (context) => const DashboardPage()));
          },
        ),
        title: const Text(
          'Products',
          style: TextStyle(color: Colors.black),
        ),
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
            Expanded(
              child: productState.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _buildProductList(productState, sparePartsState),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildHeaderActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionButton(
            context, 'Add New \nProducts', const AddProductScreen()),
        _buildActionButton(context, 'Manage \nInventory', const BookingsPage()),
      ],
    );
  }

  Widget _buildProductList(List<product_model.Data> productState,
      List<sparepart_model.Data> sparePartsState) {
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
        return _buildProductCard(context, product, sparePartsState);
      },
    );
  }

  Widget _buildActionButton(BuildContext context, String label, Widget page) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0x801BA4CA),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      child: Text(label, style: const TextStyle(color: Colors.black)),
    );
  }

  Widget _buildProductCard(BuildContext context, product_model.Data product,
    List<sparepart_model.Data> sparePartsState) {
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
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Price: ₹${product.price ?? 0}',
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text('Category: ${product.category ?? 'Unknown'}',
            style: const TextStyle(fontSize: 14)),
        Text('Description: ${product.productDescription ?? ''}',
            style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 16),

        /// **Row to Align Buttons Side by Side**
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space buttons evenly
          children: [
            _buildActionButtonCard(context, 'SpareParts', Colors.green, () {
              _showSparePartsDialog(context, product.productId, sparePartsState);
            }),
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
            _buildActionButtonCard(context, 'Delete', Colors.red, () {
              _showConfirmationDialog(
                context,
                'Delete',
                'Are you sure you want to delete this product?',
                () => ref
                    .read(productProvider.notifier)
                    .deleteProduct(product.productId),
              );
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

  void _showSparePartsDialog(BuildContext context, String? productId,
      List<sparepart_model.Data> sparePartsState) {
    print("Total Spare Parts: ${sparePartsState.length}"); // Debugging log
    final spareParts =
        sparePartsState.where((sp) => sp.productId == productId).toList();
    print('spareParts...........$spareParts');
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
                Expanded(
                  child: spareParts.isEmpty
                      ? const Center(child: Text("No Spare Parts Available"))
                      : ListView(
                          children: spareParts
                              .map((part) => _buildSparePartItem(context, part))
                              .toList(),
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

Widget _buildSparePartItem(
    BuildContext context, sparepart_model.Data sparePart) {
  
  /// Function to truncate text
  String truncateText(String text, {int maxLength = 20}) {
    return (text.length > maxLength) ? '${text.substring(0, maxLength)}...' : text;
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
        /// **Spare Part Name (Truncated)**
        Text(
          truncateText(sparePart.sparepartName ?? 'Unknown', maxLength: 25),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis, // Ensures name doesn't overflow
        ),

        const SizedBox(height: 4),

        /// **Price**
        Text(
          '₹${sparePart.price ?? 0}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
        ),

        const SizedBox(height: 8),

        /// **Description (Truncated)**
        Text(
          truncateText(sparePart.description ?? '', maxLength: 50),
          style: const TextStyle(fontSize: 14),
          overflow: TextOverflow.ellipsis, // Ensures description doesn't overflow
        ),

        const SizedBox(height: 16),
        

        /// **Icons Row (Edit & Delete)**
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                // Handle edit logic here
                Navigator.pushNamed(
                context,
                'addproductscreen',
                arguments: {
                  'type': "edit",
                  'isChecked':true,
                  'sparepartName': sparePart.sparepartName,
                  'price': sparePart.price,
                  // 'productName':sparePart.productName,
                  'description': sparePart.description,
                  'sparepartId': sparePart.sparepartId,
                  'productId':sparePart.productId,
                  'selectedProduct':sparePart.productName
                },
              );


              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // Handle delete logic here
                _showConfirmationDialog(
                context,
                'Delete',
                'Are you sure you want to delete this sparepart?',
                () => ref
                    .read(sparepartProvider.notifier)
                    .deleteSpareparts(sparePart.sparepartId),
              );
              },
            ),
          ],
        ),
      ],
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
