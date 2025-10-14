import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_med/constants/app_colors.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firmNameController = TextEditingController();
  final TextEditingController _gstNumberController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController(text: "+91");
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
 File? _selectedImage;
  final double maxImageSize = 5 * 1024 * 1024; // 5 MB in bytes


  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      final File imageFile = File(image.path);
      final int imageSize = await imageFile.length();
       // Check file format
    final String fileExtension = image.path.split('.').last.toLowerCase();
    if (fileExtension != 'jpg' && fileExtension != 'jpeg' && fileExtension != 'png') {
      _showFormatError();
      return;
    }


      if (imageSize <= maxImageSize) {
        setState(() {
          _selectedImage = imageFile;
        });
      } else {
        _showSizeError();
      }
    }
  }
  void _showFormatError() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Invalid Image Format"),
      content: const Text("Only .jpg, .jpeg, or .png files are allowed. Please select a valid image."),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("OK"),
        ),
      ],
    ),
  );
}

  

  void _showSizeError() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Image Too Large"),
        content: const Text("The selected image exceeds the size limit of 5 MB. Please choose a smaller image."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
  

  // Function to handle registration logic
  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      // final username = _usernameController.text.trim();
      final email = _emailController.text.trim();
      final firmName = _firmNameController.text.trim();
      final gstNumber = _gstNumberController.text.trim();
      final contactNumber = _contactNumberController.text.trim();
      final address = _addressController.text.trim();
      final ownerName = _ownerNameController.text.trim();
      // final password = _passwordController.text.trim();

      
      await ref.read(registrationProvider.notifier).submitForm(
           
           firmName,
             gstNumber,
             contactNumber,
             address,
            ownerName,
            email,
            _selectedImage
      );
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
                  Navigator.pushNamed(
                      context, '/login'); // Navigate to login page
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
        ),
        backgroundColor: AppColors.gomedcolor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
  onTap: () => _showImageSourceActionSheet(context),
  child: Container(
    width: 90, // Adjust width as needed
    height: 150, // Adjust height as needed
    decoration: BoxDecoration(
      color: AppColors.grey, // Background color if no image is selected
      borderRadius: BorderRadius.circular(10), // Optional: Rounded corners
      image: _selectedImage != null
          ? DecorationImage(
              image: FileImage(_selectedImage!),
              fit: BoxFit.cover, // Ensures the image covers the box
            )
          : null,
    ),
    child: _selectedImage == null
        ? const Icon(
            Icons.camera_alt_sharp,
            size: 50,
            color: AppColors.grey,
          )
        : null,
  ),
),

              TextFormField(
                controller: _firmNameController,
                decoration: const InputDecoration(labelText: 'Firm name '),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an Firm name';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.02),

            
              SizedBox(height: screenHeight * 0.02),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please enter a email number';
                  }
                },
              ),

              SizedBox(height: screenHeight * 0.02),

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

              SizedBox(height: screenHeight * 0.02),

              TextField(
                controller: _contactNumberController,
                // decoration: InputDecoration(
                //   hintText: 'Enter your phone number',
                //   filled: true,
                //   // fillColor: Colors.grey[200],

                // ),
                decoration: const InputDecoration(labelText: 'phone Number'),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  if (!value.startsWith("+91")) {
                    _contactNumberController.text = "+91";
                    _contactNumberController.selection =
                        TextSelection.fromPosition(
                      TextPosition(
                          offset: _contactNumberController.text.length),
                    );
                  }
                },
              ),
              SizedBox(height: screenHeight * 0.02),

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
              SizedBox(height: screenHeight * 0.02),

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
              SizedBox(height: screenHeight * 0.04),

              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gomedcolor, // Set button color
                ),
                child: const Text('Register'),
              )
            ],
          ),
        ),
      ),
    );
  }
   void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take a photo"),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from gallery"),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

