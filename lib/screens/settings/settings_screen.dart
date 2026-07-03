import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:snapbook/theme/colors.dart';
import 'package:snapbook/services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ── Notifikasi state ──────────────────────────────────────────
  bool _notifBooking = true;
  bool _notifPromo = true;
  bool _notifReminder = false;

  // ── Bahasa state ──────────────────────────────────────────────
  String _selectedLang = 'Indonesia';
  final List<String> _languages = ['Indonesia', 'English'];

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
          'Pengaturan',
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
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          // ── NOTIFIKASI ────────────────────────────────────────
          const _SectionLabel('Notifikasi'),
          const SizedBox(height: 10),
          _MenuCard(children: [
            _SwitchItem(
              icon: Icons.calendar_month_outlined,
              label: 'Konfirmasi Booking',
              subtitle: 'Notif saat booking dikonfirmasi',
              value: _notifBooking,
              onChanged: (v) => setState(() => _notifBooking = v),
            ),
            _Divider(),
            _SwitchItem(
              icon: Icons.local_offer_outlined,
              label: 'Promo & Diskon',
              subtitle: 'Info promo terbaru dari studio',
              value: _notifPromo,
              onChanged: (v) => setState(() => _notifPromo = v),
            ),
            _Divider(),
            _SwitchItem(
              icon: Icons.alarm_outlined,
              label: 'Pengingat Sesi',
              subtitle: 'Reminder H-1 sebelum sesi foto',
              value: _notifReminder,
              onChanged: (v) => setState(() => _notifReminder = v),
            ),
          ]),

          const SizedBox(height: 20),

          // ── BAHASA ────────────────────────────────────────────
          const _SectionLabel('Bahasa'),
          const SizedBox(height: 10),
          _MenuCard(children: [
            ..._languages.map((lang) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _RadioItem(
                  icon: Icons.language_outlined,
                  label: lang,
                  selected: _selectedLang == lang,
                  onTap: () => setState(() => _selectedLang = lang),
                ),
                if (lang != _languages.last) _Divider(),
              ],
            )),
          ]),

          const SizedBox(height: 20),

          // ── PRIVASI & KEAMANAN ────────────────────────────────
          const _SectionLabel('Privasi & Keamanan'),
          const SizedBox(height: 10),
          _MenuCard(children: [
            _MenuItem(
              icon: Icons.lock_outline_rounded,
              label: 'Ubah Password',
              onTap: () => _showChangePasswordSheet(context),
            ),
            _Divider(),
            _MenuItem(
              icon: Icons.shield_outlined,
              label: 'Kebijakan Privasi',
              onTap: () => _showInfoDialog(
                context,
                title: 'Kebijakan Privasi',
                content:
                'SnapBook berkomitmen menjaga privasi data kamu. Data yang dikumpulkan hanya digunakan untuk keperluan layanan booking studio foto dan tidak dibagikan ke pihak ketiga tanpa persetujuan kamu.',
              ),
            ),
            _Divider(),
            _MenuItem(
              icon: Icons.description_outlined,
              label: 'Syarat & Ketentuan',
              onTap: () => _showInfoDialog(
                context,
                title: 'Syarat & Ketentuan',
                content:
                'Dengan menggunakan SnapBook, kamu menyetujui syarat dan ketentuan layanan kami. Pembatalan booking dikenakan biaya sesuai kebijakan masing-masing studio. SnapBook berhak memperbarui ketentuan ini sewaktu-waktu.',
              ),
            ),
          ]),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ── CHANGE PASSWORD BOTTOM SHEET ──────────────────────────────
  void _showChangePasswordSheet(BuildContext context) {
    final oldCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    bool obscureOld = true;
    bool obscureNew = true;
    bool obscureConfirm = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.fromLTRB(
              24, 20, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Ubah Password',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 20),

              // Password lama
              _PasswordField(
                controller: oldCtrl,
                hint: 'Password lama',
                obscure: obscureOld,
                onToggle: () => setSheet(() => obscureOld = !obscureOld),
              ),
              const SizedBox(height: 12),

              // Password baru
              _PasswordField(
                controller: newCtrl,
                hint: 'Password baru',
                obscure: obscureNew,
                onToggle: () => setSheet(() => obscureNew = !obscureNew),
              ),
              const SizedBox(height: 12),

              // Konfirmasi password baru
              _PasswordField(
                controller: confirmCtrl,
                hint: 'Konfirmasi password baru',
                obscure: obscureConfirm,
                onToggle: () =>
                    setSheet(() => obscureConfirm = !obscureConfirm),
              ),
              const SizedBox(height: 24),

              // Tombol simpan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _submitChangePassword(
                    context: ctx,
                    oldPassword: oldCtrl.text,
                    newPassword: newCtrl.text,
                    confirmPassword: confirmCtrl.text,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.black,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Simpan Password',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitChangePassword({
    required BuildContext context,
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    // Validasi password baru tidak boleh sama dengan lama
    if (newPassword == oldPassword) {
      _showSnack(context,
          'Password baru tidak boleh sama dengan yang lama',
          isError: true);
      return;
    }

    // Validasi format password baru
    final valid =
    RegExp(r'^(?=.*[A-Z])(?=.*[0-9]).{6,}$').hasMatch(newPassword);
    if (!valid) {
      _showSnack(context,
          'Password wajib ada huruf besar dan angka (min. 6 karakter)',
          isError: true);
      return;
    }

    // Validasi konfirmasi
    if (newPassword != confirmPassword) {
      _showSnack(context, 'Konfirmasi password tidak cocok', isError: true);
      return;
    }

    // Re-authenticate dulu, lalu update password via Firebase
    try {
      final user = FirebaseAuth.instance.currentUser;
      final email = user?.email ?? '';
      final credential = EmailAuthProvider.credential(
          email: email, password: oldPassword);
      await user?.reauthenticateWithCredential(credential);
      await user?.updatePassword(newPassword);
      Navigator.pop(context);
      _showSnack(context, 'Password berhasil diubah');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        _showSnack(context, 'Password lama salah', isError: true);
      } else {
        _showSnack(context, 'Gagal mengubah password', isError: true);
      }
    }
  }

  void _showSnack(BuildContext context, String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red.shade400 : AppColors.black,
        behavior: SnackBarBehavior.floating,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showInfoDialog(BuildContext context,
      {required String title, required String content}) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppColors.white,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black)),
              const SizedBox(height: 12),
              Text(content,
                  style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.grey,
                      height: 1.6)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Tutup',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  REUSABLE WIDGETS
// ═══════════════════════════════════════════════════════════════════
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: AppColors.black,
    ),
  );
}

class _MenuCard extends StatelessWidget {
  final List<Widget> children;
  const _MenuCard({required this.children});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    clipBehavior: Clip.antiAlias,
    child: Column(children: children),
  );
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    height: 1,
    margin: const EdgeInsets.symmetric(horizontal: 16),
    color: AppColors.lightGrey,
  );
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _MenuItem({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: AppColors.black, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black)),
            ),
            const Icon(Icons.chevron_right,
                size: 20, color: AppColors.grey),
          ],
        ),
      ),
    ),
  );
}

class _SwitchItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: AppColors.black, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.grey)),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          thumbColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected)
              ? AppColors.black
              : Colors.white),
          trackColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.lightGrey),
          trackOutlineColor:
          WidgetStateProperty.all(Colors.transparent),
        ),
      ],
    ),
  );
}

class _RadioItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RadioItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: AppColors.black, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black)),
            ),
            if (selected)
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.primary, size: 22)
            else
              const Icon(Icons.circle_outlined,
                  color: AppColors.lightGrey, size: 22),
          ],
        ),
      ),
    ),
  );
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final VoidCallback onToggle;

  const _PasswordField({
    required this.controller,
    required this.hint,
    required this.obscure,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(12),
    ),
    child: TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(fontSize: 14, color: AppColors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
        const TextStyle(fontSize: 14, color: AppColors.grey),
        prefixIcon: const Icon(Icons.lock_outline_rounded,
            color: AppColors.grey, size: 20),
        suffixIcon: IconButton(
          icon: Icon(
            obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.grey,
            size: 20,
          ),
          onPressed: onToggle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
      ),
    ),
  );
}