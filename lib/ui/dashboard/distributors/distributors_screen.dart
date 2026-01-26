import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'add_distributor_screen.dart';
import 'distributor_profile_screen.dart';

class DistributorsScreen extends StatefulWidget {
  const DistributorsScreen({super.key});

  @override
  State<DistributorsScreen> createState() => _DistributorsScreenState();
}

class _DistributorsScreenState extends State<DistributorsScreen> {
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> distributors = [
    {
      "business_name": "Ramesh Traders",
      "owner": "Ramesh Patel",
      "phone": "9876543210",
      "credit_limit": 100000,
      "pending": 4500,
      "orders": 12
    },
    {
      "business_name": "Mahesh Wholesales",
      "owner": "Mahesh Shah",
      "phone": "9123456780",
      "credit_limit": 50000,
      "pending": 1200,
      "orders": 4
    },
    {
      "business_name": "CityMart Supplies",
      "owner": "Amit Verma",
      "phone": "9988776655",
      "credit_limit": 150000,
      "pending": 7800,
      "orders": 18
    },
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
          d["business_name"].toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  void addDistributor() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddDistributorScreen()),
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
                      backgroundColor: const Color(0xFF7163B4)),
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

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DistributorProfileScreen(distributor: d),
                      ),
                    );
                  },
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
                            offset: Offset(0, 10))
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(d["business_name"],
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
