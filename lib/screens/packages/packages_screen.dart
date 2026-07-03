import 'package:flutter/material.dart';
import 'package:snapbook/theme/colors.dart';
import 'package:snapbook/screens/home/widgets/main_navigation.dart';

class PackagesScreen extends StatefulWidget {
  final String initialCategory;
  final VoidCallback? onBookingTap;
  const PackagesScreen({super.key, this.initialCategory = 'Semua', this.onBookingTap});

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
  }

  final List<String> _categories = [
    'Semua', 'Populer', 'Personal', 'Graduation', 'Prewedding', 'Produk',
  ];

  final List<Map<String, dynamic>> _packages = [
    {
      'name': 'Personal Basic',
      'category': 'Personal',
      'price': 350000,
      'duration': '1 Jam',
      'includes': ['1 set background', '50 foto edited', 'Fotografer profesional'],
      'seed': 'pkg_personal_basic',
      'popular': false,
    },
    {
      'name': 'Personal Premium',
      'category': 'Personal',
      'price': 550000,
      'duration': '2 Jam',
      'includes': ['3 set background', '100 foto edited', 'Fotografer profesional', 'Makeup artist'],
      'seed': 'pkg_personal_premium',
      'popular': true,
    },
    {
      'name': 'Graduation Standard',
      'category': 'Graduation',
      'price': 450000,
      'duration': '1.5 Jam',
      'includes': ['2 set background', '75 foto edited', 'Toga tersedia', 'Fotografer profesional'],
      'seed': 'pkg_graduation_std',
      'popular': false,
    },
    {
      'name': 'Graduation Deluxe',
      'category': 'Graduation',
      'price': 700000,
      'duration': '3 Jam',
      'includes': ['5 set background', '150 foto edited', 'Toga tersedia', 'Fotografer profesional', 'Cetak foto 4R'],
      'seed': 'pkg_graduation_dlx',
      'popular': true,
    },
    {
      'name': 'Prewedding Romantic',
      'category': 'Prewedding',
      'price': 1200000,
      'duration': '3 Jam',
      'includes': ['4 set background', '120 foto edited', 'Fotografer profesional', 'Makeup artist', 'Dekorasi bunga'],
      'seed': 'pkg_prewedding_rom',
      'popular': false,
    },
    {
      'name': 'Prewedding Luxury',
      'category': 'Prewedding',
      'price': 1800000,
      'duration': '5 Jam',
      'includes': ['Semua background', '200 foto edited', '2 Fotografer', 'Makeup artist', 'Dekorasi premium', 'Video highlight'],
      'seed': 'pkg_prewedding_lux',
      'popular': true,
    },
    {
      'name': 'Product Photography',
      'category': 'Produk',
      'price': 500000,
      'duration': '2 Jam',
      'includes': ['Studio putih/hitam', '80 foto edited', 'Lighting profesional', 'Props tersedia'],
      'seed': 'pkg_product',
      'popular': false,
    },
  ];

  String _rupiah(int harga) => 'Rp ${harga.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
  )}';

  List<Map<String, dynamic>> get _filtered {
    if (_selectedCategory == 'Semua') return _packages;
    if (_selectedCategory == 'Populer') return _packages.where((p) => p['popular'] == true).toList();
    return _packages.where((p) => p['category'] == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Paket & Layanan',
            style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppColors.black),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.lightGrey, height: 1),
        ),
      ),
      body: Column(
        children: [
          // ── Category filter ──────────────────────────────────
          SizedBox(
            height: 52,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: _categories.length,
              itemBuilder: (_, i) {
                final isActive = _selectedCategory == _categories[i];
                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedCategory = _categories[i]),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.black : AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Text(
                      _categories[i],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isActive ? Colors.white : AppColors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ── Package list ─────────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              itemCount: _filtered.length,
              itemBuilder: (_, i) {
                final pkg = _filtered[i];
                return _PackageCard(
                  pkg: pkg,
                  rupiah: _rupiah(pkg['price'] as int),
                  onBook: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                    widget.onBookingTap?.call();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  final Map<String, dynamic> pkg;
  final String rupiah;
  final VoidCallback onBook;

  const _PackageCard(
      {required this.pkg, required this.rupiah, required this.onBook});

  @override
  Widget build(BuildContext context) {
    final isPopular = pkg['popular'] as bool;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: isPopular
            ? Border.all(color: AppColors.primary, width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Photo
          SizedBox(
            height: 130,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/${pkg['seed']}.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: AppColors.background),
                ),
                if (isPopular)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('Terpopuler',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.black)),
                    ),
                  ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.access_time_outlined,
                            size: 11, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(pkg['duration'] as String,
                            style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(pkg['name'] as String,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black)),
                    Text(rupiah,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.black)),
                  ],
                ),
                const SizedBox(height: 10),
                // Includes
                ...(pkg['includes'] as List<String>).map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(children: [
                    Container(
                      width: 5, height: 5,
                      margin: const EdgeInsets.only(right: 8, top: 1),
                      decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle),
                    ),
                    Text(item,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.grey)),
                  ]),
                )),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onBook,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.black,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Booking Paket Ini',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}