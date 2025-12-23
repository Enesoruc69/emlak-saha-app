import 'package:cloud_firestore/cloud_firestore.dart';

class Property {
  final String id;
  final String baslik;
  final double fiyat;
  final double m2;
  final String? imageUrl;
  final GeoPoint? location;
  final Timestamp createdAt;

  Property({
    required this.id,
    required this.baslik,
    required this.fiyat,
    required this.m2,
    this.imageUrl,
    this.location,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "baslik": baslik,
      "fiyat": fiyat,
      "m2": m2,
      "imageUrl": imageUrl,
      "location": location,
      "createdAt": createdAt,
    };
  }
}
