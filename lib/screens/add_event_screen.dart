import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/location_service.dart';

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _saveEvent() {
    String title = _titleController.text;
    String location = _locationController.text;
    double latitude = 37.7749;
    double longitude = -122.4194;

    Event event = Event(
      title: title,
      date: _selectedDate,
      location: location,
      latitude: latitude,
      longitude: longitude,
    );

    print('Event saved: ${event.toMap()}');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Event")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Event Title"),
            ),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: "Event Location"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _selectDate(context);
              },
              child: Text('Select Date'),
            ),
            ElevatedButton(
              onPressed: _saveEvent,
              child: Text("Save Event"),
            ),
          ],
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }
}
