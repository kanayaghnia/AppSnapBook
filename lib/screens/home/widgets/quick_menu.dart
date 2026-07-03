import 'package:flutter/material.dart';
import 'package:snapbook/theme/colors.dart';
import 'package:snapbook/screens/packages/packages_screen.dart';
import 'package:snapbook/screens/schedule/schedule_screen.dart';
import 'package:snapbook/screens/contact/contact_screen.dart';
import 'package:snapbook/screens/portfolio/portfolio_screen.dart';

class QuickMenu extends StatelessWidget {
  final VoidCallback? onBookingTap;

  const QuickMenu({super.key, this.onBookingTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _MenuItem(
            icon: Icons.inventory_2_outlined,
            label: 'Paket &\nLayanan',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PackagesScreen(onBookingTap: onBookingTap),
              ),
            ),
          ),
          _MenuItem(
            icon: Icons.calendar_month_outlined,
            label: 'Jadwal\nSaya',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ScheduleScreen()),
            ),
          ),
          _MenuItem(
            icon: Icons.headset_mic_outlined,
            label: 'Hubungi\nStudio',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ContactScreen()),
            ),
          ),
          _MenuItem(
            icon: Icons.photo_library_outlined,
            label: 'Porto-\nfolio',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PortfolioScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.black, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}