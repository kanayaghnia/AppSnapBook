import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapbook/theme/colors.dart';
import 'package:snapbook/services/auth_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _usernameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  bool _loading = false;
  String? _photoPath;

  @override
  void initState() {
    super.initState();
    _usernameCtrl = TextEditingController(text: AuthService.currentUsername);
    _emailCtrl    = TextEditingController(text: AuthService.currentEmail);
    _phoneCtrl    = TextEditingController(text: AuthService.currentPhone);
    _photoPath    = AuthService.currentPhotoPath;
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const Text('Pilih Foto Profil',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.black)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80, maxWidth: 500);
                      if (picked != null) setState(() => _photoPath = picked.path);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(14)),
                      child: const Column(children: [
                        Icon(Icons.photo_library_outlined, size: 28, color: AppColors.black),
                        SizedBox(height: 8),
                        Text('Galeri', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.black)),
                      ]),
                    ),
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      final picked = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 80, maxWidth: 500);
                      if (picked != null) setState(() => _photoPath = picked.path);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(14)),
                      child: const Column(children: [
                        Icon(Icons.camera_alt_outlined, size: 28, color: AppColors.black),
                        SizedBox(height: 8),
                        Text('Kamera', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.black)),
                      ]),
                    ),
                  )),
                ],
              ),
              if (AuthService.currentPhotoPath != null) ...[
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () { setState(() => _photoPath = null); Navigator.pop(context); },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(color: const Color(0xFFFFE4E4), borderRadius: BorderRadius.circular(14)),
                    child: const Text('Hapus Foto', textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFEF4444))),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _save() async {
    setState(() => _loading = true);

    final success = await AuthService.updateProfile(
      username: _usernameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      photoPath: _photoPath,
    );

    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AuthService.message),
        backgroundColor: success ? AppColors.black : Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    if (success) Navigator.pop(context, true); // true = ada perubahan
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Edit Profil',
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
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
        child: Column(
          children: [
            // ── Avatar ──────────────────────────────────────────
            GestureDetector(
              onTap: _pickPhoto,
              child: Stack(
                children: [
                  Container(
                    width: 90, height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(0.2),
                      border: Border.all(color: AppColors.primary, width: 2.5),
                    ),
                    child: ClipOval(
                      child: _photoPath != null
                          ? Image.file(File(_photoPath!), fit: BoxFit.cover, width: 90, height: 90)
                          : Center(
                        child: Text(
                          AuthService.currentUsername.isNotEmpty
                              ? AuthService.currentUsername[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt_outlined, size: 13, color: AppColors.black),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            const Text('Tap untuk ganti foto',
                style: TextStyle(fontSize: 12, color: AppColors.grey)),

            const SizedBox(height: 22),

            // ── Form ────────────────────────────────────────────
            _FormField(
              controller: _usernameCtrl,
              label: 'Username',
              hint: 'Masukkan username',
              icon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 14),
            _FormField(
              controller: _emailCtrl,
              label: 'Email',
              hint: 'Masukkan email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 14),
            _FormField(
              controller: _phoneCtrl,
              label: 'Nomor Telepon',
              hint: 'Contoh: 08123456789',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 32),

            // ── Save button ─────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.black,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: _loading
                    ? const SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppColors.black))
                    : const Text(
                  'Simpan Perubahan',
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

// ─── Form Field ───────────────────────────────────────────────────
class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;

  const _FormField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.black)),
        const SizedBox(height: 8),
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
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 14, color: AppColors.black),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:
              const TextStyle(fontSize: 13, color: AppColors.grey),
              prefixIcon: Icon(icon, color: AppColors.grey, size: 20),
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
      ],
    );
  }
}