import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectProductsScreen extends StatefulWidget {
  final Map brand;

  const SelectProductsScreen({super.key, required this.brand});

  @override
  State<SelectProductsScreen> createState() => _SelectProductsScreenState();
}

class _SelectProductsScreenState extends State<SelectProductsScreen> {
  final TextEditingController searchController = TextEditingController();

  /// TEMP PRODUCT DATA (brand-wise)
  final List<Map<String, dynamic>> allProducts = [
    {"id": 1, "brand": "ITC", "name": "Aashirvaad Atta", "price": 350},
    {"id": 2, "brand": "ITC", "name": "Sunfeast Biscuit", "price": 30},
    {"id": 3, "brand": "HUL", "name": "Surf Excel", "price": 120},
    {"id": 4, "brand": "HUL", "name": "Lux Soap", "price": 45},
    {"id": 5, "brand": "Tata", "name": "Tata Salt", "price": 28},
    {"id": 6, "brand": "Nestle", "name": "Maggi", "price": 14},
  ];

  late List<Map<String, dynamic>> filteredProducts;

  /// CART: productId → qty
  final Map<int, int> cart = {};

  @override
  void initState() {
    super.initState();

    /// Filter products by selected brand
    filteredProducts = allProducts
        .where((p) => p["brand"] == widget.brand["name"])
        .toList();
  }

  void search(String value) {
    setState(() {
      filteredProducts = allProducts
          .where((p) =>
      p["brand"] == widget.brand["name"] &&
          p["name"].toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  int get totalItems =>
      cart.values.fold(0, (sum, qty) => sum + qty);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: Text(
          widget.brand["name"],
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          /// SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: search,
              decoration: InputDecoration(
                hintText: "Search product...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          /// PRODUCT LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                final qty = cart[product["id"]] ?? 0;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// PRODUCT INFO
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product["name"],
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "₹${product["price"]}",
                            style: GoogleFonts.poppins(color: Colors.grey),
                          ),
                        ],
                      ),

                      /// QTY CONTROLS
                      Row(
                        children: [
                          _qtyBtn(
                            icon: Icons.remove,
                            onTap: () => _decrease(product["id"]),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              qty.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          _qtyBtn(
                            icon: Icons.add,
                            onTap: () => _increase(product["id"]),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          /// BOTTOM BAR
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
                  "Items: $totalItems",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: totalItems == 0 ? null : _confirmSelection,
                  child: const Text("Add to Cart"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ----------------------------
  /// QUANTITY HANDLERS
  /// ----------------------------
  void _increase(int productId) {
    setState(() {
      cart[productId] = (cart[productId] ?? 0) + 1;
    });
  }

  void _decrease(int productId) {
    setState(() {
      if (cart[productId] != null && cart[productId]! > 0) {
        cart[productId] = cart[productId]! - 1;
        if (cart[productId] == 0) {
          cart.remove(productId);
        }
      }
    });
  }

  /// ----------------------------
  /// RETURN SELECTED PRODUCTS
  /// ----------------------------
  void _confirmSelection() {
    final selectedProducts = [];

    for (var p in allProducts) {
      if (cart.containsKey(p["id"])) {
        selectedProducts.add({
          "id": p["id"],
          "name": p["name"],
          "price": p["price"],
          "qty": cart[p["id"]],
        });
      }
    }

    Navigator.pop(context, selectedProducts);
  }

  Widget _qtyBtn({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xFF6A5AE0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}
