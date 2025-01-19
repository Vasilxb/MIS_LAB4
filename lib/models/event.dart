class Event {
  final String title;
  final DateTime date;
  final String location;
  final double latitude;
  final double longitude;

  Event({required this.title, required this.date, required this.location, required this.latitude, required this.longitude});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date.toIso8601String(),
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  static Event fromMap(Map<String, dynamic> map) {
    return Event(
      title: map['title'],
      date: DateTime.parse(map['date']),
      location: map['location'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}
