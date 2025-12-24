import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../repositories/property_repository.dart';
import '../../models/property.dart';

class PropertyMapScreen extends StatelessWidget {
  PropertyMapScreen({super.key});

  final _repo = PropertyRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mülk Haritası"),
      ),
      body: StreamBuilder<List<Property>>(
        stream: _repo.getProperties(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final properties = snapshot.data!;
          final located =
              properties.where((p) => p.location != null).toList();

          if (located.isEmpty) {
            return const Center(
              child: Text("Konumu olan mülk yok"),
            );
          }

          final markers = located.map((property) {
            final lat = property.location!.latitude;
            final lng = property.location!.longitude;

            // 🔒 Extra güvenlik
            if (!lat.isFinite || !lng.isFinite) return null;

            return Marker(
              point: LatLng(lat, lng),
              width: 40,
              height: 40,
              child: const Icon(
                Icons.location_on,
                color: Colors.red,
                size: 40,
              ),
            );
          }).whereType<Marker>().toList();

          return FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(39.0, 35.0), // TÜRKİYE
              initialZoom: 6,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.emlak_saha_app',
              ),
              MarkerLayer(markers: markers),
            ],
          );
        },
      ),
    );
  }
}
