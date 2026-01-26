import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'products/products_screen.dart';
import 'inventory/inventory_screen.dart';
import 'distributors/distributors_screen.dart';
import 'payments/payment_history_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: Text(
          "DOCO Dashboard",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _card(
              context,
              Icons.inventory_2,
              "Products",
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProductsScreen(),
                  ),
                );
              },
            ),

            _card(
              context,
              Icons.warehouse,
              "Inventory",
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const InventoryScreen(),
                  ),
                );
              },
            ),

            _card(
              context,
              Icons.group,
              "Distributors",
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DistributorsScreen(),
                  ),
                );
              },
            ),

            /// 🔥 UPDATED CARD
            _card(
              context,
              Icons.payments,
              "Payment History",
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PaymentHistoryScreen(),
                  ),
                );
              },
            ),

            _card(
              context,
              Icons.shopping_cart,
              "Hawker Orders",
                  () {},
            ),

            _card(
              context,
              Icons.store,
              "Retailer Orders",
                  () {},
            ),

            _card(
              context,
              Icons.receipt_long,
              "Orders History",
                  () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(
      BuildContext context,
      IconData icon,
      String title,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 30, color: const Color(0xFF6A5AE0)),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.poppins(fontSize: 17),
            ),
          ],
        ),
      ).animate().fade().slideX(),
    );
  }
}
