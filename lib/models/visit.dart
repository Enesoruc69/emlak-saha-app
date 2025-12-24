import 'package:cloud_firestore/cloud_firestore.dart';

class Visit {
  final String id;
  final String propertyId;
  final String propertyTitle;
  final String clientName;
  final DateTime visitDate;
  final Timestamp createdAt;

  Visit({
    required this.id,
    required this.propertyId,
    required this.propertyTitle,
    required this.clientName,
    required this.visitDate,
    required this.createdAt,
  });

  factory Visit.fromMap(String id, Map<String, dynamic> map) {
    return Visit(
      id: id,
      propertyId: map['propertyId'],
      propertyTitle: map['propertyTitle'],
      clientName: map['clientName'],
      visitDate: (map['visitDate'] as Timestamp).toDate(),
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "propertyId": propertyId,
      "propertyTitle": propertyTitle,
      "clientName": clientName,
      "visitDate": Timestamp.fromDate(visitDate),
      "createdAt": createdAt,
    };
  }
}
