import 'package:flutter/material.dart';
import 'select_brand_screen.dart';


class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({super.key});

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  String? selectedBrand;
  final List<Map<String, dynamic>> cart = [];

  double get totalAmount {
    double total = 0;
    for (var item in cart) {
      total += item['price'] * item['qty'];
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text("Create Order"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // SELECT BRAND
          Padding(
            padding: const EdgeInsets.all(16),
            child: ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              title: Text(
                selectedBrand ?? "Select Brand",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _selectBrand,
            ),
          ),

          // CART AREA
          Expanded(
            child: cart.isEmpty
                ? const Center(
              child: Text(
                "No products added",
                style: TextStyle(color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart[index];
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text("Qty: ${item['qty']}"),
                  trailing: Text(
                    "₹${item['price'] * item['qty']}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),

          // BOTTOM BAR
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 10),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total: ₹${totalAmount.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: cart.isEmpty ? null : _placeOrder,
                  child: const Text("Place Order"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// ----------------------------
  /// SELECT BRAND
  /// ----------------------------
  Future<void> _selectBrand() async {
    final brand = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SelectBrandScreen()),
    );

    if (brand != null) {
      setState(() {
        selectedBrand = brand;
        cart.clear(); // reset cart when brand changes
      });
    }
  }

  /// ----------------------------
  /// PLACE ORDER
  /// ----------------------------
  void _placeOrder() {
    Navigator.pop(context, {
      "brand": selectedBrand,
      "items": cart,
      "total": totalAmount,
    });
  }
}
