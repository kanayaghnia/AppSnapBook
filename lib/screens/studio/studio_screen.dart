import 'package:flutter/material.dart';
import 'package:snapbook/theme/colors.dart';
import 'package:snapbook/screens/home/widgets/header_section.dart';
import 'package:snapbook/screens/studio/studio_detail_screen.dart';
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

class StudioScreen extends StatefulWidget {
  final VoidCallback? onBookingTap;
  const StudioScreen({super.key, this.onBookingTap});

  @override
  State<StudioScreen> createState() => _StudioScreenState();
}

class _StudioScreenState extends State<StudioScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _activeCategory;

  // ── Data ────────────────────────────────────────────────────────
  final List<Map<String, String>> _categories = [
    {'title': 'Indoor Studio',  'seed': 'room_vintage',      'emoji': '🏠'},
    {'title': 'Outdoor Studio', 'seed': 'room_garden',       'emoji': '🌿'},
    {'title': 'Graduation',     'seed': 'room_minimalist',   'emoji': '🎓'},
    {'title': 'Prewedding',     'seed': 'room_modern_white', 'emoji': '💍'},
  ];

  final List<Map<String, String>> _studios = [
    {
      'name': 'Studio A – Minimalist',
      'location': 'Lantai 1',
      'category': 'Graduation',
      'rating': '4.9',
      'reviews': '120',
      'seed': 'room_minimalist',
    },
    {
      'name': 'Studio B – Vintage',
      'location': 'Lantai 1',
      'category': 'Indoor Studio',
      'rating': '4.7',
      'reviews': '85',
      'seed': 'room_vintage',
    },
    {
      'name': 'Studio C – Modern White',
      'location': 'Lantai 2',
      'category': 'Prewedding',
      'rating': '4.8',
      'reviews': '210',
      'seed': 'room_modern_white',
    },
    {
      'name': 'Studio D – Dark Moody',
      'location': 'Lantai 2',
      'category': 'Prewedding',
      'rating': '5.0',
      'reviews': '64',
      'seed': 'room_dark_moody',
    },
    {
      'name': 'Studio E – Garden',
      'location': 'Lantai 3',
      'category': 'Outdoor Studio',
      'rating': '4.6',
      'reviews': '97',
      'seed': 'room_garden',
    },
    {
      'name': 'Studio F – Rustic',
      'location': 'Lantai 3',
      'category': 'Indoor Studio',
      'rating': '4.5',
      'reviews': '53',
      'seed': 'room_rustic',
    },
  ];

  List<Map<String, String>> get _filtered {
    return _studios.where((s) {
      final matchSearch = _searchQuery.isEmpty ||
          s['name']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s['location']!.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchCat =
          _activeCategory == null || s['category'] == _activeCategory;
      return matchSearch && matchCat;
    }).toList();
  }

  void _navigateToDetail(Map<String, String> studio) async {
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
          onBookingTap: widget.onBookingTap,
        ),
      ),
    );
    setState(() {});  // ← refresh seluruh halaman studio setelah balik
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────
            const HeaderSection(),

            // ── Scrollable content ───────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      'Pilih Studio',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Temukan studio favoritmu ✨',
                      style: TextStyle(fontSize: 13, color: AppColors.grey),
                    ),

                    const SizedBox(height: 16),

                    // ── Search bar ─────────────────────────────
                    Container(
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
                      child: TextField(
                        controller: _searchController,
                        onChanged: (v) => setState(() => _searchQuery = v),
                        decoration: InputDecoration(
                          hintText: 'Cari studio atau kota...',
                          hintStyle: const TextStyle(
                              fontSize: 13, color: AppColors.grey),
                          prefixIcon: const Icon(Icons.search,
                              color: AppColors.grey, size: 20),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                            icon: const Icon(Icons.close,
                                color: AppColors.grey, size: 18),
                            onPressed: () => setState(() {
                              _searchQuery = '';
                              _searchController.clear();
                            }),
                          )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),

                    // ── Search results dropdown ─────────────────
                    if (_searchQuery.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: _filtered.isEmpty
                            ? const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: Text(
                              'Studio tidak ditemukan',
                              style: TextStyle(
                                  fontSize: 13, color: AppColors.grey),
                            ),
                          ),
                        )
                            : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _filtered.length,
                          separatorBuilder: (_, __) => Container(
                              height: 1,
                              color: AppColors.lightGrey,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16)),
                          itemBuilder: (_, i) {
                            final s = _filtered[i];
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: _studioImage(s['seed']!, width: 100, height: 100)
                              ),
                              title: Text(s['name']!,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.black)),
                              subtitle: Text(s['location']!,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.grey)),
                            );
                          },
                        ),
                      ),
                    ],

                    if (_searchQuery.isEmpty) ...[
                      const SizedBox(height: 20),

                      // ── Kategori Studio ───────────────────────
                      _SectionHeader(
                        title: 'Kategori Studio',
                        onTap: () {},
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 155,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _categories.length,
                          itemBuilder: (_, i) {
                            final cat = _categories[i];
                            final isActive =
                                _activeCategory == cat['title'];
                            return GestureDetector(
                              onTap: () => setState(() {
                                _activeCategory = isActive
                                    ? null
                                    : cat['title'];
                              }),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                width: 130,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isActive
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    width: 2.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          _studioImage(cat['seed']!, fit: BoxFit.cover),
                                          Positioned(
                                            left: 8,
                                            bottom: 8,
                                            child: Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.88),
                                                borderRadius:
                                                BorderRadius.circular(8),
                                              ),
                                              child: Text(cat['emoji']!,
                                                  style: const TextStyle(
                                                      fontSize: 14)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 8, 10, 10),
                                      child: Text(
                                        cat['title']!,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: isActive
                                              ? AppColors.black
                                              : AppColors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Semua Studio ──────────────────────────
                      _SectionHeader(
                        title: _activeCategory ?? 'Semua Studio',
                        onTap: () => setState(() => _activeCategory = null),
                        actionLabel:
                        _activeCategory != null ? 'Reset' : null,
                      ),
                      const SizedBox(height: 12),
                    ],

                    // ── Studio grid (shown always if search empty) ─
                    if (_searchQuery.isEmpty)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filtered.length,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.78,
                        ),
                        itemBuilder: (_, i) =>
                            _StudioCard(studio: _filtered[i], onTap: () => _navigateToDetail(_filtered[i])),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onTap;

  const _SectionHeader({
    required this.title,
    this.actionLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}

// ─── Studio Card ──────────────────────────────────────────────────
class _StudioCard extends StatefulWidget {
  final Map<String, String> studio;
  final VoidCallback onTap;

  const _StudioCard({required this.studio, required this.onTap});

  @override
  State<_StudioCard> createState() => _StudioCardState();
}


class _StudioCardState extends State<_StudioCard> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = FavoriteService.isFavorite(widget.studio['name']!);
  }

  @override
  void didUpdateWidget(covariant _StudioCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isFavorite = FavoriteService.isFavorite(widget.studio['name']!);
  }

  void _toggleFavorite() async {
    await FavoriteService.toggle(widget.studio['name']!);
    setState(() {
      _isFavorite = FavoriteService.isFavorite(widget.studio['name']!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
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
            // Photo
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _studioImage(widget.studio['seed']!, width: 300, height: 300),
                  // Rating chip
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 11, color: Color(0xFFFBBF24)),
                          const SizedBox(width: 3),
                          Text(
                            widget.studio['rating']!,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Favorite button
                  Positioned(
                    top: 8,
                    left: 8,
                    child: GestureDetector(
                      onTap: _toggleFavorite,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: _isFavorite
                              ? const Color(0xFFFFE4E4)
                              : Colors.black.withOpacity(0.35),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 15,
                          color: _isFavorite
                              ? const Color(0xFFEF4444)
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 9, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.studio['name']!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.meeting_room_outlined,
                          size: 11, color: AppColors.grey),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          widget.studio['location']!,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}