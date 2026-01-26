import 'package:flutter/material.dart';
import 'add_order_screen.dart';
import 'add_payment_screen.dart';
import 'package:doco_store/data/payment_store.dart';

/// ----------------------------
/// LEDGER MODEL
/// ----------------------------
class LedgerEntry {
  final String type; // ORDER or PAYMENT
  final double amount;
  final String date;
  final String note;

  LedgerEntry({
    required this.type,
    required this.amount,
    required this.date,
    required this.note,
  });
}

/// ----------------------------
/// DISTRIBUTOR PROFILE SCREEN
/// ----------------------------
class DistributorProfileScreen extends StatefulWidget {
  final Map distributor;

  const DistributorProfileScreen({super.key, required this.distributor});

  @override
  State<DistributorProfileScreen> createState() =>
      _DistributorProfileScreenState();
}

class _DistributorProfileScreenState extends State<DistributorProfileScreen> {
  /// TEMP LOCAL LEDGER DATA
  final List<LedgerEntry> ledger = [
    LedgerEntry(
      type: "ORDER",
      amount: 8500,
      date: "01 Jan 2024",
      note: "Order #1023",
    ),
    LedgerEntry(
      type: "PAYMENT",
      amount: 3000,
      date: "03 Jan 2024",
      note: "Cash Payment",
    ),
    LedgerEntry(
      type: "ORDER",
      amount: 12000,
      date: "05 Jan 2024",
      note: "Order #1024",
    ),
  ];

  /// ----------------------------
  /// CALCULATE PENDING AMOUNT
  /// ----------------------------
  double calculatePending() {
    double pending = 0;
    for (var entry in ledger) {
      if (entry.type == "ORDER") {
        pending += entry.amount;
      } else {
        pending -= entry.amount;
      }
    }
    return pending;
  }

  @override
  Widget build(BuildContext context) {
    final double creditLimit =
        (widget.distributor['credit_limit'] as num?)?.toDouble() ?? 0.0;

    final double pending = calculatePending();
    final double available = creditLimit - pending;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: Text(widget.distributor['business_name'] ?? "Distributor"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _infoCard(widget.distributor),
            const SizedBox(height: 10),
            _balanceCard(pending, creditLimit, available),
            const SizedBox(height: 12),

            /// ACTION BUTTONS
            Row(
              children: [
                _actionBtn(
                  "Add Order",
                  Icons.shopping_cart,
                  Colors.indigo,
                  _addOrder,
                ),
                const SizedBox(width: 10),
                _actionBtn(
                  "Add Payment",
                  Icons.payments,
                  Colors.green,
                  _addPayment,
                ),
              ],
            ),

            const SizedBox(height: 15),
            Expanded(child: _ledgerList()),
          ],
        ),
      ),
    );
  }

  /// ----------------------------
  /// ADD ORDER FLOW
  /// ----------------------------
  Future<void> _addOrder() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddOrderScreen()),
    );

    if (result != null) {
      setState(() {
        ledger.add(
          LedgerEntry(
            type: "ORDER",
            amount: result["total"],
            date: result["date"] ?? "Today",
            note: "Order (${result["brand"]["name"]})",
          ),
        );
      });
    }
  }

  /// ----------------------------
  /// ADD PAYMENT FLOW (SYNCED)
  /// ----------------------------
  Future<void> _addPayment() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddPaymentScreen()),
    );

    if (result != null) {
      final payment = PaymentRecord(
        distributor: widget.distributor['business_name'],
        amount: result["amount"],
        mode: result["mode"],
        dateTime: result["dateTime"],
        note: result["note"],
      );

      setState(() {
        /// LOCAL LEDGER
        ledger.add(
          LedgerEntry(
            type: "PAYMENT",
            amount: payment.amount,
            date: result["date"],
            note: payment.note,
          ),
        );
      });

      /// 🔥 GLOBAL PAYMENT HISTORY
      PaymentStore.payments.add(payment);
    }
  }

  /// ----------------------------
  /// INFO CARD
  /// ----------------------------
  Widget _infoCard(Map d) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        title: Text(
          d['business_name'] ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("${d['owner'] ?? ''} • ${d['phone'] ?? ''}"),
      ),
    );
  }

  /// ----------------------------
  /// BALANCE CARD
  /// ----------------------------
  Widget _balanceCard(double pending, double limit, double available) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _row("Pending", pending, color: Colors.red),
            _row("Credit Limit", limit),
            const Divider(),
            _row("Available", available, color: Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _row(String title, double val, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            "₹${val.toStringAsFixed(2)}",
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// ----------------------------
  /// ACTION BUTTON
  /// ----------------------------
  Widget _actionBtn(
      String text,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return Expanded(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.all(14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Icon(icon),
        label: Text(text),
        onPressed: onTap,
      ),
    );
  }

  /// ----------------------------
  /// LEDGER LIST
  /// ----------------------------
  Widget _ledgerList() {
    return ListView.builder(
      itemCount: ledger.length,
      itemBuilder: (context, index) {
        final e = ledger[index];
        final isOrder = e.type == "ORDER";

        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: Icon(
              isOrder ? Icons.shopping_cart : Icons.payments,
              color: isOrder ? Colors.red : Colors.green,
            ),
            title: Text(e.note),
            subtitle: Text(e.date),
            trailing: Text(
              "${isOrder ? '+' : '-'} ₹${e.amount.toStringAsFixed(0)}",
              style: TextStyle(
                color: isOrder ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
