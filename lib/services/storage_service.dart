import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadPropertyImage({
    required String propertyId,
    required File file,
  }) async {
    final ref = _storage
        .ref()
        .child("properties/$propertyId/main.jpg");

    await ref.putFile(file);
    return await ref.getDownloadURL();
  }
}
