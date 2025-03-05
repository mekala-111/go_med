import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_med/screens/BottomNavBar.dart';

class ServicesEngineerPage extends ConsumerStatefulWidget {
  const ServicesEngineerPage({super.key});

  @override
  ConsumerState<ServicesEngineerPage> createState() => ServiceScreenState();
}

class ServiceScreenState extends ConsumerState<ServicesEngineerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Service Engineer Page")),
      body: const Center(
        child: Text("Welcome to the Service Engineer Page"),
      ),
      bottomNavigationBar:  const BottomNavBar(currentIndex: 4,),
    );
  }
}
