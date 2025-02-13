import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_med/screens/BottomNavBar.dart';
import 'package:go_med/providers/auth_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool isEditing = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  File? _selectedImage;
  final double maxImageSize = 5 * 1024 * 1024; // 5 MB in bytes
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final userModel = ref.read(loginProvider);
    if (userModel.data != null && userModel.data!.isNotEmpty) {
      final user = userModel.data![0].distributor;
      nameController.text = user?.ownerName ?? "";
      emailController.text = user?.ownerName ?? "";
      phoneController.text = user?.mobile ??"";
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      final File imageFile = File(image.path);
      final int imageSize = await imageFile.length();

      if (imageSize <= maxImageSize) {
        setState(() {
          _selectedImage = imageFile;
        });
      } else {
        _showSizeError();
      }
    }
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFE8F7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6BC37A),
        elevation: 0,
        title: Row(
          children: [
            const Text(
              "Profile",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey,
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView( // Prevents pixel overflow
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => _showImageSourceActionSheet(context),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!) as ImageProvider
                            : null,
                        child: _selectedImage == null
                            ? const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.grey,
                              )
                            : null,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                     nameController.text.isNotEmpty ? nameController.text : "User Name",
                    style: TextStyle(fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold),
    
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              _buildProfileField("Name", nameController, isEditing),
              SizedBox(height: screenHeight * 0.01),
              _buildProfileField("Email", emailController, isEditing),
              SizedBox(height: screenHeight * 0.01),
              _buildProfileField("Phone", phoneController, isEditing),
              SizedBox(height: screenHeight * 0.03),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (isEditing) {
                      try {
                        // Call the updateProfile function
                        await ref.read(loginProvider.notifier).updateProfile(
                          nameController.text,
                          emailController.text,
                          phoneController.text,
                          _selectedImage,
                          ref
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Profile updated successfully!")),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error updating profile: $e")),
                        );
                      }
                    }

                    setState(() {
                      isEditing = !isEditing;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isEditing ? Colors.green : Colors.blue,
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.015,
                      horizontal: MediaQuery.of(context).size.width * 0.3,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    isEditing ? 'Save' : 'Edit Profile',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildProfileField(String label, TextEditingController controller, bool isEditing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          enabled: isEditing,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: isEditing ? Colors.white : Colors.grey[200],
          ),
        ),
      ],
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










































// class ProfileHeader extends StatelessWidget {
//   const ProfileHeader({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         IconButton(
//           onPressed: () {
//             // Action for Hide button
//           },
//           icon: const Icon(Icons.visibility_off, color: Colors.black),
//           iconSize: 30,
//         ),
//         const SizedBox(width: 10), // Space between Hide button and name
//         const Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text("Go Code Designers", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
//             Text("@gocodedesigner", style: TextStyle(color: Colors.grey)),
//           ],
//         ),
//         const SizedBox(width: 20),
//         IconButton(
//           icon: const Icon(Icons.settings, color: Colors.black),
//           iconSize: 30,
//           onPressed: () {
//                Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const ProfileSetupPage()),
//             );
//             // Settings action
//           },
//         ),
//       ],
//     );
//   }
// }

// class BusinessDetailsSection extends StatelessWidget {
//   const BusinessDetailsSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Business Details", style: TextStyle(fontWeight: FontWeight.bold)),
//         SizedBox(height: 10),
//         DetailItem(label: "Phone Number", value: "+91 9502105833"),
//         DetailItem(label: "Email", value: "gocode@gocodecreations.com"),
//         DetailItem(label: "Delivery Address", value: "GoCode Designers Private limited, DD Colony, Hyderabad, Telangana - 500044"),
//       ],
//     );
//   }
// }

// class DetailItem extends StatelessWidget {
//   final String label;
//   final String value;

//   const DetailItem({super.key, required this.label, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(child: Text(label, style: const TextStyle(color: Colors.black54))),
//           Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold))),
//           const Icon(Icons.edit, color: Colors.grey, size: 16),
//         ],
//       ),
//     );
//   }
// }

// class VerificationSection extends StatelessWidget {
//   const VerificationSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text("Verification Section :", style: TextStyle(fontWeight: FontWeight.bold)),
//         const SizedBox(height: 10),
//         const Row(
//           children: [
//             Text("Verification Status:", style: TextStyle(color: Colors.black54)),
//             SizedBox(width: 8),
//             Text("Pending/Verified", style: TextStyle(color: Colors.orange)),
//           ],
//         ),
//         const SizedBox(height: 10),
//         Row(
//           children: [
//             const Text("Submit ID Proof for Verification:", style: TextStyle(color: Colors.black54)),
//             const SizedBox(width: 8),
//             GestureDetector(
//               onTap: () {
//                 // Upload function
//               },
//               child: const Text("upload", style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         const Text(
//           "Please upload a government-issued ID for verification.\nVerification will take 24-48 hours.",
//           style: TextStyle(color: Colors.grey, fontSize: 12),
//         ),
//       ],
//     );
//   }
// }
