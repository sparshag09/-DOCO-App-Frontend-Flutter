import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DistributorsScreen extends StatefulWidget {
  const DistributorsScreen({super.key});

  @override
  State<DistributorsScreen> createState() => _DistributorsScreenState();
}

class _DistributorsScreenState extends State<DistributorsScreen> {
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> distributors = [
    {"name": "Ramesh Traders", "pending": 4500, "orders": 12},
    {"name": "Mahesh Wholesales", "pending": 1200, "orders": 4},
    {"name": "CityMart Supplies", "pending": 7800, "orders": 18},
  ];

  List<Map<String, dynamic>> filtered = [];

  @override
  void initState() {
    super.initState();
    filtered = distributors;
  }

  void search(String value) {
    setState(() {
      filtered = distributors
          .where((d) =>
          d["name"].toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  void addDistributor() {
    showDialog(
      context: context,
      builder: (_) {
        final nameCtrl = TextEditingController();
        return AlertDialog(
          title: Text("Add Distributor", style: GoogleFonts.poppins()),
          content: TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(hintText: "Distributor name"),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  distributors.add({
                    "name": nameCtrl.text,
                    "pending": 0,
                    "orders": 0,
                  });
                  filtered = distributors;
                });
                Navigator.pop(context);
              },
              child: const Text("Add"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: Text("Distributors", style: GoogleFonts.poppins()),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ADD + SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: addDistributor,
                  icon: const Icon(Icons.add),
                  label: const Text("Add New"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A5AE0)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: search,
                    decoration: InputDecoration(
                      hintText: "Search distributor...",
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
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final d = filtered[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(d["name"],
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600)),
                          Text("Orders: ${d["orders"]}",
                              style: GoogleFonts.poppins(color: Colors.grey)),
                        ],
                      ),
                      Column(
                        children: [
                          Text("₹${d["pending"]}",
                              style: GoogleFonts.poppins(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w600)),
                          const Text("Pending"),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
