import 'package:flutter/material.dart';
import 'package:snapbook/theme/colors.dart';
import 'package:snapbook/services/booking_service.dart';
import 'package:snapbook/models/booking_model.dart';

class UpcomingBooking extends StatelessWidget {
  const UpcomingBooking({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BookingModel>>(
      future: BookingService.getBookings(),
      builder: (context, snapshot) {
        final today = DateTime.now();

        List<BookingModel> upcoming = [];
        if (snapshot.hasData) {
          upcoming = snapshot.data!.where((b) {
            try {
              final parts = b.date.split('/');
              final bookingDate = DateTime(
                int.parse(parts[2]),
                int.parse(parts[1]),
                int.parse(parts[0]),
              );
              return !bookingDate.isBefore(
                  DateTime(today.year, today.month, today.day));
            } catch (_) {
              return true;
            }
          }).toList();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Booking Mendatang',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              if (snapshot.connectionState == ConnectionState.waiting)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (upcoming.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            size: 36, color: AppColors.lightGrey),
                        SizedBox(height: 10),
                        Text('Belum ada booking mendatang',
                            style: TextStyle(
                                fontSize: 13,
                                color: AppColors.grey,
                                fontWeight: FontWeight.w500)),
                        SizedBox(height: 4),
                        Text('Yuk booking studio favoritmu!',
                            style: TextStyle(fontSize: 12, color: AppColors.grey)),
                      ],
                    ),
                  ),
                )
              else
                ...upcoming.map((booking) => Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: _BookingCard(booking: booking),
                )),
            ],
          ),
        );
      },
    );
  }
}

String _studioImagePath(String studioName) {
  const map = {
    'Studio A – Minimalist':   'assets/images/room_minimalist.jpg',
    'Studio B – Vintage':      'assets/images/room_vintage.jpg',
    'Studio C – Modern White': 'assets/images/room_modern_white.jpg',
    'Studio D – Dark Moody':   'assets/images/room_dark_moody.jpg',
    'Studio E – Garden':       'assets/images/room_garden.jpg',
    'Studio F – Rustic':       'assets/images/room_rustic.jpg',
  };
  return map[studioName] ?? 'assets/images/room_minimalist.jpg';
}

class _BookingCard extends StatelessWidget {
  final BookingModel booking;
  const _BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
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
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                _studioImagePath(booking.studio),
                width: 80, height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80, height: 80,
                  color: AppColors.background,
                  child: const Icon(Icons.image_outlined, color: AppColors.grey),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(booking.studio,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black)),
                  const SizedBox(height: 6),
                  Row(children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 12, color: AppColors.grey),
                    const SizedBox(width: 4),
                    Text(booking.date,
                        style: const TextStyle(fontSize: 11, color: AppColors.grey)),
                  ]),
                  const SizedBox(height: 3),
                  Row(children: [
                    const Icon(Icons.access_time_outlined,
                        size: 12, color: AppColors.grey),
                    const SizedBox(width: 4),
                    Text(booking.time,
                        style: const TextStyle(fontSize: 11, color: AppColors.grey)),
                  ]),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: [
                      _Chip(booking.category),
                      _Chip(booking.people),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _StatusBadge(status: booking.status),
                const SizedBox(height: 28),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    switch (status) {
      case 'Lunas':
        bg = const Color(0xFFDCFCE7);
        fg = const Color(0xFF16A34A);
        break;
      default:
        bg = const Color(0xFFFFF3DC);
        fg = const Color(0xFFC08800);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(status,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: fg)),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
          color: AppColors.background, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: const TextStyle(fontSize: 10, color: AppColors.black)),
    );
  }
}