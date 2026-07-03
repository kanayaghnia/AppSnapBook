import 'package:flutter/material.dart';
import 'package:snapbook/theme/colors.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faqs = [
      {
        'q': 'Bagaimana cara booking studio?',
        'a':
        'Buka halaman Booking, pilih paket yang kamu inginkan, lalu pilih tanggal dan jam yang tersedia. Konfirmasi reservasi dan selesai!',
      },
      {
        'q': 'Apakah saya bisa membatalkan booking?',
        'a':
        'Ya, booking bisa dibatalkan melalui halaman Riwayat sebelum tanggal sesi yang dijadwalkan. Pastikan membaca kebijakan pembatalan kami.',
      },
      {
        'q': 'Bagaimana cara melihat riwayat booking?',
        'a':
        'Buka menu Riwayat di navigasi bawah untuk melihat semua booking yang sudah selesai, sedang berjalan, atau dibatalkan.',
      },
      {
        'q': 'Metode pembayaran apa yang tersedia?',
        'a':
        'Kami menerima transfer bank, dompet digital (GoPay, OVO, Dana), dan kartu kredit/debit untuk kemudahan transaksi kamu.',
      },
      {
        'q': 'Apakah ada biaya tambahan saat booking?',
        'a':
        'Harga yang tertera sudah termasuk biaya studio dan fotografer. Biaya tambahan hanya berlaku jika ada penambahan jam atau layanan ekstra.',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Help Center',
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.black),
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.lightGrey, height: 1),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        children: [
          // ── Headline ──────────────────────────────────────────
          const Text(
            'Ada yang bisa kami bantu?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.black,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Temukan jawaban dari pertanyaan yang sering ditanyakan.',
            style: TextStyle(fontSize: 13, color: AppColors.grey),
          ),

          const SizedBox(height: 28),

          // ── FAQ Section ───────────────────────────────────────
          const _SectionLabel(label: 'FAQ'),
          const SizedBox(height: 12),
          ...faqs.map((faq) => _FaqTile(q: faq['q']!, a: faq['a']!)).toList(),

          const SizedBox(height: 28),

          // ── Contact Support ───────────────────────────────────
          const _SectionLabel(label: 'Hubungi Kami'),
          const SizedBox(height: 12),

          _ContactCard(
            icon: Icons.email_outlined,
            label: 'Email',
            value: 'support@snapbook.com',
            color: const Color(0xFFE8F4FD),
            iconColor: const Color(0xFF3A86C8),
          ),
          const SizedBox(height: 10),
          _ContactCard(
            icon: Icons.phone_outlined,
            label: 'WhatsApp',
            value: '+62 823 2354 4536',
            color: const Color(0xFFE8F8EF),
            iconColor: const Color(0xFF2E9E5B),
          ),
          const SizedBox(height: 10),
          _ContactCard(
            icon: Icons.access_time_outlined,
            label: 'Jam Operasional',
            value: 'Senin – Minggu, 09.00 – 20.00 WIB',
            color: const Color(0xFFFFF8EC),
            iconColor: const Color(0xFFC08800),
          ),
        ],
      ),
    );
  }
}

// ─── Section Label ────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: AppColors.black,
      ),
    );
  }
}

// ─── FAQ Tile ─────────────────────────────────────────────────────
class _FaqTile extends StatefulWidget {
  final String q;
  final String a;
  const _FaqTile({required this.q, required this.a});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _ctrl;
  late final Animation<double> _rotate;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _rotate = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Question row
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
              child: Row(
                children: [
                  // Gold dot
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: 12, top: 1),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.q,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  RotationTransition(
                    turns: _rotate,
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.grey,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),

            // Answer (animated)
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(36, 0, 16, 16),
                child: Text(
                  widget.a,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.grey,
                    height: 1.6,
                  ),
                ),
              ),
              crossFadeState: _expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Contact Card ─────────────────────────────────────────────────
class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color iconColor;

  const _ContactCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}