import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snapbook/services/auth_service.dart';
import '../models/booking_model.dart';

class BookingService {
  static final _db = FirebaseFirestore.instance;

  // ── Collection reference untuk user yang login ───────────────
  static CollectionReference get _bookingsRef => _db
      .collection('users')
      .doc(AuthService.currentUid)
      .collection('bookings');

  // ── ADD BOOKING ───────────────────────────────────────────────
  static Future<void> addBooking(BookingModel booking) async {
    await _bookingsRef.add(booking.toMap());
  }

  // ── GET ALL BOOKINGS ──────────────────────────────────────────
  static Future<List<BookingModel>> getBookings() async {
    final snapshot = await _bookingsRef
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => BookingModel.fromMap(
        doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // ── PAY BOOKING ───────────────────────────────────────────────
  static Future<void> payBooking(String docId) async {
    await _bookingsRef.doc(docId).update({'status': 'Lunas'});
  }

  // ── RATE BOOKING ──────────────────────────────────────────────
  static Future<void> rateBooking(String docId, int rating) async {
    await _bookingsRef.doc(docId).update({'rating': rating});
  }

  // ── DELETE BOOKING ────────────────────────────────────────────
  static Future<void> deleteBooking(String docId) async {
    await _bookingsRef.doc(docId).delete();
  }
}