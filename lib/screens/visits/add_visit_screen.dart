import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/visit.dart';
import '../../repositories/visit_repository.dart';

class AddVisitScreen extends StatefulWidget {
  final String propertyId;
  final String propertyTitle;

  const AddVisitScreen({
    super.key,
    required this.propertyId,
    required this.propertyTitle,
  });

  @override
  State<AddVisitScreen> createState() => _AddVisitScreenState();
}

class _AddVisitScreenState extends State<AddVisitScreen> {
  final _clientCtrl = TextEditingController();
  final _repo = VisitRepository();

  DateTime? _selectedDate;

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    setState(() {
      _selectedDate = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _save() async {
    if (_clientCtrl.text.isEmpty || _selectedDate == null) return;

    final visit = Visit(
      id: "",
      propertyId: widget.propertyId,
      propertyTitle: widget.propertyTitle,
      clientName: _clientCtrl.text,
      visitDate: _selectedDate!,
      createdAt: Timestamp.now(),
    );

    await _repo.addVisit(visit);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ziyaret Ekle")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _clientCtrl,
              decoration:
                  const InputDecoration(labelText: "Müşteri Adı"),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? "Tarih seçilmedi"
                        : _selectedDate.toString(),
                  ),
                ),
                TextButton(
                  onPressed: _pickDateTime,
                  child: const Text("Tarih Seç"),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _save,
              child: const Text("Kaydet"),
            ),
          ],
        ),
      ),
    );
  }
}
