import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/request_accepted_list_provider.dart';
import '../model/request_accepted_list_model.dart';

class RequestAcceptProductScreen extends ConsumerStatefulWidget {
  const RequestAcceptProductScreen({super.key});

  @override
  ConsumerState<RequestAcceptProductScreen> createState() => _RequestAcceptProductScreenState();
}

class _RequestAcceptProductScreenState extends ConsumerState<RequestAcceptProductScreen> with TickerProviderStateMixin {
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
        title: const Text('Requested Products', style: TextStyle(color: Colors.black)),
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs.map((e) => Tab(text: e)).toList(),
          labelColor: Colors.black,
          indicatorColor: Colors.white,
        ),
      ),
      body: productState.data!.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: tabs.map((status) {
                List<Data> filteredMain = status == 'All'
                    ? mainProducts
                    : mainProducts.where((p) => (p.adminApproval ?? '').toLowerCase() == status.toLowerCase()).toList();

                if (filteredMain.isEmpty) {
                  return const Center(child: Text('No products found'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: filteredMain.length,
                  itemBuilder: (context, index) {
                    final product = filteredMain[index];
                    final children = spareParts.where((s) => s.parentId == product.productId).toList();

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.productName ?? 'Unnamed Product',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text('Status: ${product.adminApproval ?? 'Unknown'}',
                                style: const TextStyle(color: Colors.grey)),
                            const Divider(height: 20),
                            if (children.isNotEmpty)
                              ...children.map((sp) => Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(sp.productName ?? 'Spare Part'),
                                        Text('Status: ${sp.adminApproval ?? 'Unknown'}',
                                            style: const TextStyle(color: Colors.blueGrey)),
                                      ],
                                    ),
                                  )),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
    );
  }
}
