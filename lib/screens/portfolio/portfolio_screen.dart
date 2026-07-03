import 'package:flutter/material.dart';
import 'package:snapbook/theme/colors.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  String _selectedCategory = 'Semua';

  final List<String> _categories = [
    'Semua', 'Personal', 'Graduation', 'Prewedding', 'Produk',
  ];

  final List<Map<String, dynamic>> _photos = [
    {'seed': 'porto_minimalist_1',    'category': 'Personal',    'studio': 'Studio A – Minimalist',    'likes': 124},
    {'seed': 'porto_minimalist_2',    'category': 'Prewedding',  'studio': 'Studio A – Minimalist',    'likes': 98},
    {'seed': 'porto_minimalist_3',    'category': 'Graduation',  'studio': 'Studio A – Minimalist',    'likes': 210},
    {'seed': 'porto_minimalist_4',    'category': 'Personal',    'studio': 'Studio A – Minimalist',    'likes': 87},
    {'seed': 'porto_vintage_1',       'category': 'Personal',    'studio': 'Studio B – Vintage',       'likes': 55},
    {'seed': 'porto_vintage_2',       'category': 'Prewedding',  'studio': 'Studio B – Vintage',       'likes': 143},
    {'seed': 'porto_vintage_3',       'category': 'Personal',    'studio': 'Studio B – Vintage',       'likes': 176},
    {'seed': 'porto_vintage_4',       'category': 'Personal',    'studio': 'Studio B – Vintage',       'likes': 62},
    {'seed': 'porto_modern_white_1',  'category': 'Graduation',  'studio': 'Studio C – Modern White',  'likes': 41},
    {'seed': 'porto_modern_white_2',  'category': 'Personal',    'studio': 'Studio C – Modern White',  'likes': 76},
    {'seed': 'porto_modern_white_3',  'category': 'Prewedding',  'studio': 'Studio C – Modern White',  'likes': 128},
    {'seed': 'porto_modern_white_4',  'category': 'Personal',    'studio': 'Studio C – Modern White',  'likes': 96},
    {'seed': 'porto_dark_moody_1',    'category': 'Personal',    'studio': 'Studio D – Dark Moody',    'likes': 64},
    {'seed': 'porto_dark_moody_2',    'category': 'Personal',    'studio': 'Studio D – Dark Moody',    'likes': 265},
    {'seed': 'porto_dark_moody_3',    'category': 'Prewedding',  'studio': 'Studio D – Dark Moody',    'likes': 87},
    {'seed': 'porto_dark_moody_4',    'category': 'Produk',      'studio': 'Studio D – Dark Moody',    'likes': 59},
    {'seed': 'porto_garden_1',        'category': 'Personal',    'studio': 'Studio E – Garden',        'likes': 97},
    {'seed': 'porto_garden_2',        'category': 'Prewedding',  'studio': 'Studio E – Garden',        'likes': 235},
    {'seed': 'porto_garden_3',        'category': 'Personal',    'studio': 'Studio E – Garden',        'likes': 54},
    {'seed': 'porto_garden_4',        'category': 'Graduation',  'studio': 'Studio E – Garden',        'likes': 197},
    {'seed': 'porto_rustic_1',        'category': 'Personal',    'studio': 'Studio F – Rustic',        'likes': 76},
    {'seed': 'porto_rustic_2',        'category': 'Prewedding',  'studio': 'Studio F – Rustic',        'likes': 85},
    {'seed': 'porto_rustic_3',        'category': 'Personal',    'studio': 'Studio F – Rustic',        'likes': 39},
    {'seed': 'porto_rustic_4',        'category': 'Personal',    'studio': 'Studio F – Rustic',        'likes': 17},
  ];

  List<Map<String, dynamic>> get _filtered => _selectedCategory == 'Semua'
      ? _photos
      : _photos.where((p) => p['category'] == _selectedCategory).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Portofolio',
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
      body: Column(
        children: [
          // ── Category filter ──────────────────────────────────
          SizedBox(
            height: 52,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: _categories.length,
              itemBuilder: (_, i) {
                final isActive = _selectedCategory == _categories[i];
                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedCategory = _categories[i]),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color:
                      isActive ? AppColors.black : AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Text(
                      _categories[i],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color:
                        isActive ? Colors.white : AppColors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ── Photo count ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: Row(
              children: [
                Text(
                  '${_filtered.length} foto',
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.grey),
                ),
              ],
            ),
          ),

          // ── Grid ─────────────────────────────────────────────
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.82,
              ),
              itemCount: _filtered.length,
              itemBuilder: (_, i) =>
                  _PhotoCard(photo: _filtered[i]),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper
Widget _portoImage(String seed, {BoxFit fit = BoxFit.cover, double? width, double? height}) {
  const _localAssets = {
    'porto_minimalist_1':    'assets/images/porto_minimalist_1.jpg',
    'porto_minimalist_2':    'assets/images/porto_minimalist_2.jpg',
    'porto_minimalist_3':    'assets/images/porto_minimalist_3.jpg',
    'porto_minimalist_4':    'assets/images/porto_minimalist_4.jpg',
    'porto_vintage_1':       'assets/images/porto_vintage_1.jpg',
    'porto_vintage_2':       'assets/images/porto_vintage_2.jpg',
    'porto_vintage_3':       'assets/images/porto_vintage_3.jpg',
    'porto_vintage_4':       'assets/images/porto_vintage_4.jpg',
    'porto_modern_white_1':  'assets/images/porto_modern_white_1.jpg',
    'porto_modern_white_2':  'assets/images/porto_modern_white_2.jpg',
    'porto_modern_white_3':  'assets/images/porto_modern_white_3.jpg',
    'porto_modern_white_4':  'assets/images/porto_modern_white_4.jpg',
    'porto_dark_moody_1':    'assets/images/porto_dark_moody_1.jpg',
    'porto_dark_moody_2':    'assets/images/porto_dark_moody_2.jpg',
    'porto_dark_moody_3':    'assets/images/porto_dark_moody_3.jpg',
    'porto_dark_moody_4':    'assets/images/porto_dark_moody_4.jpg',
    'porto_garden_1':        'assets/images/porto_garden_1.jpg',
    'porto_garden_2':        'assets/images/porto_garden_2.jpg',
    'porto_garden_3':        'assets/images/porto_garden_3.jpg',
    'porto_garden_4':        'assets/images/porto_garden_4.jpg',
    'porto_rustic_1':        'assets/images/porto_rustic_1.jpg',
    'porto_rustic_2':        'assets/images/porto_rustic_2.jpg',
    'porto_rustic_3':        'assets/images/porto_rustic_3.jpg',
    'porto_rustic_4':        'assets/images/porto_rustic_4.jpg',
  };

  final path = _localAssets[seed];
  if (path != null) {
    return Image.asset(path, fit: fit, width: width, height: height,
        errorBuilder: (_, __, ___) => Container(color: AppColors.background));
  }
  return Image.network('https://picsum.photos/seed/$seed/400/400',
      fit: fit, width: width, height: height,
      errorBuilder: (_, __, ___) => Container(color: AppColors.background));
}

// ─── Photo Card ───────────────────────────────────────────────────
class _PhotoCard extends StatefulWidget {
  final Map<String, dynamic> photo;
  const _PhotoCard({required this.photo});

  @override
  State<_PhotoCard> createState() => _PhotoCardState();
}

class _PhotoCardState extends State<_PhotoCard> {
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetail(context),
      child: Container(
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
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _portoImage(widget.photo['seed'] as String, fit: BoxFit.cover),
                  // Like button
                  Positioned(
                    top: 8, right: 8,
                    child: GestureDetector(
                      onTap: () => setState(() => _liked = !_liked),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 30, height: 30,
                        decoration: BoxDecoration(
                          color: _liked
                              ? const Color(0xFFFFE4E4)
                              : Colors.black.withOpacity(0.35),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _liked
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 15,
                          color: _liked
                              ? const Color(0xFFEF4444)
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Category chip
                  Positioned(
                    bottom: 8, left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.photo['category'] as String,
                        style: const TextStyle(
                            fontSize: 9,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.photo['studio'] as String,
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(children: [
                    Icon(
                      Icons.favorite_rounded,
                      size: 11,
                      color: _liked
                          ? const Color(0xFFEF4444)
                          : AppColors.grey,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${(widget.photo['likes'] as int) + (_liked ? 1 : 0)}',
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.grey),
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _PhotoDetail(photo: widget.photo),
    );
  }
}

// ─── Photo Detail Bottom Sheet ────────────────────────────────────
class _PhotoDetail extends StatelessWidget {
  final Map<String, dynamic> photo;
  const _PhotoDetail({required this.photo});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40, height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // Full photo
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _portoImage(photo['seed'] as String, fit: BoxFit.cover, width: double.infinity)
              ),
            ),
          ),
          // Info
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        photo['studio'] as String,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          photo['category'] as String,
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.grey,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(children: [
                  const Icon(Icons.favorite_rounded,
                      size: 14, color: Color(0xFFEF4444)),
                  const SizedBox(width: 4),
                  Text(
                    '${photo['likes']}',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}