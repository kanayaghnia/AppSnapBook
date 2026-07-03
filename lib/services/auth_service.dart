import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snapbook/services/favorite_service.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _db = FirebaseFirestore.instance;

  // Data user yang sedang login (diisi setelah login/register)
  static String currentUsername = '';
  static String currentEmail = '';
  static String currentPhone = '';
  static String? currentPhotoPath;

  static String message = '';

  static bool get isLoggedIn => _auth.currentUser != null;
  static String? get currentUid => _auth.currentUser?.uid;

  // ── REGISTER ─────────────────────────────────────────────────
  static Future<bool> register({
    required String username,
    required String email,
    required String password,
  }) async {
    // Validasi lokal
    if (username.isEmpty) {
      message = 'Username wajib diisi';
      return false;
    }
    if (email.isEmpty || password.isEmpty) {
      message = 'Email dan Password wajib diisi';
      return false;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      message = 'Format email tidak valid';
      return false;
    }
    if (!RegExp(r'^(?=.*[A-Z])(?=.*[0-9]).{6,}$').hasMatch(password)) {
      message = 'Password wajib ada huruf besar dan angka';
      return false;
    }

    try {
      // Buat account di Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Simpan data user ke Firestore
      await _db.collection('users').doc(credential.user!.uid).set({
        'username': username,
        'email': email,
        'phone': '',
        'photoPath': null,
        'createdAt': FieldValue.serverTimestamp(),
      });

      message = 'Register berhasil';
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Email sudah terdaftar';
          break;
        case 'weak-password':
          message = 'Password terlalu lemah';
          break;
        case 'invalid-email':
          message = 'Format email tidak valid';
          break;
        default:
          message = 'Register gagal: ${e.message}';
      }
      return false;
    }
  }

  // ── LOGIN ─────────────────────────────────────────────────────
  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      message = 'Email dan Password wajib diisi';
      return false;
    }

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ambil data user dari Firestore
      await loadCurrentUser();

      message = 'Login berhasil';
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          message = 'Email atau Password salah';
          break;
        case 'user-disabled':
          message = 'Akun dinonaktifkan';
          break;
        default:
          message = 'Login gagal: ${e.message}';
      }
      return false;
    }
  }

  // ── LOAD USER DATA ────────────────────────────────────────────
  static Future<void> loadCurrentUser() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      currentUsername = data['username'] ?? '';
      currentEmail = data['email'] ?? '';
      currentPhone = data['phone'] ?? '';
      currentPhotoPath = data['photoPath'];
    }

    await FavoriteService.load();
  }

  // ── UPDATE PROFILE ────────────────────────────────────────────
  static Future<bool> updateProfile({
    required String username,
    required String email,
    required String phone,
    String? photoPath,
  }) async {
    if (username.isEmpty) {
      message = 'Username wajib diisi';
      return false;
    }
    if (email.isEmpty) {
      message = 'Email wajib diisi';
      return false;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      message = 'Format email tidak valid';
      return false;
    }

    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      message = 'User tidak ditemukan';
      return false;
    }

    try {
      final Map<String, dynamic> updates = {
        'username': username,
        'email': email,
        'phone': phone,
      };
      if (photoPath != null) updates['photoPath'] = photoPath;

      await _db.collection('users').doc(uid).update(updates);

      currentUsername = username;
      currentEmail = email;
      currentPhone = phone;
      if (photoPath != null) currentPhotoPath = photoPath;

      message = 'Profil berhasil diperbarui';
      return true;
    } catch (e) {
      message = 'Gagal memperbarui profil';
      return false;
    }
  }

  // ── LOGOUT ────────────────────────────────────────────────────
  static Future<void> logout() async {
    await _auth.signOut();
    currentUsername = '';
    currentEmail = '';
    currentPhone = '';
    currentPhotoPath = null;
  }
}