import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'add_event_screen.dart';
import 'package:geolocator/geolocator.dart';
import '../models/event.dart';
import '../services/location_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<DateTime, List<Event>> _events = {};
  DateTime _selectedDate = DateTime.now();
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  _loadEvents() async {
    setState(() {
      _events = {};
      _events[DateTime.now()] = [
        Event(title: "Exam 1", date: DateTime.now(), location: "Location 1", latitude: 37.7749, longitude: -122.4194),
      ];
    });
  }


  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  _checkLocationReminder(Event event) async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      event.latitude,
      event.longitude,
    );

    if (distance < 100) {
      print("Reminder: You're near the event location!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Exam Schedule")),
      body: Column(
        children: [
          TableCalendar(
            eventLoader: _getEventsForDay,
            focusedDay: _selectedDate,
            firstDay: DateTime(2022),
            lastDay: DateTime(2030),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDate = selectedDay;
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddEventScreen()),
              );
            },
            child: Text("Add Event"),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(37.7749, -122.4194),
                zoom: 12,
              ),
              markers: _events[DateTime.now()]?.map((event) {
                return Marker(
                  markerId: MarkerId(event.title),
                  position: LatLng(event.latitude, event.longitude),
                  infoWindow: InfoWindow(
                    title: event.title,
                    snippet: event.location,
                  ),
                );
              }).toSet() ?? {},
            ),
          ),
        ],
      ),
    );
  }
}
