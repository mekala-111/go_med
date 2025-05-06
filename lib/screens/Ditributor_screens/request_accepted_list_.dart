import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/Distributor_provider/request_accepted_list_provider.dart';
import '../../model/DIstributor_models/request_accepted_list_model.dart';

class RequestAcceptProductScreen extends ConsumerStatefulWidget {
  const RequestAcceptProductScreen({super.key});

  @override
  ConsumerState<RequestAcceptProductScreen> createState() =>
      _RequestAcceptProductScreenState();
}

class _RequestAcceptProductScreenState
    extends ConsumerState<RequestAcceptProductScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final List<String> tabs = ['All', 'Accepted', 'Pending', 'Rejected'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    Future.microtask(() {
      ref.read(requestAcceptedProdutsProvider.notifier).getAcceptProducts();
    });
  }

  Future<void> _refresh() async {
    await ref.read(requestAcceptedProdutsProvider.notifier).getAcceptProducts();
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'accepted':
        return Colors.green;
      case 'pending':
        return Colors.yellow.shade800;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(requestAcceptedProdutsProvider);
    final allProducts = productState.data ?? [];

    final mainProducts = allProducts.where((p) => p.parentId == null).toList();
    final spareParts = allProducts.where((p) => p.parentId != null).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE8F7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6BC37A),
        elevation: 0,
        title: const Text('Requested Products',
            style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 255, 248, 242),
            child: TabBar(
              controller: _tabController,
              tabs: tabs.map((e) => Tab(text: e)).toList(),
              labelColor: Colors.black,
              indicatorColor: const Color.fromARGB(255, 14, 234, 87),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: tabs.map((status) {
                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: Builder(
                    builder: (context) {
                      if (productState.data!.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      List<Widget> cards = [];

                      if (status == 'All') {
                        for (final product in mainProducts) {
                          final children = spareParts
                              .where((sp) => sp.parentId == product.productId)
                              .toList();
                          cards.add(_buildProductCard(product, children));
                        }
                      } else {
                        // Filter for current tab
                        final filteredMain = mainProducts
                            .where((p) =>
                                (p.adminApproval ?? '').toLowerCase() ==
                                status.toLowerCase())
                            .toList();

                        final filteredSpareParts = spareParts
                            .where((sp) =>
                                (sp.adminApproval ?? '').toLowerCase() ==
                                status.toLowerCase())
                            .toList();

                        for (final product in filteredMain) {
                          cards.add(_buildProductCard(product, []));
                        }

                        for (final sp in filteredSpareParts) {
                          final parent = mainProducts.firstWhere(
                              (p) => p.productId == sp.parentId,
                              orElse: () => Data(productName: 'Unknown'));

                          cards.add(_buildSparePartCard(sp, parent));
                        }
                      }

                      if (cards.isEmpty) {
                        return const Center(child: Text("No products found."));
                      }

                      return ListView(children: cards);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Data product, List<Data> spareParts) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.productName ?? 'Unnamed Product',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Text('Status: '),
                Text(
                  product.adminApproval ?? 'Unknown',
                  style: TextStyle(
                      color: _getStatusColor(product.adminApproval),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('Price: ${product.price ?? 'N/A'}'),
            Text('Quantity: ${product.quantity ?? 'N/A'}'),
            if (spareParts.isNotEmpty) ...[
              const Divider(height: 20),
              const Text('Spare Parts:',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              ...spareParts.map((sp) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(sp.productName ?? 'Spare Part'),
                        Row(
                          children: [
                            const Text('Status: '),
                            Text(
                              sp.adminApproval ?? 'Unknown',
                              style: TextStyle(
                                color: _getStatusColor(sp.adminApproval),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text('Price: ${sp.price ?? 'N/A'}'),
                        Text('Quantity: ${sp.quantity ?? 'N/A'}'),
                      ],
                    ),
                  ))
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildSparePartCard(Data spare, Data parent) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Spare Part: ${spare.productName ?? ''}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Parent Product: ${parent.productName ?? 'Unknown'}',
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Text('Status: '),
                Text(
                  spare.adminApproval ?? 'Unknown',
                  style: TextStyle(
                      color: _getStatusColor(spare.adminApproval),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text('Price: ${spare.price ?? 'N/A'}'),
            Text('Quantity: ${spare.quantity ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }
}
