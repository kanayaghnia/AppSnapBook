import 'package:flutter/material.dart';
import 'package:snapbook/theme/colors.dart';
import 'package:snapbook/services/booking_service.dart';

// ─── Helper ──────────────────────────────────────────────────────
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

class RatingScreen extends StatefulWidget {
  final String studioName;
  final String packageName;
  final String date;
  final String bookingId;

  const RatingScreen({
    super.key,
    required this.studioName,
    required this.packageName,
    required this.date,
    required this.bookingId,
  });

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _rating = 0;
  final _reviewCtrl = TextEditingController();
  final List<String> _quickTags = [
    'Studionya bersih',
    'Fotografer profesional',
    'Pencahayaan bagus',
    'Hasil foto memuaskan',
    'Staff ramah',
    'Fasilitas lengkap',
  ];
  final Set<String> _selectedTags = {};

  @override
  void dispose() {
    _reviewCtrl.dispose();
    super.dispose();
  }

  String get _ratingLabel {
    switch (_rating) {
      case 1: return 'Mengecewakan 😞';
      case 2: return 'Kurang Memuaskan 😕';
      case 3: return 'Cukup Baik 😊';
      case 4: return 'Bagus! 😄';
      case 5: return 'Luar Biasa! 🤩';
      default: return 'Pilih rating';
    }
  }

  void _submit() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Pilih rating terlebih dahulu'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    await BookingService.rateBooking(widget.bookingId, _rating);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('✓ Rating berhasil dikirim, terima kasih!'),
        backgroundColor: AppColors.black,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    Navigator.pop(context, _rating);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Beri Rating',
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
            // ── Booking info card ────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
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
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      _studioImagePath(widget.studioName),
                      width: 60, height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(width: 60, height: 60,
                              color: AppColors.background),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.studioName,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.black)),
                        const SizedBox(height: 3),
                        Text(widget.packageName,
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.grey)),
                        const SizedBox(height: 3),
                        Row(children: [
                          const Icon(Icons.calendar_today_outlined,
                              size: 11, color: AppColors.grey),
                          const SizedBox(width: 4),
                          Text(widget.date,
                              style: const TextStyle(
                                  fontSize: 11, color: AppColors.grey)),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Star rating ──────────────────────────────────
            Center(
              child: Column(
                children: [
                  const Text(
                    'Bagaimana pengalaman sesimu?',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      return GestureDetector(
                        onTap: () => setState(() => _rating = i + 1),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Icon(
                            i < _rating
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            size: _rating > 0 && i < _rating ? 44 : 38,
                            color: i < _rating
                                ? const Color(0xFFFBBF24)
                                : const Color(0xFFBBB0A0),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      _ratingLabel,
                      key: ValueKey(_rating),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _rating > 0
                            ? const Color(0xFFFBBF24)
                            : AppColors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Quick tags ───────────────────────────────────
            const Text('Apa yang kamu suka?',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _quickTags.map((tag) {
                final isSelected = _selectedTags.contains(tag);
                return GestureDetector(
                  onTap: () => setState(() {
                    isSelected
                        ? _selectedTags.remove(tag)
                        : _selectedTags.add(tag);
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.black : AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.black
                            : AppColors.lightGrey,
                      ),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : AppColors.grey,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // ── Review text ──────────────────────────────────
            const Text('Tulis ulasanmu (opsional)',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _reviewCtrl,
                maxLines: 4,
                maxLength: 200,
                decoration: InputDecoration(
                  hintText:
                  'Ceritakan pengalamanmu di sini...',
                  hintStyle: const TextStyle(
                      fontSize: 13, color: AppColors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ── Submit ───────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.black,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text(
                  'Kirim Rating',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}