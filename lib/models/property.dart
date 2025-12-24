import 'package:cloud_firestore/cloud_firestore.dart';

class Property {
  final String id;
  final String baslik;
  final double fiyat;
  final double m2;
  final String? imageUrl;
  final GeoPoint? location;
  final Timestamp createdAt;
  final String type; // daire, villa, arsa, isyeri

  Property({
    required this.id,
    required this.baslik,
    required this.fiyat,
    required this.m2,
    this.imageUrl,
    this.location,
    required this.createdAt,
    required this.type,
  });

  Property copyWith({
    String? id,
    String? baslik,
    double? fiyat,
    double? m2,
    String? imageUrl,
    GeoPoint? location,
    Timestamp? createdAt,
    String? type,
  }) {
    return Property(
      id: id ?? this.id,
      baslik: baslik ?? this.baslik,
      fiyat: fiyat ?? this.fiyat,
      m2: m2 ?? this.m2,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
    );
  }

  factory Property.fromMap(String id, Map<String, dynamic> map) {
    return Property(
      id: id,
      baslik: map['baslik'] ?? '',
      fiyat: (map['fiyat'] ?? 0).toDouble(),
      m2: (map['m2'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'],
      location: map['location'],
      createdAt: map['createdAt'],
      type: map['type'] ?? 'daire', 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "baslik": baslik,
      "fiyat": fiyat,
      "m2": m2,
      "type": type,
      "imageUrl": imageUrl,
      "location": location,
      "createdAt": createdAt,
    };
  }
}
