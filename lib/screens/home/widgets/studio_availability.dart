import 'package:flutter/material.dart';
import 'package:snapbook/theme/colors.dart';
import 'package:snapbook/screens/home/widgets/main_navigation.dart';

// Helper: pakai asset kalau ada, fallback ke picsum
Widget _studioImage(String seed, {double? width, double? height, BoxFit fit = BoxFit.cover}) {
  const _localAssets = {
    'room_minimalist': 'assets/images/room_minimalist.jpg',
    'room_vintage': 'assets/images/room_vintage.jpg',
    'room_modern_white': 'assets/images/room_modern_white.jpg',
    'room_dark_moody': 'assets/images/room_dark_moody.jpg',
    'room_garden': 'assets/images/room_garden.jpg',
    'room_rustic': 'assets/images/room_rustic.jpg',
  };

  final assetPath = _localAssets[seed];

  if (assetPath != null) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => Container(color: AppColors.background),
    );
  }

  return Image.network(
    'https://picsum.photos/seed/$seed/700/500',
    width: width,
    height: height,
    fit: fit,
    errorBuilder: (_, __, ___) => Container(color: AppColors.background),
  );
}

// ─────────────────────────────────────────────────────────────────
// MODEL
// ─────────────────────────────────────────────────────────────────
class _RoomAvailability {
  final String name;
  final String desc;
  final String seed;
  final List<String> slotsToday;
  final String? nextAvailableDate;

  const _RoomAvailability({
    required this.name,
    required this.desc,
    required this.seed,
    required this.slotsToday,
    this.nextAvailableDate,
  });

  bool get isAvailableToday => slotsToday.isNotEmpty;

  // TODO: ganti dengan fetch dari backend
  static final List<_RoomAvailability> dummyList = [
    _RoomAvailability(
      name: 'Studio A – Minimalist',
      desc: 'Clean & modern',
      seed: 'room_minimalist',
      slotsToday: ['09.00', '11.00', '14.00'],
    ),
    _RoomAvailability(
      name: 'Studio B – Vintage',
      desc: 'Nuansa retro klasik',
      seed: 'room_vintage',
      slotsToday: ['13.00', '15.00'],
    ),
    _RoomAvailability(
      name: 'Studio C – Modern White',
      desc: 'All-white, cahaya natural',
      seed: 'room_modern_white',
      slotsToday: [],
      nextAvailableDate: 'Besok, 29 Mei',
    ),
    _RoomAvailability(
      name: 'Studio D – Dark Moody',
      desc: 'Dramatic lighting',
      seed: 'room_dark_moody',
      slotsToday: ['10.00'],
    ),
    _RoomAvailability(
      name: 'Studio E – Garden',
      desc: 'Outdoor feel, dekorasi tanaman',
      seed: 'room_garden',
      slotsToday: [],
      nextAvailableDate: '31 Mei',
    ),
    _RoomAvailability(
      name: 'Studio F – Rustic',
      desc: 'Nuansa hangat kayu & bata',
      seed: 'room_rustic',
      slotsToday: ['08.00', '16.00', '18.00'],
    ),
  ];
}

// ─────────────────────────────────────────────────────────────────
// WIDGET — rename class ini juga via Refactor → Rename
// ─────────────────────────────────────────────────────────────────
class StudioAvailability extends StatelessWidget {
  const StudioAvailability({super.key});

  @override
  Widget build(BuildContext context) {
    final rooms = _RoomAvailability.dummyList;
    final now = DateTime.now();
    const days = ['Minggu','Senin','Selasa','Rabu','Kamis','Jumat','Sabtu'];
    const months = ['Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des'];
    final todayLabel =
        '${days[now.weekday % 7]}, ${now.day} ${months[now.month - 1]}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section header ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ketersediaan Ruangan',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () => NavigationHelper.of(context)?.goToTab(1),
                  child: Row(
                    children: const [
                      Text('Booking',
                          style: TextStyle(
                              fontSize: 13, color: AppColors.grey)),
                      SizedBox(width: 2),
                      Icon(Icons.chevron_right,
                          color: AppColors.grey, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Subtitle tanggal dinamis ─────────────────────────
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 4),
            child: Text(
              'Hari ini · $todayLabel',
              style: const TextStyle(fontSize: 12, color: AppColors.grey),
            ),
          ),

          const SizedBox(height: 14),

          // ── Horizontal scroll ────────────────────────────────
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: rooms.length,
              itemBuilder: (context, i) => _RoomCard(room: rooms[i]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// CARD
// ─────────────────────────────────────────────────────────────────
class _RoomCard extends StatelessWidget {
  final _RoomAvailability room;
  const _RoomCard({required this.room});

  @override
  Widget build(BuildContext context) {
    final available = room.isAvailableToday;

    return GestureDetector(
      onTap: () => NavigationHelper.of(context)?.goToTab(1),
      child: Container(
        width: 158,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Foto + badge ──────────────────────────────────
            SizedBox(
              height: 100,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _studioImage(room.seed, fit: BoxFit.cover),
                  Positioned(
                    top: 8, right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: available
                            ? const Color(0xFF22C55E)
                            : const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 5, height: 5,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            available ? 'Tersedia' : 'Penuh',
                            style: const TextStyle(
                                fontSize: 9,
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Info ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.name,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    room.desc,
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  if (available) ...[
                    const Text('Slot terdekat',
                        style: TextStyle(
                            fontSize: 9, color: AppColors.grey)),
                    const SizedBox(height: 3),
                    Row(children: [
                      const Icon(Icons.access_time_rounded,
                          size: 11, color: AppColors.grey),
                      const SizedBox(width: 4),
                      Text(
                        room.slotsToday.first,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black),
                      ),
                      if (room.slotsToday.length > 1) ...[
                        const SizedBox(width: 6),
                        Text(
                          '+${room.slotsToday.length - 1} slot',
                          style: const TextStyle(
                              fontSize: 10, color: AppColors.grey),
                        ),
                      ],
                    ]),
                  ] else ...[
                    const Text('Penuh hari ini',
                        style: TextStyle(
                            fontSize: 9, color: AppColors.grey)),
                    const SizedBox(height: 3),
                    Row(children: [
                      const Icon(Icons.event_outlined,
                          size: 11, color: AppColors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          room.nextAvailableDate ?? '-',
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ]),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}