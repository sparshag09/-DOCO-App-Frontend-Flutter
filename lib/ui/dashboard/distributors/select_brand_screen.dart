import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectBrandScreen extends StatefulWidget {
  const SelectBrandScreen({super.key});

  @override
  State<SelectBrandScreen> createState() => _SelectBrandScreenState();
}

class _SelectBrandScreenState extends State<SelectBrandScreen> {
  final TextEditingController searchController = TextEditingController();

  /// TEMP BRAND DATA
  final List<Map<String, dynamic>> brands = [
    {"id": 1, "name": "ITC"},
    {"id": 2, "name": "HUL"},
    {"id": 3, "name": "Tata"},
    {"id": 4, "name": "Patanjali"},
    {"id": 5, "name": "Nestle"},
  ];

  List<Map<String, dynamic>> filtered = [];

  @override
  void initState() {
    super.initState();
    filtered = brands;
  }

  void search(String value) {
    setState(() {
      filtered = brands
          .where((b) =>
          b['name'].toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: Text(
          "Select Brand",
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
                hintText: "Search brand...",
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

          /// BRAND LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final brand = filtered[index];

                return GestureDetector(
                  onTap: () {
                    /// ✅ RETURN SELECTED BRAND
                    Navigator.pop(context, brand);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(18),
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
                        Text(
                          brand['name'],
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
