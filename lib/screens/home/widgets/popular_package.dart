import 'package:flutter/material.dart';
import 'package:snapbook/theme/colors.dart';
import 'package:snapbook/screens/packages/packages_screen.dart';

class PopularPackage extends StatelessWidget {
  final VoidCallback? onBookingTap;
  const PopularPackage({super.key, this.onBookingTap});

  String _rupiah(int harga) => 'Rp ${harga.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
  )}';

  @override
  Widget build(BuildContext context) {
    // Paket yang popular: true — konsisten sama packages_screen.dart
    final List<Map<String, dynamic>> packages = [
      {
        'title': 'Personal\nPremium',
        'price': 550000,
        'seed': 'pkg_personal_premium',
      },
      {
        'title': 'Graduation\nDeluxe',
        'price': 700000,
        'seed': 'pkg_graduation_dlx',
      },
      {
        'title': 'Prewedding\nLuxury',
        'price': 1800000,
        'seed': 'pkg_prewedding_lux',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Paket Populer',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => PackagesScreen(initialCategory: 'Populer', onBookingTap: onBookingTap)),
                  ),
                  child: Row(
                    children: const [
                      Text('Lihat Semua',
                          style:
                          TextStyle(fontSize: 13, color: AppColors.grey)),
                      SizedBox(width: 2),
                      Icon(Icons.chevron_right,
                          color: AppColors.grey, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Horizontal scroll
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: packages.length,
              itemBuilder: (context, index) {
                final pkg = packages[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => PackagesScreen(initialCategory: 'Populer', onBookingTap: onBookingTap)),
                  ),
                  child: Container(
                    width: 185,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        // Photo
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/images/${pkg['seed']}.jpg',
                            width: 68,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 68,
                              height: 80,
                              color: AppColors.lightGrey,
                              child: const Icon(Icons.image_outlined,
                                  color: AppColors.grey, size: 20),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                pkg['title']! as String,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text('Mulai dari',
                                  style: TextStyle(
                                      fontSize: 10, color: AppColors.grey)),
                              Text(
                                _rupiah(pkg['price'] as int),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
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