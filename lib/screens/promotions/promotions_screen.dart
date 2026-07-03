import 'package:flutter/material.dart';
import 'package:snapbook/theme/colors.dart';
import 'package:snapbook/screens/promotions/promotion_detail_screen.dart';

class PromotionsScreen extends StatelessWidget {
  const PromotionsScreen({super.key});

  static final List<Map<String, String>> promos = [
    {
      'title': 'Graduation Special',
      'discount': '20% Off',
      'tag': 'Graduation',
      'period': '1 Jun – 30 Jun 2025',
      'seed': 'promotions_page_1',
      'packageName': 'Graduation Deluxe',
      'description':
      'Rayakan momen wisuda kamu dengan sesi foto terbaik! Dapatkan diskon 20% untuk semua paket Graduation pada sesi hari kerja. Tersedia background eksklusif dan toga yang bisa kamu gunakan secara gratis selama sesi berlangsung.',
    },
    {
      'title': 'Prewedding Deal',
      'discount': 'Hemat Rp 100.000',
      'tag': 'Prewedding',
      'period': '15 Jun – 15 Jul 2025',
      'seed': 'promotions_page_2',
      'packageName': 'Prewedding Romantic',
      'description':
      'Abadikan momen sebelum hari spesial kamu dengan penghematan ekstra. Booking paket Prewedding Romantic dan hemat Rp 100.000 plus dapat 2 foto edited tambahan secara gratis sebagai kenangan berharga.',
    },
    {
      'title': 'Member Exclusive',
      'discount': '15% Off',
      'tag': 'Semua Paket',
      'period': 'Sepanjang Juli 2025',
      'seed': 'promotions_page_3',
      'packageName': 'Personal Premium',
      'description':
      'Khusus untuk kamu yang sudah terdaftar di SnapBook! Nikmati diskon 15% untuk paket Personal Premium. Promo ini hanya berlaku bagi member aktif yang sudah melakukan minimal 1 booking sebelumnya.',
    },
    {
      'title': 'Weekend Flash Sale',
      'discount': '25% Off',
      'tag': 'Flash Sale',
      'period': 'Setiap Sabtu–Minggu',
      'seed': 'promotions_page_4',
      'packageName': 'Personal Basic',
      'description':
      'Manfaatkan akhir pekan dengan sesi foto terjangkau! Flash sale 25% off untuk paket Personal Basic setiap Sabtu dan Minggu. Slot terbatas, jadi segera booking sebelum kehabisan.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Promo & Diskon',
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
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
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: promos.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, i) => _PromoCard(promo: promos[i]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// PROMO CARD
// ─────────────────────────────────────────────────────────────────
class _PromoCard extends StatelessWidget {
  final Map<String, String> promo;
  const _PromoCard({required this.promo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PromotionDetailScreen(promo: promo),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Foto ────────────────────────────────────────
            SizedBox(
              height: 140,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/${promo['seed']}.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: AppColors.background),
                  ),
                  // Gradient bawah
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.45),
                        ],
                      ),
                    ),
                  ),
                  // Tag + discount
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
                      child: Text(
                        promo['tag']!,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        promo['discount']!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Info ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    promo['title']!,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 11, color: AppColors.grey),
                      const SizedBox(width: 4),
                      Text(
                        promo['period']!,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    promo['description']!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.grey,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Paket terkait + tombol klaim
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.inventory_2_outlined,
                                size: 12, color: AppColors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                promo['packageName']!,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PromotionDetailScreen(promo: promo),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Lihat Detail',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}