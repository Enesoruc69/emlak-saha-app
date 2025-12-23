import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/property.dart';
import '../../repositories/property_repository.dart';
import '../../services/storage_service.dart';
import '../../services/location_service.dart';


class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({super.key});

  @override
  State<AddPropertyScreen> createState() =>
      _AddPropertyScreenState();
      
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final _baslikCtrl = TextEditingController();
  final _fiyatCtrl = TextEditingController();
  final _m2Ctrl = TextEditingController();
  final _locationService = LocationService();


  File? _image;
  bool _loading = false;

  final _picker = ImagePicker();
  final _repo = PropertyRepository();
  final _storage = StorageService();

  Future<void> _pickImage() async {
    final XFile? picked =
        await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

 Future<void> _saveProperty() async {
  setState(() => _loading = true);

  final property = Property(
    id: "",
    baslik: _baslikCtrl.text,
    fiyat: double.parse(_fiyatCtrl.text),
    m2: double.parse(_m2Ctrl.text),
    createdAt: Timestamp.now(),
  );

  final propertyId = await _repo.addProperty(property);

  final pos = await _locationService.getCurrentPosition();
  await _repo.updateLocation(
    propertyId,
    GeoPoint(pos.latitude, pos.longitude),
  );
  if (_image != null) {
    final imageUrl = await _storage.uploadPropertyImage(
      propertyId: propertyId,
      file: _image!,
    );
    await _repo.updateImage(propertyId, imageUrl);
  }

  setState(() => _loading = false);

  Navigator.pop(context);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mülk Ekle")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _baslikCtrl,
              decoration: const InputDecoration(labelText: "Başlık"),
            ),
            TextField(
              controller: _fiyatCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Fiyat"),
            ),
            TextField(
              controller: _m2Ctrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "m²"),
            ),
            const SizedBox(height: 16),
            if (_image != null)
              Image.file(_image!, height: 150),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text("Fotoğraf Çek"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : _saveProperty,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text("Kaydet"),
            ),
          ],
        ),
      ),
    );
  }
}
