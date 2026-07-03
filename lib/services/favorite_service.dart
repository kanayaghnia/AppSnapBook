import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snapbook/services/auth_service.dart';

class FavoriteService {
  FavoriteService._();

  static final _db = FirebaseFirestore.instance;

  static DocumentReference get _favDoc => _db
      .collection('users')
      .doc(AuthService.currentUid)
      .collection('data')
      .doc('favorites');

  // Cache lokal biar isFavorite tidak perlu async
  static final Set<String> _cache = {};
  static bool _loaded = false;

  // ── Load dari Firestore (panggil sekali setelah login) ────────
  static Future<void> load() async {
    if (AuthService.currentUid == null) return;
    try {
      final doc = await _favDoc.get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final list = List<String>.from(data['studios'] ?? []);
        _cache
          ..clear()
          ..addAll(list);
      }
      _loaded = true;
    } catch (_) {}
  }

  // ── Cek favorit (sync, pakai cache) ──────────────────────────
  static bool isFavorite(String studioName) =>
      _cache.contains(studioName);

  // ── Toggle favorit ────────────────────────────────────────────
  static Future<void> toggle(String studioName) async {
    if (_cache.contains(studioName)) {
      _cache.remove(studioName);
    } else {
      _cache.add(studioName);
    }

    // Simpan ke Firestore
    try {
      await _favDoc.set({'studios': _cache.toList()});
    } catch (_) {}
  }

  static List<String> get favoriteNames => _cache.toList();
}