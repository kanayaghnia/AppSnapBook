import 'package:flutter/material.dart';
import 'package:snapbook/theme/colors.dart';
import 'package:snapbook/screens/notification/notification_screen.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Hamburger — naik terus sampai ketemu Scaffold yang punya drawer
          IconButton(
            onPressed: () => _openDrawer(context),
            icon: const Icon(Icons.menu, color: AppColors.black, size: 28),
          ),

          // Logo
          Column(
            children: [

              RichText(
                text: const TextSpan(
                  children: [

                    TextSpan(
                      text: 'Snap',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),

                    TextSpan(
                      text: 'Book',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const Text(
                'Photo Studio Booking',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),

          // Notifikasi
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationScreen()),
            ),
            icon: const Icon(
              Icons.notifications_none,
              color: AppColors.black,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  void _openDrawer(BuildContext context) {
    // Cari ScaffoldState yang punya drawer, dari bawah ke atas
    ScaffoldState? scaffold;
    context.visitAncestorElements((element) {
      if (element is StatefulElement && element.state is ScaffoldState) {
        final s = element.state as ScaffoldState;
        if (s.hasDrawer) {
          scaffold = s;
          return false; // stop
        }
      }
      return true; // lanjut naik
    });
    scaffold?.openDrawer();
  }
}