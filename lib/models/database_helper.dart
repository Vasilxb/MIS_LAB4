import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'event.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('events.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        date TEXT,
        location TEXT,
        latitude REAL,
        longitude REAL
      )
    ''');
  }

  Future<void> insertEvent(Event event) async {
    final db = await instance.database;
    await db.insert('events', event.toMap());
  }

  Future<List<Event>> getAllEvents() async {
    final db = await instance.database;
    final maps = await db.query('events');
    return List.generate(maps.length, (i) {
      return Event.fromMap(maps[i]);
    });
  }
}
