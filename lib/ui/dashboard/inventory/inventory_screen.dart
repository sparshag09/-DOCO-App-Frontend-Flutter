import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> allItems = [
    {"name": "Coca Cola 250ml", "brand": "Coca Cola", "stock": 120},
    {"name": "Coca Cola 500ml", "brand": "Coca Cola", "stock": 30},
    {"name": "Pepsi 250ml", "brand": "Pepsi", "stock": 20},
    {"name": "Sprite 250ml", "brand": "Sprite", "stock": 10},
    {"name": "Fanta 250ml", "brand": "Fanta", "stock": 90},
  ];

  List<Map<String, dynamic>> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = allItems;
  }

  void search(String query) {
    setState(() {
      filteredItems = allItems
          .where((item) =>
      item["name"].toLowerCase().contains(query.toLowerCase()) ||
          item["brand"].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void editStock(Map<String, dynamic> item) {
    final controller = TextEditingController(text: item["stock"].toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit Stock", style: GoogleFonts.poppins()),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                item["stock"] = int.parse(controller.text);
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Group items by brand
    Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var item in filteredItems) {
      grouped.putIfAbsent(item["brand"], () => []).add(item);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: Text("Inventory", style: GoogleFonts.poppins()),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: search,
              decoration: InputDecoration(
                hintText: "Search product or brand...",
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

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: grouped.entries.map((entry) {
                final brand = entry.key;
                final items = entry.value;

                return ExpansionTile(
                  title: Text(brand,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  children: items.map((item) {
                    final lowStock = item["stock"] < 25;

                    return ListTile(
                      onTap: () => editStock(item),
                      title: Text(item["name"], style: GoogleFonts.poppins()),
                      trailing: Chip(
                        backgroundColor: lowStock
                            ? Colors.red.shade100
                            : Colors.green.shade100,
                        label: Text("Stock: ${item["stock"]}",
                            style: TextStyle(
                                color: lowStock ? Colors.red : Colors.green)),
                      ),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
