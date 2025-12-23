import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/property.dart';

class PropertyRepository {
  final _collection = FirebaseFirestore.instance.collection("properties");

  Future<String> addProperty(Property property) async {
    final doc = await _collection.add(property.toMap());
    return doc.id;
  }

  Future<void> updateImage(String propertyId, String imageUrl) async {
    await _collection.doc(propertyId).update({"imageUrl": imageUrl});
  }

  Future<void> updateLocation(String propertyId, GeoPoint location) async {
    await _collection.doc(propertyId).update({"location": location});
  }
}
