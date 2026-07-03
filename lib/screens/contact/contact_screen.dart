import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snapbook/theme/colors.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Hubungi Studio',
          style: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Studio identity card ─────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
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
              child: Row(
                children: [
                  Container(
                    width: 56, height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.camera_alt_outlined,
                        color: AppColors.black, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(children: [
                          TextSpan(
                            text: 'Snap',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.black),
                          ),
                          TextSpan(
                            text: 'Book',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary),
                          ),
                        ]),
                      ),
                      const Text('Photo Studio',
                          style:
                          TextStyle(fontSize: 12, color: AppColors.grey)),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('Buka',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF16A34A))),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Contact details ──────────────────────────────
            const _SectionLabel('Informasi Kontak'),
            const SizedBox(height: 12),

            _ContactTile(
              icon: Icons.phone_outlined,
              label: 'Telepon / WhatsApp',
              value: '+62 823 2354 4536',
              bgColor: const Color(0xFFE8F8EF),
              iconColor: const Color(0xFF2E9E5B),
              onTap: () => _copyToClipboard(
                  context, '+62 823 2354 4536', 'Nomor telepon'),
            ),
            const SizedBox(height: 10),
            _ContactTile(
              icon: Icons.email_outlined,
              label: 'Email',
              value: 'support@snapbook.com',
              bgColor: const Color(0xFFE8F4FD),
              iconColor: const Color(0xFF3A86C8),
              onTap: () => _copyToClipboard(
                  context, 'support@snapbook.com', 'Email'),
            ),
            const SizedBox(height: 10),
            _ContactTile(
              icon: Icons.alternate_email,
              label: 'Instagram',
              value: '@snapbook.studio',
              bgColor: const Color(0xFFF5E6FF),
              iconColor: const Color(0xFF9333EA),
              onTap: () =>
                  _copyToClipboard(context, '@snapbook.studio', 'Instagram'),
            ),

            const SizedBox(height: 24),

            // ── Location ─────────────────────────────────────
            const _SectionLabel('Lokasi Studio'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE4E4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.location_on_outlined,
                        color: Color(0xFFEF4444), size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Alamat Studio',
                            style: TextStyle(
                                fontSize: 11,
                                color: AppColors.grey,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 3),
                        const Text(
                          'Jl. Sudirman No. 45, Lantai 3\nJakarta Selatan, 12190',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                              height: 1.5),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _copyToClipboard(context,
                              'Jl. Sudirman No. 45, Jakarta Selatan', 'Alamat'),
                          child: const Text(
                            'Salin alamat',
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Operating hours ───────────────────────────────
            const _SectionLabel('Jam Operasional'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
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
                  _HourRow('Senin – Jumat', '09.00 – 20.00 WIB', isToday: true),
                  _divider(),
                  _HourRow('Sabtu', '08.00 – 21.00 WIB'),
                  _divider(),
                  _HourRow('Minggu', '09.00 – 18.00 WIB'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label disalin ke clipboard'),
        backgroundColor: AppColors.black,
        behavior: SnackBarBehavior.floating,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _divider() => Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: AppColors.lightGrey);
}

// ─── Section Label ────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.black),
  );
}

// ─── Action Button ────────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.bgColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 26),
            const SizedBox(height: 6),
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: iconColor)),
          ],
        ),
      ),
    );
  }
}

// ─── Contact Tile ─────────────────────────────────────────────────
class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _ContactTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.bgColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              width: 44, height: 44,
              decoration: BoxDecoration(
                  color: bgColor, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.grey,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(value,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black)),
                ],
              ),
            ),
            const Icon(Icons.copy_outlined, size: 16, color: AppColors.grey),
          ],
        ),
      ),
    );
  }
}

// ─── Hour Row ─────────────────────────────────────────────────────
class _HourRow extends StatelessWidget {
  final String day;
  final String hours;
  final bool isToday;

  const _HourRow(this.day, this.hours, {this.isToday = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          if (isToday)
            Container(
              width: 6, height: 6,
              margin: const EdgeInsets.only(right: 8),
              decoration: const BoxDecoration(
                  color: Color(0xFF16A34A), shape: BoxShape.circle),
            ),
          Text(day,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                  isToday ? FontWeight.w700 : FontWeight.w500,
                  color: AppColors.black)),
        ]),
        Text(hours,
            style: TextStyle(
                fontSize: 13,
                color: isToday
                    ? const Color(0xFF16A34A)
                    : AppColors.grey,
                fontWeight:
                isToday ? FontWeight.w600 : FontWeight.normal)),
      ],
    );
  }
}