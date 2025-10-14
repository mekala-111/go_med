import 'package:flutter/material.dart';
import 'package:go_med/constants/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:cached_network_image/cached_network_image.dart';
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
  final TextEditingController experienceController = TextEditingController();

  File? _selectedImage;
   String? _profileImageUrl;
  final double maxImageSize = 5 * 1024 * 1024; // 5 MB in bytes
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final userModel = ref.read(loginProvider);
    // ✅ Fetch user data

    if (userModel.data != null && userModel.data!.isNotEmpty) {
      final user = userModel.data![0].details;
      nameController.text = user?.name ?? "";
      emailController.text = user?.email ?? "";
      phoneController.text = user?.mobile ?? "";
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      final File imageFile = File(image.path);
      final int imageSize = await imageFile.length();
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

  void _showSizeError() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Image Too Large"),
        content: const Text(
            "The selected image exceeds the size limit of 5 MB. Please choose a smaller image."),
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
    // String? role;
    final userModel = ref.read(loginProvider);
    final role = userModel.data?.first.details?.role ?? '';

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.gomedcolor,
        elevation: 0,
        title: Row(
          children: [
            const Text(
              "Profile",
              style:
                  TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.notifications, color: AppColors.white),
              onPressed: () {},
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: AppColors.grey,
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        // Prevents pixel overflow
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
                            : _profileImageUrl != null
                              ? CachedNetworkImageProvider(_profileImageUrl!)
                              : null,
                        child: _selectedImage == null&&_profileImageUrl == null
                            ? const Icon(
                                Icons.person,
                                size: 50,
                                color: AppColors.grey,
                              )
                            : null,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      nameController.text.isNotEmpty
                          ? nameController.text
                          : "User Name",
                      style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold),
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
                      if (role == 'distributor') {
                        try {
                          // Call the updateProfile function
                          await ref.read(loginProvider.notifier).updateProfile(
                              nameController.text,
                              emailController.text,
                              phoneController.text,
                              _selectedImage,
                              ref);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Profile updated successfully!")),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Error updating profile: $e")),
                          );
                        }
                      } else if (role == 'serviceEngineer') {
                        try {
                          // Call the updateProfile function
                          await ref
                              .read(loginProvider.notifier)
                              .updateServiceProfile(
                                nameController.text,
                                emailController.text,
                                phoneController.text,
                                _selectedImage,
                                ref,
                                // experienceController.text
                              );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "serviceEnginner Profile updated successfully!")),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text("Error updating service profile: $e")),
                          );
                        }
                      } else {
                        print('else part executes');
                      }
                    }

                    setState(() {
                      isEditing = !isEditing;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isEditing ? AppColors.gomedcolor : AppColors.info,
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
                      color: AppColors.white,
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
      // bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildProfileField(
      String label, TextEditingController controller, bool isEditing) {
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
            fillColor: isEditing ? AppColors.white : AppColors.grey,
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

}
