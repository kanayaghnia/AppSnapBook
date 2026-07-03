import 'dart:io';
import 'package:flutter/material.dart';
import 'package:snapbook/theme/colors.dart';
import 'package:snapbook/screens/home/widgets/header_section.dart';
import 'package:snapbook/screens/home/widgets/quick_menu.dart';
import 'package:snapbook/screens/home/widgets/promo_banner.dart';
import 'package:snapbook/screens/home/widgets/studio_availability.dart';
import 'package:snapbook/screens/home/widgets/popular_package.dart';
import 'package:snapbook/screens/home/widgets/upcoming_booking.dart';
import 'package:snapbook/services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onBookingTap;

  const HomeScreen({super.key, this.onBookingTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderSection(),
              const GreetingSection(),
              const SizedBox(height: 4),
              const PromoBanner(),
              const SizedBox(height: 4),
              QuickMenu(onBookingTap: onBookingTap),
              const SizedBox(height: 8),
              const StudioAvailability(),
              const SizedBox(height: 8),
              PopularPackage(onBookingTap: onBookingTap),
              const SizedBox(height: 8),
              const UpcomingBooking(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  GREETING SECTION
// ═══════════════════════════════════════════════════════════════════
class GreetingSection extends StatelessWidget {
  const GreetingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final username = AuthService.currentUsername;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, $username! 👋',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Ready to capture your best moment?',
                style: TextStyle(fontSize: 13, color: AppColors.grey),
              ),
            ],
          ),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2.5),
              color: AppColors.primary.withOpacity(0.2),
            ),
            child: ClipOval(
              child: AuthService.currentPhotoPath != null
                  ? Image.file(File(AuthService.currentPhotoPath!),
                  fit: BoxFit.cover, width: 52, height: 52)
                  : Center(
                child: Text(
                  username.isNotEmpty ? username[0].toUpperCase() : '?',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}