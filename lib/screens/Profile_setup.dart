import 'package:flutter/material.dart';
import 'package:go_med/screens/BottomNavBar.dart';

class ProfileSetupPage extends StatelessWidget {
  const ProfileSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    var role;
    return Scaffold(
      backgroundColor:  const Color(0xFFE8F7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6BC37A),
        elevation: 0,
        title: Row(
          children: [
            const Text("Profile setup", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.white,
            height: 1.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Business Information Section", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("2/5 Complete", style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 10),
            const Text("Business Name:"),
            const TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(filled: true, fillColor: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text("Phone Number :"),
            const TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(filled: true, fillColor: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text("Email :"),
            const TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(filled: true, fillColor: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text("Operating Hours:"),
            const Row(
              children: [
                Flexible(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(filled: true, fillColor: Colors.white),
                  ),
                ),
                SizedBox(width: 5),
                Text(":"),
                SizedBox(width: 5),
                Flexible(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(filled: true, fillColor: Colors.white),
                  ),
                ),
                SizedBox(width: 10),
                Text("AM"),
                SizedBox(width: 20),
                Flexible(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(filled: true, fillColor: Colors.white),
                  ),
                ),
                SizedBox(width: 5),
                Text(":"),
                SizedBox(width: 5),
                Flexible(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(filled: true, fillColor: Colors.white),
                  ),
                ),
                SizedBox(width: 10),
                Text("PM"),
              ],
            ),
            const SizedBox(height: 10),
            const Text("Upload Image"),
            const TextField(
              decoration: InputDecoration(
                hintText: "Image size is 500px X 500 px",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text("Description"),
            const TextField(
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: "Description of store",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text("Location"),
            const TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "Search location",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text("Social Media Profiles"),
            const SizedBox(height: 5),
            const TextField(
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                hintText: "Twitter",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            const TextField(
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                hintText: "Instagram",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            const TextField(
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                hintText: "Facebook",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            const TextField(
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                hintText: "Others",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text("Verification Section :"),
            Row(
              children: [
                const Text("Submit ID Proof for Verification:", style: TextStyle(color: Colors.black54)),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    // Upload action
                  },
                  child: const Text("upload", style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Text(
              "Please upload a government-issued ID for verification.\nVerification will take 24-48 hours.",
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
            const SizedBox(height: 10),
            const Text("Payment Method:"),
            const Text("Bank Details", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            const TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "Bank Name",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            const TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Acc. number",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            const TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "IFSC",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text("UPI"),
            const TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "UPI ID",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0x801BA4CA),
                ),
                onPressed: () {
                  // Save/Verify action
                },
                child: const Text(
                  "Save/ Verify Business",
                  style: TextStyle(
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
      // bottomNavigationBar:  BottomNavBar(currentIndex: (role == "serviceEngineer") ? 3 : 1,),
    );
  }
}
