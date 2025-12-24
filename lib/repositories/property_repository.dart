import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/property.dart';

class PropertyRepository {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection("properties");

  Future<String> addProperty(Property property) async {
    final doc = await _collection.add(property.toMap());
    return doc.id;
  }

  Stream<List<Property>> getProperties() {
    return _collection
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Property.fromMap(
                    doc.id,
                    doc.data() as Map<String, dynamic>,
                  ))
              .toList();
        });
  }

  Future<void> updateLocation(
    String propertyId,
    GeoPoint location,
  ) async {
    await _collection.doc(propertyId).update({
      "location": location,
    });
  }
  Future<void> updateImage(
  String propertyId,
  String imageUrl,
) async {
  await _collection.doc(propertyId).update({
    "imageUrl": imageUrl,
  });
}

}
