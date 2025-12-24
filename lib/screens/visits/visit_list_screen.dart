import 'package:flutter/material.dart';
import '../../repositories/visit_repository.dart';
import '../../models/visit.dart';
import 'package:intl/intl.dart';

class VisitListScreen extends StatelessWidget {
  final String propertyId;

  VisitListScreen({super.key, required this.propertyId});

  final _repo = VisitRepository();
  final _dateFormat = DateFormat("dd.MM.yyyy HH:mm");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ziyaretler")),
      body: StreamBuilder<List<Visit>>(
        stream: _repo.getVisitsForProperty(propertyId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Hata oluştu"));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final visits = snapshot.data!;

          if (visits.isEmpty) {
            return const Center(child: Text("Henüz ziyaret yok"));
          }

          return ListView.builder(
            itemCount: visits.length,
            itemBuilder: (context, index) {
              final visit = visits[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(visit.clientName),
                  subtitle: Text(
                    _dateFormat.format(visit.visitDate),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
