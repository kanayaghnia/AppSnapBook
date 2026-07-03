import 'package:flutter/material.dart';
import 'package:snapbook/theme/colors.dart';
import 'package:snapbook/screens/home/home_screen.dart';
import 'package:snapbook/screens/booking/booking_screen.dart';
import 'package:snapbook/screens/studio/studio_screen.dart';
import 'package:snapbook/screens/account/account_screen.dart';
import 'package:snapbook/screens/riwayat/history_booking_user.dart';
import 'package:snapbook/screens/about/about_us_screen.dart';
import 'package:snapbook/screens/help/help_center_screen.dart';
import 'package:snapbook/screens/promotions/promotions_screen.dart';
import 'package:snapbook/screens/auth/auth_screen.dart';
import 'package:snapbook/screens/studio/favorite_studios_screen.dart';
import 'package:snapbook/services/auth_service.dart';

// ═══════════════════════════════════════════════════════════════════
//  NAVIGATION HELPER
//  Pakai dari widget mana pun: NavigationHelper.of(context)?.goToTab(1)
// ═══════════════════════════════════════════════════════════════════
class NavigationHelper extends InheritedWidget {
  final void Function(int index) goToTab;

  const NavigationHelper({
    super.key,
    required this.goToTab,
    required super.child,
  });

  static NavigationHelper? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<NavigationHelper>();

  @override
  bool updateShouldNotify(NavigationHelper oldWidget) => false;
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  bool _isLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    await AuthService.loadCurrentUser();
    if (mounted) setState(() => _isLoading = false);
  }

  void _onTap(int index) => setState(() => _selectedIndex = index);
  void goToTab(int index) => _onTap(index);

  List<Widget> _buildPages() => [
    HomeScreen(onBookingTap: () => _onTap(1)),
    const BookingScreen(),
    StudioScreen(onBookingTap: () => _onTap(1)),
    // Key supaya Riwayat rebuild setiap kali tab dipilih → data booking terbaru langsung muncul
    HistoryBookingUser(key: ValueKey(_selectedIndex == 3 ? DateTime.now().millisecondsSinceEpoch : 0)),
    const AkunPage(),
  ];

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFFAF8F5),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFC9A96E),
            strokeWidth: 2,
          ),
        ),
      );
    }

    return NavigationHelper(
      goToTab: _onTap,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.background,
        drawer: _AppDrawer(scaffoldKey: _scaffoldKey),
        body: _buildPages()[_selectedIndex],
        bottomNavigationBar: Container(
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
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(icon: Icons.home_rounded,            label: 'Beranda', index: 0, selected: _selectedIndex, onTap: _onTap),
                  _NavItem(icon: Icons.calendar_month_outlined, label: 'Booking', index: 1, selected: _selectedIndex, onTap: _onTap),
                  _NavItem(icon: Icons.camera_alt_outlined,     label: 'Studio',  index: 2, selected: _selectedIndex, onTap: _onTap),
                  _NavItem(icon: Icons.receipt_long_outlined,   label: 'Riwayat', index: 3, selected: _selectedIndex, onTap: _onTap),
                  _NavItem(icon: Icons.person_outline_rounded,  label: 'Akun',    index: 4, selected: _selectedIndex, onTap: _onTap),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Nav Item ─────────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int selected;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = selected == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24, color: isActive ? AppColors.primary : AppColors.grey),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isActive ? AppColors.primary : AppColors.grey,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  DRAWER
// ═══════════════════════════════════════════════════════════════════
class _AppDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const _AppDrawer({required this.scaffoldKey});

  void _close(BuildContext context) => Navigator.pop(context);

  void _navigate(BuildContext context, Widget screen) {
    _close(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  void _goToTab(BuildContext context, int index) {
    _close(context);
    context.findAncestorStateOfType<_MainNavigationState>()
        ?._onTap(index);
  }

  void _showLogoutDialog(BuildContext context) {
    _close(context);
    final outerContext = context;
    showDialog(
      context: outerContext,
      builder: (ctx) => Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFE4E4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.logout_rounded,
                    color: Color(0xFFEF4444), size: 28),
              ),
              const SizedBox(height: 16),
              const Text(
                'Keluar dari Akun?',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black),
              ),
              const SizedBox(height: 8),
              const Text(
                'Kamu yakin ingin keluar dari account ini?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.grey),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
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
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pushAndRemoveUntil(
                          outerContext,
                          MaterialPageRoute(
                              builder: (_) => const AuthScreen()),
                              (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Keluar',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
                24, MediaQuery.of(context).padding.top + 24, 24, 28),
            decoration: const BoxDecoration(color: AppColors.background),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 46, height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(Icons.camera_alt_outlined,
                          color: AppColors.black, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Snap',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.black),
                              ),
                              TextSpan(
                                text: 'Book',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                        const Text('Photo Studio Booking',
                            style: TextStyle(
                                fontSize: 11, color: AppColors.grey)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(height: 1, color: AppColors.lightGrey),
          const SizedBox(height: 8),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              children: [
                _DrawerItem(
                  icon: Icons.favorite_border_rounded,
                  label: 'Favorite Studios',
                  onTap: () => _navigate(context, const FavoriteStudiosScreen()),
                ),
                _DrawerItem(
                  icon: Icons.local_offer_outlined,
                  label: 'Promotions',
                  onTap: () => _navigate(context, const PromotionsScreen()),
                ),
                _DrawerItem(
                  icon: Icons.help_outline_rounded,
                  label: 'Help Center',
                  onTap: () => _navigate(context, const HelpCenterScreen()),
                ),
                _DrawerItem(
                  icon: Icons.info_outline_rounded,
                  label: 'About Us',
                  onTap: () => _navigate(context, const AboutUsScreen()),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 16),
            child: const Text('SnapBook v1.0.0',
                style: TextStyle(fontSize: 11, color: AppColors.grey)),
          ),
        ],
      ),
    );
  }
}

// ─── Drawer Item ──────────────────────────────────────────────────
class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDestructive;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color =
    isDestructive ? const Color(0xFFEF4444) : AppColors.black;
    final bgColor =
    isDestructive ? const Color(0xFFFFE4E4) : AppColors.white;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(11)),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 14),
              Text(label,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: color)),
              const Spacer(),
              if (!isDestructive)
                const Icon(Icons.chevron_right,
                    size: 18, color: AppColors.grey),
            ],
          ),
        ),
      ),
    );
  }
}