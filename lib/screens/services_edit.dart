import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ServicesPageEdit extends StatefulWidget {
  const ServicesPageEdit({super.key});

  @override
  _ServicesPageEditState createState() => _ServicesPageEditState();
}

class _ServicesPageEditState extends State<ServicesPageEdit> {
  final TextEditingController serviceController = TextEditingController(text: "Full PBody Checkup");
  final TextEditingController durationController = TextEditingController(text: "60");
  final TextEditingController priceController = TextEditingController(text: "₹1500");
  final TextEditingController amTimeController = TextEditingController(text: "00");
  final TextEditingController pmTimeController = TextEditingController(text: "00");
  final TextEditingController dateController = TextEditingController();

  String selectedStatus = "Active";
  String selectedFrequency = "Daily";

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        dateController.text = DateFormat('EEEE, MMM d, yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  const Color(0xFFE8F7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6BC37A),
        title: const Text("Services"),
        leading: const Icon(Icons.arrow_back),
        actions: const [
          Icon(Icons.notifications),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Add/ Edit services",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                buildLabel("Service : "),
                TextFormField(
                  controller: serviceController,
                  decoration: buildInputDecoration(),
                ),
                const SizedBox(height: 10),
                buildLabel("Duration : "),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: durationController,
                        decoration: buildInputDecoration(),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text("mins"),
                  ],
                ),
                const SizedBox(height: 10),
                buildLabel("Price : "),
                TextFormField(
                  controller: priceController,
                  decoration: buildInputDecoration(),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                buildLabel("Time"),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: amTimeController,
                        decoration: buildInputDecoration(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text("AM"),
                    const Spacer(),
                    Expanded(
                      child: TextFormField(
                        controller: pmTimeController,
                        decoration: buildInputDecoration(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text("PM"),
                  ],
                ),
                const SizedBox(height: 20),
                buildLabel("Date"),
                TextFormField(
                  controller: dateController,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  decoration: buildInputDecoration().copyWith(
                    hintText: 'Select Date',
                    suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),
                buildLabel("Frequency"),
                Wrap(
                  spacing: 10,
                  children: [
                    buildFrequencyButton("Daily"),
                    buildFrequencyButton("Alternate"),
                    buildFrequencyButton("Weekly"),
                    buildFrequencyButton("Custom"),
                  ],
                ),
                const SizedBox(height: 10),
                buildLabel("Status : "),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  items: <String>['Active', 'Inactive']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedStatus = newValue ?? selectedStatus;
                    });
                  },
                  decoration: buildInputDecoration(),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Submit form data
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1BA4CA),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: const Text("Submit"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Product',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.brown[300],
      ),
    );
  }

  Widget buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  InputDecoration buildInputDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget buildFrequencyButton(String text) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedFrequency = text;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedFrequency == text ? const Color(0xFF1BA4CA) : Colors.grey[200],
        foregroundColor: selectedFrequency == text ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
      ),
      child: Text(text),
    );
  }
}
