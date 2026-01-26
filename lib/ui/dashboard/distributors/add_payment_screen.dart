import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddPaymentScreen extends StatefulWidget {
  const AddPaymentScreen({super.key});

  @override
  State<AddPaymentScreen> createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  String paymentMode = "Cash";
  DateTime selectedDate = DateTime.now();

  String get formattedDate =>
      DateFormat("dd MMM yyyy").format(selectedDate);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text("Add Payment"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// AMOUNT
            _inputField(
              controller: amountController,
              label: "Payment Amount",
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 14),

            /// PAYMENT MODE
            DropdownButtonFormField<String>(
              value: paymentMode,
              items: const [
                DropdownMenuItem(value: "Cash", child: Text("Cash")),
                DropdownMenuItem(value: "UPI", child: Text("UPI")),
                DropdownMenuItem(
                    value: "Bank Transfer", child: Text("Bank Transfer")),
                DropdownMenuItem(value: "Cheque", child: Text("Cheque")),
              ],
              onChanged: (val) {
                setState(() {
                  paymentMode = val!;
                });
              },
              decoration: _inputDecoration("Payment Mode"),
            ),

            const SizedBox(height: 14),

            /// DATE PICKER
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Payment Date",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    Text(
                      formattedDate,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            /// NOTE
            _inputField(
              controller: noteController,
              label: "Note (optional)",
            ),

            const Spacer(),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _savePayment,
                child: const Text("Save Payment"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ----------------------------
  /// PICK DATE
  /// ----------------------------
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  /// ----------------------------
  /// SAVE PAYMENT
  /// ----------------------------
  void _savePayment() {
    final amount = double.tryParse(amountController.text);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid amount")),
      );
      return;
    }

    Navigator.pop(context, {
      "amount": amount,
      "mode": paymentMode,
      "date": formattedDate,
      "note": noteController.text.isEmpty
          ? "Payment ($paymentMode)"
          : noteController.text,
    });
  }

  /// ----------------------------
  /// INPUT HELPERS
  /// ----------------------------
  Widget _inputField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _inputDecoration(label),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}
