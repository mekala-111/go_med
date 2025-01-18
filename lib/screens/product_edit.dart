import 'package:flutter/material.dart';

import 'BottomNavBar.dart';

class ProductScreenEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6BC37A),// Green color
        title: Text('Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add/ Edit Products',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Product Name',
                filled: true,
                fillColor: Color(0xFFD0F2F1), // Light Blue Color
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Price',
                filled: true,
                fillColor: Color(0xFFD0F2F1), // Light Blue Color
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Initial Stock',
                filled: true,
                fillColor: Color(0xFFD0F2F1), // Light Blue Color
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: Text('Add Product'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2E6B43), // Green color
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Inventory Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text('Low Stock Products: 35'),
            Text('Out of Stock Products: 15'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: Text('Restock Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2E6B43), // Green color
              ),
            ),
          ],
        ),
      ),
       bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }
}