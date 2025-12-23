import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/location_service.dart';
import '../../repositories/property_repository.dart';

class AddLocationTestScreen extends StatelessWidget {
  AddLocationTestScreen({super.key});

  final _locationService = LocationService();
  final _repo = PropertyRepository();

  
  final String propertyId = "BURAYA_PROPERTY_ID_YAZ";

  Future<void> _addLocation(BuildContext context) async {
    final pos = await _locationService.getCurrentPosition();

    await _repo.updateLocation(
      propertyId,
      GeoPoint(pos.latitude, pos.longitude),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Konum eklendi")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Konum Ekle (Test)")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _addLocation(context),
          child: const Text("GPS ile Konum Ekle"),
        ),
      ),
    );
  }
}
