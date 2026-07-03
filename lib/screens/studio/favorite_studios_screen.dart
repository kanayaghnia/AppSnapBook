import 'package:flutter/material.dart';
import 'package:snapbook/theme/colors.dart';
import 'package:snapbook/services/favorite_service.dart';
import 'package:snapbook/screens/studio/studio_detail_screen.dart';

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

// Data studio lengkap — sama persis dengan studio_screen.dart
// supaya bisa ditampilkan di halaman favorit
const _allStudios = [
  {'name': 'Studio A – Minimalist',  'location': 'Lantai 1', 'category': 'Indoor Studio',  'rating': '4.9', 'reviews': '120', 'seed': 'room_minimalist'},
  {'name': 'Studio B – Vintage',     'location': 'Lantai 1', 'category': 'Outdoor Studio', 'rating': '4.7', 'reviews': '85',  'seed': 'room_vintage'},
  {'name': 'Studio C – Modern White','location': 'Lantai 2', 'category': 'Graduation',     'rating': '4.8', 'reviews': '210', 'seed': 'room_modern_white'},
  {'name': 'Studio D – Dark Moody',  'location': 'Lantai 2', 'category': 'Prewedding',     'rating': '5.0', 'reviews': '64',  'seed': 'room_dark_moody'},
  {'name': 'Studio E – Garden',      'location': 'Lantai 3', 'category': 'Indoor Studio',  'rating': '4.6', 'reviews': '97',  'seed': 'room_garden'},
  {'name': 'Studio F – Rustic',      'location': 'Lantai 3', 'category': 'Outdoor Studio', 'rating': '4.5', 'reviews': '53',  'seed': 'room_rustic'},
];

class FavoriteStudiosScreen extends StatefulWidget {
  const FavoriteStudiosScreen({super.key});

  @override
  State<FavoriteStudiosScreen> createState() => _FavoriteStudiosScreenState();
}

class _FavoriteStudiosScreenState extends State<FavoriteStudiosScreen> {
  List<Map<String, String>> get _favorites => _allStudios
      .where((s) => FavoriteService.isFavorite(s['name']!))
      .map((s) => Map<String, String>.from(s))
      .toList();

  void _removeFavorite(String name) async {
    await FavoriteService.toggle(name);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name dihapus dari favorit'),
        backgroundColor: AppColors.black,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favorites = _favorites;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Favorite Studios',
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
      body: favorites.isEmpty
          ? _EmptyState()
          : ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          // Counter
          Text(
            '${favorites.length} studio favorit',
            style: const TextStyle(fontSize: 13, color: AppColors.grey),
          ),
          const SizedBox(height: 14),

          ...favorites.map((studio) => _FavoriteCard(
            studio: studio,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StudioDetailScreen(
                    name: studio['name']!,
                    location: studio['location']!,
                    seed: studio['seed']!,
                    rating: studio['rating']!,
                    reviews: studio['reviews']!,
                    category: studio['category']!,
                  ),
                ),
              );
              // Refresh setelah balik dari detail
              // (mungkin user unfavorite dari sana)
              setState(() {});
            },
            onRemove: () => _removeFavorite(studio['name']!),
          )),
        ],
      ),
    );
  }
}

// ─── Favorite Card ────────────────────────────────────────────────
class _FavoriteCard extends StatelessWidget {
  final Map<String, String> studio;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _FavoriteCard({
    required this.studio,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
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
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            // Foto
            SizedBox(
              width: 100,
              height: 100,
              child: _studioImage(studio['seed']!, width: 100, height: 100),
            ),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        studio['category']!,
                        style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.grey),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      studio['name']!,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black),
                    ),
                    const SizedBox(height: 3),
                    Row(children: [
                      const Icon(Icons.meeting_room_outlined,
                          size: 11, color: AppColors.grey),
                      const SizedBox(width: 3),
                      Text(studio['location']!,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.grey)),
                    ]),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Rating
                        Row(children: [
                          const Icon(Icons.star_rounded,
                              size: 12, color: Color(0xFFFBBF24)),
                          const SizedBox(width: 3),
                          Text(studio['rating']!,
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black)),
                        ]),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Remove button
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFE4E4),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_rounded,
                      color: Color(0xFFEF4444), size: 17),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.lightGrey, width: 1.5),
            ),
            child: const Icon(Icons.favorite_border_rounded,
                size: 44, color: AppColors.grey),
          ),
          const SizedBox(height: 16),
          const Text('Belum ada studio favorit',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black)),
          const SizedBox(height: 6),
          const Text('Tap ikon ❤️ di halaman detail studio\nuntuk menambahkan ke favorit!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.grey, height: 1.5)),
        ],
      ),
    );
  }
}