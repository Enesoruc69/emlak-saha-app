import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/visit.dart';

class VisitRepository {
  final _collection =
      FirebaseFirestore.instance.collection("visits");

  Future<void> addVisit(Visit visit) async {
    await _collection.add(visit.toMap());
  }

  Stream<List<Visit>> getVisitsForProperty(String propertyId) {
    return _collection
        .where("propertyId", isEqualTo: propertyId)
        .orderBy("visitDate")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              Visit.fromMap(doc.id, doc.data()))
          .toList();
    });
  }
}
