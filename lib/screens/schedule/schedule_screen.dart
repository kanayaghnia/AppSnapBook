import 'package:flutter/material.dart';
import 'package:snapbook/theme/colors.dart';
import 'package:snapbook/services/booking_service.dart';
import 'package:snapbook/models/booking_model.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _focused = DateTime.now();
  DateTime? _selected;
  late Future<List<BookingModel>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _selected = DateTime.now();
    _bookingsFuture = BookingService.getBookings();
  }

  DateTime? _parseDate(String raw) {
    try {
      final parts = raw.split('/'); // format dd/MM/yyyy
      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    } catch (_) {
      return null;
    }
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isToday(DateTime d) => _isSameDay(d, DateTime.now());

  List<DateTime> _daysInMonth(DateTime m) {
    final first = DateTime(m.year, m.month, 1);
    final last = DateTime(m.year, m.month + 1, 0);
    final startPad = first.weekday % 7; // Sun = 0
    return [
      for (int i = 0; i < startPad; i++) DateTime(0),
      for (int d = 1; d <= last.day; d++) DateTime(m.year, m.month, d),
    ];
  }

  String _monthName(DateTime d) {
    const months = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${months[d.month]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: const BackButton(color: AppColors.black),
        title: const Text(
          'Jadwal Saya',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.lightGrey, height: 1),
        ),
      ),
      body: FutureBuilder<List<BookingModel>>(
        future: _bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final bookings = snapshot.data ?? [];

          // Map tanggal → list booking di tanggal itu
          final Map<String, List<BookingModel>> byDate = {};
          for (final b in bookings) {
            final d = _parseDate(b.date);
            if (d == null) continue;
            final key = '${d.year}-${d.month}-${d.day}';
            byDate.putIfAbsent(key, () => []).add(b);
          }

          bool hasBooking(DateTime d) =>
              byDate.containsKey('${d.year}-${d.month}-${d.day}');

          List<BookingModel> bookingsFor(DateTime? d) {
            if (d == null) return [];
            return byDate['${d.year}-${d.month}-${d.day}'] ?? [];
          }

          final days = _daysInMonth(_focused);
          final selectedBookings = bookingsFor(_selected);

          return Column(
            children: [
              // ── Calendar card ───────────────────────────────
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Month nav
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left, color: AppColors.black),
                          onPressed: () => setState(() {
                            _focused = DateTime(_focused.year, _focused.month - 1);
                          }),
                        ),
                        Text(
                          _monthName(_focused),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right, color: AppColors.black),
                          onPressed: () => setState(() {
                            _focused = DateTime(_focused.year, _focused.month + 1);
                          }),
                        ),
                      ],
                    ),
                    // Weekday labels
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab']
                          .map((d) => SizedBox(
                        width: 36,
                        child: Center(
                          child: Text(
                            d,
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ))
                          .toList(),
                    ),
                    const SizedBox(height: 8),
                    // Day grid
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 7,
                      physics: const NeverScrollableScrollPhysics(),
                      children: days.map((d) {
                        if (d.year == 0) return const SizedBox();
                        final isSelected =
                            _selected != null && _isSameDay(_selected!, d);
                        final hasB = hasBooking(d);
                        return GestureDetector(
                          onTap: () => setState(() => _selected = d),
                          child: Container(
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${d.day}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight:
                                    _isToday(d) ? FontWeight.w700 : FontWeight.w400,
                                    color: isSelected
                                        ? AppColors.black
                                        : _isToday(d)
                                        ? AppColors.primary
                                        : AppColors.black,
                                  ),
                                ),
                                if (hasB)
                                  Container(
                                    width: 5,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? AppColors.black
                                          : AppColors.primary,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              // ── Booking di tanggal terpilih ─────────────────
              Expanded(
                child: selectedBookings.isEmpty
                    ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    _selected != null
                        ? 'Tidak ada booking pada tanggal ini.'
                        : 'Pilih tanggal untuk lihat booking.',
                    style: const TextStyle(color: AppColors.grey, fontSize: 13),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: selectedBookings.length,
                  itemBuilder: (_, i) {
                    final b = selectedBookings[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.event_available,
                              color: AppColors.primary, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  b.studio,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.black,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${b.category} · ${b.time}',
                                  style: const TextStyle(
                                      fontSize: 12, color: AppColors.grey),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              b.status,
                              style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}