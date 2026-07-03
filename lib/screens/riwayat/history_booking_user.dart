import 'package:flutter/material.dart';
import 'package:snapbook/theme/colors.dart';
import 'package:snapbook/screens/home/widgets/header_section.dart';
import 'package:snapbook/services/booking_service.dart';
import 'package:snapbook/models/booking_model.dart';
import 'package:snapbook/screens/riwayat/rating_screen.dart';

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

class HistoryBookingUser extends StatefulWidget {
  const HistoryBookingUser({super.key});

  @override
  State<HistoryBookingUser> createState() => _HistoryBookingUserState();
}

class _HistoryBookingUserState extends State<HistoryBookingUser>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  static const _tabs = ['Semua', 'Selesai', 'Pending', 'Dibatalkan'];
  late Future<List<BookingModel>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _refresh();
  }

  void _refresh() {
    setState(() {
      _bookingsFuture = BookingService.getBookings();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _rupiah(int price) => 'Rp ${price.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
  )}';

  List<Map<String, dynamic>> _toCards(List<BookingModel> bookings) {
    return bookings.asMap().entries.map((entry) {
      final i = entry.key;
      final b = entry.value;
      return {
        'id': b.id,
        'bookingId': '#BK-${DateTime.now().year}${(i + 1).toString().padLeft(4, '0')}',
        'packageName': b.category,
        'studio': b.studio,
        'date': b.date,
        'time': b.time,
        'people': b.people,
        'total': _rupiah(b.price),
        'status': b.status == 'Lunas' ? 'Selesai' : b.status,
        'payment': b.payment,
        'rating': b.rating,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const HeaderSection(),
            Container(
              color: AppColors.background,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: AppColors.black,
                unselectedLabelColor: AppColors.grey,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                tabs: _tabs.map((t) => Tab(text: t)).toList(),
              ),
            ),
            Container(height: 1, color: AppColors.lightGrey),
            Expanded(
              child: FutureBuilder<List<BookingModel>>(
                future: _bookingsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Gagal memuat data'));
                  }
                  final all = _toCards(snapshot.data ?? []);
                  final selesai = all.where((b) => b['status'] == 'Selesai').toList();
                  final pending = all.where((b) => b['status'] == 'Pending').toList();
                  final batal = all.where((b) => b['status'] == 'Dibatalkan').toList();

                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _BookingList(bookings: all, onRated: _refresh),
                      _BookingList(bookings: selesai, onRated: _refresh),
                      _BookingList(bookings: pending, onRated: _refresh),
                      _BookingList(bookings: batal, onRated: _refresh),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingList extends StatelessWidget {
  final List<Map<String, dynamic>> bookings;
  final VoidCallback onRated;
  const _BookingList({required this.bookings, required this.onRated});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) return const _EmptyState();
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      itemCount: bookings.length,
      itemBuilder: (_, i) => _BookingCard(booking: bookings[i], onRated: onRated),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  final VoidCallback onRated;
  const _BookingCard({required this.booking, required this.onRated});

  @override
  Widget build(BuildContext context) {
    final status = booking['status'] as String;
    final isCancelled = status == 'Dibatalkan';
    final isPending = status == 'Pending';
    final isSelesai = status == 'Selesai';

    return Container(
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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ColorFiltered(
                    colorFilter: isCancelled
                        ? const ColorFilter.matrix([
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0,      0,      0,      1, 0,
                    ])
                        : const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                    child: Image.asset(
                      _studioImagePath(booking['studio'] as String),
                      width: 72, height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 72, height: 72,
                        color: AppColors.background,
                        child: const Icon(Icons.image_outlined, color: AppColors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(booking['bookingId'] as String,
                              style: const TextStyle(fontSize: 11, color: AppColors.grey)),
                          _StatusBadge(status: status),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        booking['packageName'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isCancelled ? AppColors.grey : AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(booking['studio'] as String,
                          style: const TextStyle(fontSize: 12, color: AppColors.grey)),
                      const SizedBox(height: 6),
                      Row(children: [
                        const Icon(Icons.calendar_today_outlined, size: 11, color: AppColors.grey),
                        const SizedBox(width: 4),
                        Text(booking['date'] as String,
                            style: const TextStyle(fontSize: 11, color: AppColors.grey)),
                        if ((booking['time'] as String).isNotEmpty) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.access_time_outlined, size: 11, color: AppColors.grey),
                          const SizedBox(width: 4),
                          Text(booking['time'] as String,
                              style: const TextStyle(fontSize: 11, color: AppColors.grey)),
                        ],
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: AppColors.lightGrey),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Pembayaran',
                        style: TextStyle(fontSize: 11, color: AppColors.grey)),
                    const SizedBox(height: 2),
                    Text(
                      booking['total'] as String,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: isCancelled ? AppColors.grey : AppColors.black,
                        decoration: isCancelled ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ],
                ),
                if (isPending)
                  Row(children: [
                    _ActionButton(
                      label: 'Batalkan',
                      filled: false,
                      color: const Color(0xFFEF4444),
                      onTap: () async {
                        final docId = booking['id'] as String?;
                        if (docId != null) await BookingService.deleteBooking(docId);
                        onRated();
                      },
                    ),
                    const SizedBox(width: 8),
                    _ActionButton(
                      label: 'Bayar',
                      filled: true,
                      color: AppColors.primary,
                      textColor: AppColors.black,
                      onTap: () async {
                        final docId = booking['id'] as String?;
                        if (docId != null) await BookingService.payBooking(docId);
                        onRated();
                      },
                    ),
                  ]),
                if (isSelesai)
                  booking['rating'] == null
                      ? _ActionButton(
                    label: 'Beri Rating',
                    filled: true,
                    color: AppColors.primary,
                    textColor: AppColors.black,
                    onTap: () async {
                      final rating = await Navigator.push<int>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RatingScreen(
                            studioName: booking['studio'] as String,
                            packageName: booking['packageName'] as String,
                            date: booking['date'] as String,
                            bookingId: booking['id'] as String? ?? '',
                          ),
                        ),
                      );
                      if (rating != null) onRated();
                    },
                  )
                      : Row(children: [
                    ...List.generate(booking['rating'] as int, (_) =>
                    const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFBBF24))),
                    ...List.generate(5 - (booking['rating'] as int), (_) =>
                    const Icon(Icons.star_outline_rounded, size: 14, color: AppColors.lightGrey)),
                  ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = {
      'Selesai':    [const Color(0xFFDCFCE7), const Color(0xFF16A34A)],
      'Pending':    [const Color(0xFFFFF3DC), const Color(0xFFC08800)],
      'Dibatalkan': [const Color(0xFFFFE4E4), const Color(0xFFEF4444)],
    };
    final c = colors[status] ?? [AppColors.background, AppColors.grey];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(color: c[0], borderRadius: BorderRadius.circular(20)),
      child: Text(status,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: c[1])),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final bool filled;
  final Color color;
  final Color? textColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.filled,
    required this.color,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: filled ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: filled ? Colors.transparent : color),
        ),
        child: Text(label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: filled ? (textColor ?? Colors.white) : color,
            )),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

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
            child: const Icon(Icons.inbox_outlined, size: 44, color: AppColors.grey),
          ),
          const SizedBox(height: 16),
          const Text('Belum ada riwayat booking',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.black)),
          const SizedBox(height: 6),
          const Text('Booking studio favoritmu sekarang!',
              style: TextStyle(fontSize: 13, color: AppColors.grey)),
        ],
      ),
    );
  }
}