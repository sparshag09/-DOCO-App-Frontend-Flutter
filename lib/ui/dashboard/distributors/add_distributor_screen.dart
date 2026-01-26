import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddDistributorScreen extends StatefulWidget {
  const AddDistributorScreen({super.key});

  @override
  State<AddDistributorScreen> createState() => _AddDistributorScreenState();
}

class _AddDistributorScreenState extends State<AddDistributorScreen> {
  final _formKey = GlobalKey<FormState>();

  Widget _field(String label, String hint, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        validator: required ? (v) => v!.isEmpty ? 'Required' : null : null,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget _rowField(String label1, String hint1, String label2, String hint2) {
    return Row(
      children: [
        Expanded(child: _field(label1, hint1)),
        const SizedBox(width: 12),
        Expanded(child: _field(label2, hint2)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(title: const Text("Add Distributor")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [

            _field("Business Name", "Enter your business name", required: true),
            _field("Contact Person", "Enter contact person name", required: true),
            _field("Phone Number", "Enter phone number", required: true),
            _field("GST Number", "Enter your business GST number"),
            _field("PAN Number", "Enter PAN number"),
            _field("Email ID", "Enter email"),

            _rowField("Credit Amount", "i.e. 50000", "Credit Cycle", "i.e. 15 days"),
            _field("Due Bills", "i.e. 2"),

            const SizedBox(height: 10),
            _field("House / Building", "House no / Building name", required: true),
            _field("Street / Area", "Street name / Area", required: true),
            _rowField("City", "City", "State", "State"),
            _field("Pin Code", "Pin code", required: true),

            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                backgroundColor: const Color(0xFF6A5AE0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(context);
                }
              },
              child: const Text("Save Distributor"),
            ),
          ]),
        ),
      ),
    );
  }
}
