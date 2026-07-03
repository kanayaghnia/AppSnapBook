import 'package:flutter/material.dart';
import 'package:snapbook/theme/colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'Booking Dikonfirmasi',
        'subtitle': 'Sesi Graduation kamu sudah dikonfirmasi. Sampai jumpa!',
        'time': '2 jam lalu',
        'icon': Icons.check_circle_outline_rounded,
        'iconBg': const Color(0xFFDCFCE7),
        'iconColor': const Color(0xFF16A34A),
        'isRead': false,
      },
      {
        'title': 'Pembayaran Berhasil',
        'subtitle': 'Pembayaran sebesar Rp 550.000 telah diterima.',
        'time': '5 jam lalu',
        'icon': Icons.payment_outlined,
        'iconBg': const Color(0xFFE8F4FD),
        'iconColor': const Color(0xFF3A86C8),
        'isRead': false,
      },
      {
        'title': 'Promo Spesial Untukmu!',
        'subtitle': 'Dapatkan diskon 20% untuk Prewedding Package. Berlaku hingga 31 Mei.',
        'time': '1 hari lalu',
        'icon': Icons.local_offer_outlined,
        'iconBg': const Color(0xFFFFF3DC),
        'iconColor': const Color(0xFFC08800),
        'isRead': true,
      },
      {
        'title': 'Pengingat Booking',
        'subtitle': 'Sesi Studio A – Minimalist kamu besok pukul 10.00 WIB.',
        'time': '1 hari lalu',
        'icon': Icons.access_time_outlined,
        'iconBg': const Color(0xFFF5EFE6),
        'iconColor': AppColors.black,
        'isRead': true,
      },
      {
        'title': 'Review Kamu Diterima',
        'subtitle': 'Terima kasih sudah memberikan ulasan untuk Lumiere Studio.',
        'time': '3 hari lalu',
        'icon': Icons.star_outline_rounded,
        'iconBg': const Color(0xFFFFF8EC),
        'iconColor': const Color(0xFFFBBF24),
        'isRead': true,
      },
    ];

    final unreadCount = notifications.where((n) => n['isRead'] == false).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Notifikasi',
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Unread badge ───────────────────────────────────
          if (unreadCount > 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$unreadCount belum dibaca',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // ── List ───────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                final isRead = item['isRead'] as bool;

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isRead ? AppColors.white : const Color(0xFFFDF8F2),
                    borderRadius: BorderRadius.circular(16),
                    border: isRead
                        ? null
                        : Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: item['iconBg'] as Color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          color: item['iconColor'] as Color,
                          size: 22,
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item['title'] as String,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isRead
                                          ? FontWeight.w500
                                          : FontWeight.w700,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  item['time'] as String,
                                  style: const TextStyle(
                                      fontSize: 10, color: AppColors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['subtitle'] as String,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.grey,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Unread dot
                      if (!isRead) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(top: 4),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
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