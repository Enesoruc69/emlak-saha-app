import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  Future<void> _loadMarkers() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("properties")
        .where("location", isNull: false)
        .get();

    final List<Marker> markers = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final GeoPoint gp = data["location"];

      markers.add(
        Marker(
          width: 40,
          height: 40,
          point: LatLng(gp.latitude, gp.longitude),
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(data["baslik"] ?? "Mülk"),
                  content: Text(
                    "Fiyat: ${data["fiyat"] ?? "-"} ₺",
                  ),
                ),
              );
            },
            child: const Icon(
              Icons.location_pin,
              color: Colors.red,
              size: 40,
            ),
          ),
        ),
      );
    }

    setState(() {
      _markers = markers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mülk Haritası")),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(39.92077, 32.85411), // Türkiye ortalama
          initialZoom: 6,
        ),
        children: [
          TileLayer(
            urlTemplate:
                "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'com.example.emlak_saha_app',
          ),
          MarkerLayer(markers: _markers),
        ],
      ),
    );
  }
}
