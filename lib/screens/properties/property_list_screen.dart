import 'package:flutter/material.dart';
import '../../repositories/property_repository.dart';
import '../../models/property.dart';
import 'add_property_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'property_detail_screen.dart';
import '../map/property_map_screen.dart';

class PropertyListScreen extends StatelessWidget {
  PropertyListScreen({super.key});

  final _repo = PropertyRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mülkler"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddPropertyScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => PropertyMapScreen()));
            },
          ),
        ],
      ),

      body: StreamBuilder<List<Property>>(
        stream: _repo.getProperties(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Hata oluştu"));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final properties = snapshot.data!;

          if (properties.isEmpty) {
            return const Center(child: Text("Henüz mülk yok"));
          }

          return ListView.builder(
            itemCount: properties.length,
            itemBuilder: (context, index) {
              final property = properties[index];

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: property.imageUrl != null
                      ? Image.network(
                          property.imageUrl!,
                          width: 60,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.home, size: 40),
                  title: Text(property.baslik),
                  subtitle: Text(
                    "${property.fiyat.toStringAsFixed(0)} ₺ • ${property.m2} m²",
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            PropertyDetailScreen(property: property),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
