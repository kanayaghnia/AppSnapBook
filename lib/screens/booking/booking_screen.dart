import 'package:flutter/material.dart';
import 'package:snapbook/theme/colors.dart';
import 'package:snapbook/models/booking_model.dart';
import 'package:snapbook/services/booking_service.dart';
import 'package:snapbook/screens/home/widgets/header_section.dart';

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

// ═══════════════════════════════════════════════════════════════════
//  DATA
// ═══════════════════════════════════════════════════════════════════
const _packages = [
  {'name': 'Personal Basic',       'category': 'Personal',    'price': 350000, 'duration': '1 Jam',   'seed': 'pkg_personal_basic'},
  {'name': 'Personal Premium',     'category': 'Personal',    'price': 550000, 'duration': '2 Jam',   'seed': 'pkg_personal_premium'},
  {'name': 'Graduation Standard',  'category': 'Graduation',  'price': 450000, 'duration': '1.5 Jam', 'seed': 'pkg_graduation_std'},
  {'name': 'Graduation Deluxe',    'category': 'Graduation',  'price': 700000, 'duration': '3 Jam',   'seed': 'pkg_graduation_dlx'},
  {'name': 'Prewedding Romantic',  'category': 'Prewedding',  'price': 1200000,'duration': '3 Jam',   'seed': 'pkg_prewedding_rom'},
  {'name': 'Prewedding Luxury',    'category': 'Prewedding',  'price': 1800000,'duration': '5 Jam',   'seed': 'pkg_prewedding_lux'},
  {'name': 'Product Photography',  'category': 'Produk',      'price': 500000, 'duration': '2 Jam',   'seed': 'pkg_product'},
];

const _rooms = [
  {'name': 'Studio A – Minimalist', 'desc': 'Clean & modern, cocok untuk semua jenis sesi', 'seed': 'room_minimalist'},
  {'name': 'Studio B – Vintage',    'desc': 'Nuansa retro dengan props klasik',             'seed': 'room_vintage'},
  {'name': 'Studio C – Modern White','desc': 'All-white studio dengan cahaya natural',      'seed': 'room_modern_white'},
  {'name': 'Studio D – Dark Moody', 'desc': 'Dramatic lighting dengan tone gelap',          'seed': 'room_dark_moody'},
  {'name': 'Studio E – Garden',     'desc': 'Outdoor feel dengan dekorasi tanaman',         'seed': 'room_garden'},
  {'name': 'Studio F – Rustic',     'desc': 'Nuansa hangat dengan elemen kayu & bata',      'seed': 'room_rustic'},
];

const _payments = ['DANA', 'OVO', 'GoPay', 'Bank Transfer'];

// ═══════════════════════════════════════════════════════════════════
//  MAIN SCREEN
// ═══════════════════════════════════════════════════════════════════
class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  // Step: 0=paket, 1=ruangan, 2=detail
  int _step = 0;

  Map<String, dynamic>? _selectedPackage;
  Map<String, dynamic>? _selectedRoom;
  String _selectedPayment = 'DANA';

  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _peopleController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _peopleController.dispose();
    super.dispose();
  }

  String _rupiah(int harga) => 'Rp ${harga.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
  )}';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: AppColors.black,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      _dateController.text =
      '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      setState(() {});
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: AppColors.black,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      _timeController.text = picked.format(context);
      setState(() {});
    }
  }

  void _onConfirm() async {
    if (_dateController.text.isEmpty ||
        _timeController.text.isEmpty ||
        _peopleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Lengkapi semua data terlebih dahulu.'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    final booking = BookingModel(
      studio: _selectedRoom!['name']!,
      category: _selectedPackage!['name']!,
      date: _dateController.text,
      time: _timeController.text,
      people: _peopleController.text,
      payment: _selectedPayment,
      price: _selectedPackage!['price'] as int,
      status: 'Pending',
    );

    String? docId;
    try {
      await BookingService.addBooking(booking);
      final bookings = await BookingService.getBookings();
      docId = bookings.isNotEmpty ? bookings.first.id : null;
    } catch (_) {}

    showDialog(
      context: context,
      builder: (_) => _ConfirmDialog(
        package: _selectedPackage!['name']!,
        room: _selectedRoom!['name']!,
        date: _dateController.text,
        time: _timeController.text,
        payment: _selectedPayment,
        price: _rupiah(_selectedPackage!['price'] as int),
        onPay: () async {
          if (docId != null) await BookingService.payBooking(docId!);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('✓ Pembayaran berhasil!'),
              backgroundColor: AppColors.black,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
          setState(() {
            _step = 0;
            _selectedPackage = null;
            _selectedRoom = null;
            _selectedPayment = 'DANA';
            _dateController.clear();
            _timeController.clear();
            _peopleController.clear();
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const HeaderSection(),

            // ── Step indicator ───────────────────────────────
            _StepIndicator(currentStep: _step),

            // ── Content ──────────────────────────────────────
            Expanded(
              child: _step == 0
                  ? _PackageStep(
                selected: _selectedPackage,
                rupiah: _rupiah,
                onSelect: (pkg) => setState(() {
                  _selectedPackage = pkg;
                }),
              )
                  : _step == 1
                  ? _RoomStep(
                selected: _selectedRoom,
                onSelect: (room) => setState(() {
                  _selectedRoom = room;
                }),
              )
                  : _DetailStep(
                package: _selectedPackage!,
                room: _selectedRoom!,
                dateController: _dateController,
                timeController: _timeController,
                peopleController: _peopleController,
                selectedPayment: _selectedPayment,
                onPaymentChanged: (v) =>
                    setState(() => _selectedPayment = v),
                onPickDate: _pickDate,
                onPickTime: _pickTime,
                rupiah: _rupiah,
              ),
            ),

            // ── Bottom nav buttons ────────────────────────────
            _BottomBar(
              step: _step,
              canNext: _step == 0
                  ? _selectedPackage != null
                  : _step == 1
                  ? _selectedRoom != null
                  : true,
              onBack: _step > 0
                  ? () => setState(() => _step--)
                  : null,
              onNext: _step < 2
                  ? () => setState(() => _step++)
                  : _onConfirm,
              nextLabel: _step < 2 ? 'Lanjut' : 'Konfirmasi Booking',
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  STEP INDICATOR
// ═══════════════════════════════════════════════════════════════════
class _StepIndicator extends StatelessWidget {
  final int currentStep;
  const _StepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    const labels = ['Pilih Paket', 'Pilih Ruangan', 'Detail'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      child: Row(
        children: List.generate(3, (i) {
          final isDone = i < currentStep;
          final isActive = i == currentStep;
          return Expanded(
            child: Row(
              children: [
                // Circle
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: isDone || isActive
                        ? AppColors.primary
                        : AppColors.background,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDone || isActive
                          ? AppColors.primary
                          : AppColors.lightGrey,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: isDone
                        ? const Icon(Icons.check_rounded,
                        size: 14, color: AppColors.black)
                        : Text('${i + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isActive
                              ? AppColors.black
                              : AppColors.grey,
                        )),
                  ),
                ),
                const SizedBox(width: 6),
                // Label
                Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight:
                    isActive ? FontWeight.w700 : FontWeight.normal,
                    color: isActive ? AppColors.black : AppColors.grey,
                  ),
                ),
                // Line connector
                if (i < 2)
                  Expanded(
                    child: Container(
                      height: 1.5,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      color: isDone ? AppColors.primary : AppColors.lightGrey,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

String _pkgImagePath(String pkgName) {
  const map = {
    'Personal Basic'      :   'assets/images/pkg_personal_basic.jpg',
    'Personal Premium'    :   'assets/images/pkg_personal_premium.jpg',
    'Graduation Standard' :   'assets/images/pkg_graduation_std.jpg',
    'Graduation Deluxe'   :   'assets/images/pkg_graduation_dlx.jpg',
    'Prewedding Romantic' :   'assets/images/pkg_prewedding_rom.jpg',
    'Prewedding Luxury'   :   'assets/images/pkg_prewedding_lux.jpg',
    'Product Photography' :   'assets/images/pkg_product.jpg',
  };
  return map[pkgName] ?? 'assets/images/pkg_personal_basic.jpg';
}

// ═══════════════════════════════════════════════════════════════════
//  STEP 1 — PILIH PAKET
// ═══════════════════════════════════════════════════════════════════
class _PackageStep extends StatelessWidget {
  final Map<String, dynamic>? selected;
  final String Function(int) rupiah;
  final ValueChanged<Map<String, dynamic>> onSelect;

  const _PackageStep({
    required this.selected,
    required this.rupiah,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      children: [
        const Text('Pilih Paket Foto',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.black)),
        const SizedBox(height: 4),
        const Text('Pilih paket yang sesuai kebutuhanmu',
            style: TextStyle(fontSize: 13, color: AppColors.grey)),
        const SizedBox(height: 16),
        ...(_packages as List<Map<String, dynamic>>).map((pkg) {
          final isSelected = selected?['name'] == pkg['name'];
          return GestureDetector(
            onTap: () => onSelect(pkg),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : Colors.transparent,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Row(
                children: [
                  // Thumbnail
                  SizedBox(
                    width: 90, height: 90,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          _pkgImagePath(pkg['name']!),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: AppColors.background),
                        ),
                        if (isSelected)
                          Container(
                            color: AppColors.primary.withOpacity(0.2),
                            child: const Center(
                              child: Icon(Icons.check_circle_rounded,
                                  color: AppColors.black, size: 28),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Info
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(pkg['name']!,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.black)),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(pkg['category']!,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: AppColors.grey,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(children: [
                            const Icon(Icons.access_time_outlined,
                                size: 12, color: AppColors.grey),
                            const SizedBox(width: 4),
                            Text(pkg['duration']!,
                                style: const TextStyle(
                                    fontSize: 12, color: AppColors.grey)),
                          ]),
                          const SizedBox(height: 6),
                          Text(rupiah(pkg['price'] as int),
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.black)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  STEP 2 — PILIH RUANGAN
// ═══════════════════════════════════════════════════════════════════
class _RoomStep extends StatelessWidget {
  final Map<String, dynamic>? selected;
  final ValueChanged<Map<String, dynamic>> onSelect;

  const _RoomStep({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      children: [
        const Text('Pilih Ruangan',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.black)),
        const SizedBox(height: 4),
        const Text('Semua ruangan tersedia untuk paket yang dipilih',
            style: TextStyle(fontSize: 13, color: AppColors.grey)),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: _rooms.length,
          itemBuilder: (_, i) {
            final room = _rooms[i] as Map<String, dynamic>;
            final isSelected = selected?['name'] == room['name'];
            return GestureDetector(
              onTap: () => onSelect(room),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.transparent,
                    width: 2.5,
                  ),
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
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _studioImage(room['seed']!, width: 300, height: 300),
                          if (isSelected)
                            Container(
                              color: AppColors.primary.withOpacity(0.2),
                              child: const Center(
                                child: Icon(Icons.check_circle_rounded,
                                    color: AppColors.black, size: 32),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(room['name']!,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.black)),
                          const SizedBox(height: 2),
                          Text(room['desc']!,
                              style: const TextStyle(
                                  fontSize: 10, color: AppColors.grey),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  STEP 3 — DETAIL
// ═══════════════════════════════════════════════════════════════════
class _DetailStep extends StatelessWidget {
  final Map<String, dynamic> package;
  final Map<String, dynamic> room;
  final TextEditingController dateController;
  final TextEditingController timeController;
  final TextEditingController peopleController;
  final String selectedPayment;
  final ValueChanged<String> onPaymentChanged;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;
  final String Function(int) rupiah;

  const _DetailStep({
    required this.package,
    required this.room,
    required this.dateController,
    required this.timeController,
    required this.peopleController,
    required this.selectedPayment,
    required this.onPaymentChanged,
    required this.onPickDate,
    required this.onPickTime,
    required this.rupiah,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      children: [
        const Text('Detail Booking',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.black)),
        const SizedBox(height: 4),
        const Text('Lengkapi informasi sesi fotomu',
            style: TextStyle(fontSize: 13, color: AppColors.grey)),
        const SizedBox(height: 16),

        // ── Summary card ────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF5EFE6),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              _SummaryRow('Paket', package['name']!),
              const SizedBox(height: 6),
              _SummaryRow('Ruangan', room['name']!),
              const SizedBox(height: 6),
              _SummaryRow('Durasi', package['duration']!),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // ── Date & Time ─────────────────────────────────────
        const _Label('Tanggal & Jam'),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(
            child: _PickerField(
              controller: dateController,
              hint: 'Pilih tanggal',
              icon: Icons.calendar_today_outlined,
              onTap: onPickDate,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _PickerField(
              controller: timeController,
              hint: 'Pilih jam',
              icon: Icons.access_time_outlined,
              onTap: onPickTime,
            ),
          ),
        ]),

        const SizedBox(height: 14),

        // ── People ──────────────────────────────────────────
        const _Label('Jumlah Orang'),
        const SizedBox(height: 10),
        _InputField(
          controller: peopleController,
          hint: 'Contoh: 2',
          icon: Icons.people_outline,
          keyboardType: TextInputType.number,
        ),

        const SizedBox(height: 20),

        // ── Payment ─────────────────────────────────────────
        const _Label('Metode Pembayaran'),
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
          child: DropdownButtonFormField<String>(
            value: selectedPayment,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.payment_outlined,
                  color: AppColors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
            ),
            items: _payments
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => onPaymentChanged(v!),
          ),
        ),

        const SizedBox(height: 20),

        // ── Price summary ────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(16),
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
          child: Column(
            children: [
              _SummaryRow('Harga Paket', rupiah(package['price'] as int)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                    height: 1,
                    color: AppColors.primary.withOpacity(0.3)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Pembayaran',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black)),
                  Text(rupiah(package['price'] as int),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.black)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  BOTTOM BAR
// ═══════════════════════════════════════════════════════════════════
class _BottomBar extends StatelessWidget {
  final int step;
  final bool canNext;
  final VoidCallback? onBack;
  final VoidCallback onNext;
  final String nextLabel;

  const _BottomBar({
    required this.step,
    required this.canNext,
    required this.onBack,
    required this.onNext,
    required this.nextLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (onBack != null) ...[
            GestureDetector(
              onTap: onBack,
              child: Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back_rounded,
                    color: AppColors.black, size: 22),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 180),
              opacity: canNext ? 1.0 : 0.45,
              child: ElevatedButton(
                onPressed: canNext ? onNext : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.black,
                  disabledBackgroundColor: AppColors.primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(nextLabel,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  CONFIRM DIALOG
// ═══════════════════════════════════════════════════════════════════
class _ConfirmDialog extends StatelessWidget {
  final String package;
  final String room;
  final String date;
  final String time;
  final String payment;
  final String price;
  final VoidCallback onPay;

  const _ConfirmDialog({
    required this.package,
    required this.room,
    required this.date,
    required this.time,
    required this.payment,
    required this.price,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EFE6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.receipt_long_outlined,
                    color: AppColors.black, size: 22),
              ),
              const SizedBox(width: 12),
              const Text('Konfirmasi Booking',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black)),
            ]),
            const SizedBox(height: 16),
            Container(height: 1, color: AppColors.lightGrey),
            const SizedBox(height: 14),
            _DialogRow('Paket', package),
            const SizedBox(height: 6),
            _DialogRow('Ruangan', room),
            const SizedBox(height: 6),
            _DialogRow('Tanggal', date),
            const SizedBox(height: 6),
            _DialogRow('Jam', time),
            const SizedBox(height: 6),
            _DialogRow('Pembayaran', payment),
            const SizedBox(height: 6),
            _DialogRow('Total', price, bold: true),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.lightGrey),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    foregroundColor: AppColors.black,
                  ),
                  child: const Text('Batal',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: onPay,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Bayar',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  SMALL WIDGETS
// ═══════════════════════════════════════════════════════════════════
class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.black));
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow(this.label, this.value);
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label,
          style: const TextStyle(fontSize: 13, color: AppColors.grey)),
      Text(value,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.black)),
    ],
  );
}

class _DialogRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _DialogRow(this.label, this.value, {this.bold = false});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label,
          style: const TextStyle(fontSize: 13, color: AppColors.grey)),
      Text(value,
          style: TextStyle(
              fontSize: 13,
              fontWeight:
              bold ? FontWeight.w700 : FontWeight.w500,
              color: AppColors.black)),
    ],
  );
}

class _PickerField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final VoidCallback onTap;
  const _PickerField(
      {required this.controller,
        required this.hint,
        required this.icon,
        required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AbsorbPointer(
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
          const TextStyle(fontSize: 13, color: AppColors.grey),
          prefixIcon:
          Icon(icon, color: AppColors.grey, size: 20),
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 14, vertical: 14),
        ),
      ),
    ),
  );
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  const _InputField(
      {required this.controller,
        required this.hint,
        required this.icon,
        this.keyboardType = TextInputType.text});
  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle:
      const TextStyle(fontSize: 13, color: AppColors.grey),
      prefixIcon: Icon(icon, color: AppColors.grey, size: 20),
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(
          horizontal: 14, vertical: 14),
    ),
  );
}