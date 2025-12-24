import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  Future<String> uploadPropertyImage({
    required String propertyId,
    required File file,
  }) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child("properties")
        .child(propertyId)
        .child("cover.jpg");

    await ref.putFile(file);
    return await ref.getDownloadURL();
  }
}
