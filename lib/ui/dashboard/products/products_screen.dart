import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../services/api_service.dart';


class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List brands = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadBrands();
  }

  void loadBrands() async {
    final data = await ApiService.fetchBrands();
    setState(() {
      brands = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: Text("Products", style: GoogleFonts.poppins()),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search bar (UI only for now)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 20)
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: "Search brand or product...",
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Live brand list
            Expanded(
              child: ListView.builder(
                itemCount: brands.length,
                itemBuilder: (context, index) {
                  final brand = brands[index];
                  return BrandCard(brand["name"]);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BrandCard extends StatelessWidget {
  final String name;
  const BrandCard(this.name, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.storefront, color: Color(0xFF6A5AE0), size: 28),
          const SizedBox(width: 16),
          Text(name, style: GoogleFonts.poppins(fontSize: 17)),
        ],
      ),
    ).animate().fade().slideX();
  }
}
