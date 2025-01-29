import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/Register.dart'; // Assuming your RegisterNotifier is here

class RegistrationPage extends ConsumerStatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  ConsumerState<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends ConsumerState<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  // final TextEditingController _usernameController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firmNameController = TextEditingController();
  final TextEditingController _gstNumberController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
   final TextEditingController _ownerNameController = TextEditingController();

  // Function to handle registration logic
  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      // final username = _usernameController.text.trim();
      // final email = _emailController.text.trim();
      final firmName = _firmNameController.text.trim();
      final gstNumber = _gstNumberController.text.trim();
      final contactNumber = _contactNumberController.text.trim();
      final address = _addressController.text.trim();
      final ownerName = _ownerNameController.text.trim();
      // final password = _passwordController.text.trim();

      ref.read(registrationProvider.notifier).updateForm(
        // username: username,
        // email: email,
        firmName: firmName,
        gstNumber: gstNumber,
        contactNumber: contactNumber,
        address: address,
        ownerName:ownerName,
      );
      await ref.read(registrationProvider.notifier).submitForm();
      final registrationState = ref.watch(registrationProvider);
      // Call API for registration (via provider)
      // final success = await ref
      //     .read(RegistrationNotifier.notifier) // Corrected to registerNotifierProvider
      //     .register(username, password, email, firmName, gstNumber, contactNumber, address);

      if (registrationState.errorMessage == null) {
        // Show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Registration successful!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pushNamed(context, '/login'); // Navigate to login page
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Show failure snackbar
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Registration Failed')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register',),
       backgroundColor: Color(0xFF6EE883), 
      
      
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
             
              TextFormField(
                controller: _firmNameController ,
                decoration: const InputDecoration(labelText: 'Firm name '),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an Firm name';
                  } 
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _ownerNameController,
                decoration: const InputDecoration(labelText: 'Owner name '),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Owner name ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _gstNumberController,
                decoration: const InputDecoration(labelText: 'GST Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a GST number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _contactNumberController,
                decoration: const InputDecoration(labelText: 'Contact Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a contact number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address Details'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address Details';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              // TextFormField(
              //   controller: _passwordController,
              //   decoration: const InputDecoration(labelText: 'Password'),
              //   obscureText: true,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter a password';
              //     } else if (value.length < 6) {
              //       return 'Password must be at least 6 characters';
              //     }
              //     return null;
              //   },
              // ),
              const SizedBox(height: 24.0),
             ElevatedButton(
             onPressed: _register,
             style: ElevatedButton.styleFrom(
             backgroundColor: Color(0xFF6EE883), // Set button color
             ),
             child: const Text('Register'),
            )


            ],
          ),
        ),
      ),
    );
  }
}
