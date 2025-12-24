import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/property.dart';
import '../../repositories/property_repository.dart';
import '../../services/storage_service.dart';

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({super.key});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();

  final _baslikCtrl = TextEditingController();
  final _fiyatCtrl = TextEditingController();
  final _m2Ctrl = TextEditingController();

  final _repo = PropertyRepository();
  final _storage = StorageService();
  final _picker = ImagePicker();

  final List<String> _propertyTypes = [
    'daire',
    'villa',
    'arsa',
    'isyeri',
  ];
  String _selectedType = 'daire';

  File? _image;
  bool _loading = false;

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
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final property = Property(
        id: "",
        baslik: _baslikCtrl.text,
        fiyat: double.parse(_fiyatCtrl.text),
        m2: double.parse(_m2Ctrl.text),
        type: _selectedType,
        imageUrl: null,
        location: null,
        createdAt: Timestamp.now(),
      );

      
      final propertyId = await _repo.addProperty(property);

      if (_image != null) {
        final imageUrl = await _storage.uploadPropertyImage(
          propertyId: propertyId,
          file: _image!,
        );
        await _repo.updateImage(propertyId, imageUrl);
      }

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Hata oluştu: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text("Mülk Ekle")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                TextFormField(
                  controller: _baslikCtrl,
                  decoration: const InputDecoration(labelText: "Başlık"),
                  validator: (v) =>
                      v == null || v.isEmpty ? "Zorunlu alan" : null,
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: _fiyatCtrl,
                  decoration: const InputDecoration(labelText: "Fiyat"),
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      v == null || v.isEmpty ? "Zorunlu alan" : null,
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: _m2Ctrl,
                  decoration: const InputDecoration(labelText: "m²"),
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      v == null || v.isEmpty ? "Zorunlu alan" : null,
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: "Mülk Tipi",
                    border: OutlineInputBorder(),
                  ),
                  items: _propertyTypes
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.toUpperCase()),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                ),

                const SizedBox(height: 20),

                _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _image!,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Text("Fotoğraf seçilmedi"),

                TextButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Fotoğraf Çek"),
                ),

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _loading ? null : _saveProperty,
                  child: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child:
                              CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Kaydet"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
