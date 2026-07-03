class BookingModel {
  final String? id; // Firestore document ID
  final String studio;
  final String category;
  final String date;
  final String time;
  final String people;
  final String payment;
  final int price;
  final String status;
  final int? rating;

  BookingModel({
    this.id,
    required this.studio,
    required this.category,
    required this.date,
    required this.time,
    required this.people,
    required this.payment,
    required this.price,
    required this.status,
    this.rating,
  });

  // ── Untuk simpan ke Firestore ─────────────────────────────────
  Map<String, dynamic> toMap() {
    return {
      'studio': studio,
      'category': category,
      'date': date,
      'time': time,
      'people': people,
      'payment': payment,
      'price': price,
      'status': status,
      'rating': rating,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  // ── Untuk baca dari Firestore ─────────────────────────────────
  factory BookingModel.fromMap(Map<String, dynamic> map, String id) {
    return BookingModel(
      id: id,
      studio: map['studio'] ?? '',
      category: map['category'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      people: map['people'] ?? '',
      payment: map['payment'] ?? '',
      price: map['price'] ?? 0,
      status: map['status'] ?? '',
      rating: map['rating'],
    );
  }

  BookingModel copyWith({
    String? id,
    String? studio,
    String? category,
    String? date,
    String? time,
    String? people,
    String? payment,
    int? price,
    String? status,
    int? rating,
  }) {
    return BookingModel(
      id: id ?? this.id,
      studio: studio ?? this.studio,
      category: category ?? this.category,
      date: date ?? this.date,
      time: time ?? this.time,
      people: people ?? this.people,
      payment: payment ?? this.payment,
      price: price ?? this.price,
      status: status ?? this.status,
      rating: rating ?? this.rating,
    );
  }
}