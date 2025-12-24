import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/property.dart';
import '../../repositories/property_repository.dart';
import '../../services/location_service.dart';
import '../visits/add_visit_screen.dart';
import '../visits/visit_list_screen.dart';

class PropertyDetailScreen extends StatefulWidget {
  final Property property;

  const PropertyDetailScreen({super.key, required this.property});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  late Property _property;

  final _repo = PropertyRepository();
  final _locationService = LocationService();

  bool _loadingLocation = false;

  @override
  void initState() {
    super.initState();
    _property = widget.property;
  }

  Future<void> _addLocation() async {
    setState(() => _loadingLocation = true);

    try {
      final position = await _locationService.getCurrentPosition();

      final geoPoint = GeoPoint(position.latitude, position.longitude);

      await _repo.updateLocation(_property.id, geoPoint);

      setState(() {
        _property = _property.copyWith(location: geoPoint);
      });

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Konum başarıyla eklendi")));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Konum alınamadı: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _loadingLocation = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mülk Detayı")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // FOTOĞRAF
          _property.imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    _property.imageUrl!,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.home, size: 80, color: Colors.grey),
                ),

          const SizedBox(height: 20),

          // BAŞLIK
          Text(
            _property.baslik,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),

          Chip(
            label: Text(
              _property.type.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            avatar: const Icon(Icons.home, size: 18),
          ),

          const SizedBox(height: 8),

          // FİYAT
          Text(
            "${_property.fiyat.toStringAsFixed(0)} ₺",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),

          const SizedBox(height: 8),

          // M2
          Text("${_property.m2} m²", style: const TextStyle(fontSize: 16)),

          const SizedBox(height: 24),

          // BİLGİ KARTLARI
          Row(
            children: [
              _InfoCard(
                icon: Icons.square_foot,
                label: "Alan",
                value: "${_property.m2} m²",
              ),
              const SizedBox(width: 12),
              _InfoCard(
                icon: Icons.attach_money,
                label: "Fiyat",
                value: "${_property.fiyat.toStringAsFixed(0)} ₺",
              ),
            ],
          ),

          const SizedBox(height: 32),

          // KONUM DURUMU
          Row(
            children: [
              Icon(
                _property.location != null
                    ? Icons.location_on
                    : Icons.location_off,
                color: _property.location != null ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 8),
              Text(
                _property.location != null
                    ? "Konum eklenmiş"
                    : "Konum eklenmemiş",
              ),
            ],
          ),

          const SizedBox(height: 24),

          // KONUM EKLE BUTONU
          ElevatedButton.icon(
            onPressed: _loadingLocation ? null : _addLocation,
            icon: const Icon(Icons.location_on),
            label: _loadingLocation
                ? const Text("Konum alınıyor...")
                : const Text("Konum Ekle"),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddVisitScreen(
                    propertyId: _property.id,
                    propertyTitle: _property.baslik,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.calendar_today),
            label: const Text("Ziyaret Ekle"),
          ),

          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VisitListScreen(propertyId: _property.id),
                ),
              );
            },
            icon: const Icon(Icons.list),
            label: const Text("Ziyaretleri Gör"),
          ),
        ],
      ),
    );
  }
}

// INFO CARD
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 6),
            Text(label),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
