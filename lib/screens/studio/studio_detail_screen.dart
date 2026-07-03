import 'package:flutter/material.dart';
import 'package:snapbook/theme/colors.dart';
import 'package:snapbook/services/favorite_service.dart';

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

class StudioDetailScreen extends StatefulWidget {
  final String name;
  final String location;
  final String seed;
  final String rating;
  final String reviews;
  final String category;
  final VoidCallback? onBookingTap;

  const StudioDetailScreen({
    super.key,
    required this.name,
    required this.location,
    required this.seed,
    required this.rating,
    required this.reviews,
    required this.category,
    this.onBookingTap,
  });

  @override
  State<StudioDetailScreen> createState() => _StudioDetailScreenState();
}

class _StudioDetailScreenState extends State<StudioDetailScreen> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = FavoriteService.isFavorite(widget.name);
  }

  void _toggleFavorite() async {
    await FavoriteService.toggle(widget.name);
    setState(() {
      _isFavorite = FavoriteService.isFavorite(widget.name);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite
              ? '❤️ ${widget.name} ditambahkan ke favorit'
              : '${widget.name} dihapus dari favorit',
        ),
        backgroundColor: AppColors.black,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ── Hero image ──────────────────────────────
                  SizedBox(
                    height: 300,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _studioImage(widget.seed, fit: BoxFit.cover),
                        // Gradient
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.3),
                                Colors.transparent,
                                Colors.black.withOpacity(0.15),
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                        // Back button
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 12,
                          left: 16,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 40, height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.arrow_back,
                                  color: AppColors.black, size: 20),
                            ),
                          ),
                        ),
                        // Favorite button
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 12,
                          left: 60,
                          child: GestureDetector(
                            onTap: _toggleFavorite,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 40, height: 40,
                              decoration: BoxDecoration(
                                color: _isFavorite
                                    ? const Color(0xFFFFE4E4)
                                    : Colors.white.withOpacity(0.9),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _isFavorite
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: _isFavorite
                                    ? const Color(0xFFEF4444)
                                    : AppColors.black,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        // Category chip
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 12,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              widget.category,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Content ──────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name + rating
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.black,
                                  height: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF8EC),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.star_rounded,
                                      size: 15, color: Color(0xFFFBBF24)),
                                  const SizedBox(width: 4),
                                  Text(widget.rating,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.black)),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Location + reviews
                        Row(children: [
                          const Icon(Icons.meeting_room_outlined,
                              size: 14, color: AppColors.grey),
                          const SizedBox(width: 4),
                          Text(widget.location,
                              style: const TextStyle(
                                  fontSize: 13, color: AppColors.grey)),
                          const SizedBox(width: 12),
                          const Icon(Icons.chat_bubble_outline,
                              size: 13, color: AppColors.grey),
                          const SizedBox(width: 4),
                          Text('${widget.reviews} ulasan',
                              style: const TextStyle(
                                  fontSize: 13, color: AppColors.grey)),
                        ]),

                        const SizedBox(height: 20),
                        _Divider(),
                        const SizedBox(height: 20),

                        const _SectionTitle('Deskripsi'),
                        const SizedBox(height: 8),
                        const Text(
                          'Studio modern dengan konsep aesthetic dan pencahayaan premium. Cocok untuk photoshoot graduation, prewedding, dan personal branding. Dilengkapi dengan berbagai set background dan properti foto.',
                          style: TextStyle(
                              fontSize: 13, color: AppColors.grey, height: 1.7),
                        ),

                        const SizedBox(height: 20),
                        _Divider(),
                        const SizedBox(height: 20),

                        const _SectionTitle('Fasilitas'),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            _FacilityItem(icon: Icons.wifi_outlined, label: 'WiFi'),
                            _FacilityItem(icon: Icons.local_cafe_outlined, label: 'Café'),
                            _FacilityItem(icon: Icons.ac_unit_outlined, label: 'AC'),
                            _FacilityItem(icon: Icons.camera_alt_outlined, label: 'Kamera'),
                            _FacilityItem(icon: Icons.local_parking_outlined, label: 'Parkir'),
                          ],
                        ),

                        const SizedBox(height: 20),
                        _Divider(),
                        const SizedBox(height: 20),

                        const _SectionTitle('Ulasan'),
                        const SizedBox(height: 12),
                        ..._reviewItems.map((r) => _ReviewTile(review: r)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Sticky bottom bar ─────────────────────────────────
          Container(
            padding: EdgeInsets.fromLTRB(
                20, 14, 20, MediaQuery.of(context).padding.bottom + 14),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 16,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // tutup detail screen
                      widget.onBookingTap?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.black,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Booking Sekarang',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Data & small widgets ─────────────────────────────────────────
const _reviewItems = [
  {'name': 'Budi Santoso', 'rating': 5, 'text': 'Studionya keren banget, pencahayaan perfect!', 'seed': 'reviewer_1'},
  {'name': 'Maya Putri',   'rating': 4, 'text': 'Pelayanan ramah, hasilnya memuaskan.',          'seed': 'reviewer_2'},
];

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(height: 1, color: AppColors.lightGrey);
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.black));
}

class _FacilityItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FacilityItem({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) => Column(children: [
    Container(
      width: 50, height: 50,
      decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(14)),
      child: Icon(icon, color: AppColors.black, size: 22),
    ),
    const SizedBox(height: 6),
    Text(label, style: const TextStyle(fontSize: 11, color: AppColors.grey)),
  ]);
}

class _ReviewTile extends StatelessWidget {
  final Map<String, dynamic> review;
  const _ReviewTile({required this.review});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ClipOval(
        child: Image.asset(
          'assets/images/${review['seed']}.jpg',
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(color: AppColors.background),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(review['name']!,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black)),
            const Spacer(),
            ...List.generate(5, (i) => Icon(
              i < (review['rating'] as int)
                  ? Icons.star_rounded
                  : Icons.star_outline_rounded,
              size: 13,
              color: i < (review['rating'] as int)
                  ? const Color(0xFFFBBF24)
                  : AppColors.lightGrey,
            )),
          ]),
          const SizedBox(height: 3),
          Text(review['text']!,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.grey, height: 1.5)),
        ]),
      ),
    ]),
  );
}