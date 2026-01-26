import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:doco_store/data/payment_store.dart';

/// ----------------------------
/// PAYMENT HISTORY SCREEN
/// ----------------------------
class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  DateTimeRange? selectedRange;
  String selectedMode = "All";

  /// ----------------------------
  /// FILTER LOGIC
  /// ----------------------------
  List<PaymentRecord> get filteredPayments {
    return PaymentStore.payments.where((p) {
      final matchMode =
          selectedMode == "All" || p.mode == selectedMode;

      final matchDate = selectedRange == null ||
          (p.dateTime.isAfter(selectedRange!.start) &&
              p.dateTime.isBefore(selectedRange!.end));

      return matchMode && matchDate;
    }).toList();
  }

  double get totalAmount {
    return filteredPayments.fold(
      0,
          (sum, item) => sum + item.amount,
    );
  }

  /// ----------------------------
  /// UI
  /// ----------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: Text(
          "Payment History",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _filters(context),
            const SizedBox(height: 12),
            _summaryCard(),
            const SizedBox(height: 12),
            Expanded(child: _paymentList()),
          ],
        ),
      ),
    );
  }

  /// ----------------------------
  /// FILTER WIDGET
  /// ----------------------------
  Widget _filters(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.date_range),
            label: Text(
              selectedRange == null
                  ? "Select Date"
                  : "${selectedRange!.start.day}/${selectedRange!.start.month} - "
                  "${selectedRange!.end.day}/${selectedRange!.end.month}",
            ),
            onPressed: () async {
              final range = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2024),
                lastDate: DateTime.now(),
              );

              if (range != null) {
                setState(() => selectedRange = range);
              }
            },
          ),
        ),
        const SizedBox(width: 10),
        DropdownButton<String>(
          value: selectedMode,
          items: ["All", "Cash", "UPI", "Bank"]
              .map(
                (e) => DropdownMenuItem(
              value: e,
              child: Text(e),
            ),
          )
              .toList(),
          onChanged: (v) => setState(() => selectedMode = v!),
        ),
      ],
    );
  }

  /// ----------------------------
  /// SUMMARY CARD
  /// ----------------------------
  Widget _summaryCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total Received",
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            Text(
              "₹${totalAmount.toStringAsFixed(0)}",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ----------------------------
  /// PAYMENT LIST
  /// ----------------------------
  Widget _paymentList() {
    if (filteredPayments.isEmpty) {
      return const Center(child: Text("No payments found"));
    }

    return ListView.builder(
      itemCount: filteredPayments.length,
      itemBuilder: (context, index) {
        final p = filteredPayments[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: ListTile(
            leading: const Icon(Icons.payments, color: Colors.green),
            title: Text(p.distributor),
            subtitle: Text(
              "${p.mode} • "
                  "${p.dateTime.day}/${p.dateTime.month} "
                  "${p.dateTime.hour}:${p.dateTime.minute.toString().padLeft(2, '0')}",
            ),
            trailing: Text(
              "₹${p.amount.toStringAsFixed(0)}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        );
      },
    );
  }
}
