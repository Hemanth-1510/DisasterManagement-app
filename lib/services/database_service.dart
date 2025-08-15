import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite_common/sqlite_api.dart' as sqlite_common;
import '../alert.dart';
import '../models/incident_report.dart';
import '../models/shelter.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      final factory = databaseFactoryFfiWeb;
      return await factory.openDatabase(
        'disaster_app.db',
        options: sqlite_common.OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            await _onCreateCommon(db, version);
          },
        ),
      );
    } else {
      final String path = join(await getDatabasesPath(), 'disaster_app.db');
      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) => _onCreateCommon(db, version),
      );
    }
  }

  Future<void> _onCreateCommon(dynamic db, int version) async {
    // Alerts table
    await db.execute('''
      CREATE TABLE alerts(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        issuedAt TEXT NOT NULL,
        severity TEXT NOT NULL,
        type TEXT NOT NULL,
        lat REAL NOT NULL,
        lng REAL NOT NULL
      )
    ''');

    // Incident reports table
    await db.execute('''
      CREATE TABLE incident_reports(
        id TEXT PRIMARY KEY,
        reporterId TEXT NOT NULL,
        reporterName TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        type TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        address TEXT NOT NULL,
        reportedAt TEXT NOT NULL,
        status TEXT NOT NULL,
        imageUrls TEXT,
        videoUrls TEXT,
        audioUrl TEXT,
        severity INTEGER,
        assignedVolunteerId TEXT,
        authorityNotes TEXT,
        resolvedAt TEXT,
        metadata TEXT
      )
    ''');

    // Shelters table
    await db.execute('''
      CREATE TABLE shelters(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        type TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        address TEXT NOT NULL,
        status TEXT NOT NULL,
        capacity INTEGER NOT NULL,
        currentOccupancy INTEGER NOT NULL,
        contactNumber TEXT,
        contactPerson TEXT,
        amenities TEXT,
        imageUrl TEXT,
        lastUpdated TEXT,
        additionalInfo TEXT
      )
    ''');

    // Offline sync queue
    await db.execute('''
      CREATE TABLE sync_queue(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tableName TEXT NOT NULL,
        operation TEXT NOT NULL,
        data TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  // Alert operations
  Future<void> insertAlert(Alert alert) async {
    final db = await database;
    await db.insert(
      'alerts',
      {
        'id': alert.id,
        'title': alert.title,
        'description': alert.description,
        'issuedAt': alert.issuedAt.toIso8601String(),
        'severity': alert.severity,
        'type': alert.type,
        'lat': alert.lat,
        'lng': alert.lng,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Alert>> getAlerts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('alerts');
    return List.generate(maps.length, (i) {
      return Alert(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        issuedAt: DateTime.parse(maps[i]['issuedAt']),
        severity: maps[i]['severity'],
        type: maps[i]['type'],
        lat: maps[i]['lat'],
        lng: maps[i]['lng'],
      );
    });
  }

  Future<void> clearAlerts() async {
    final db = await database;
    await db.delete('alerts');
  }

  // Incident report operations
  Future<void> insertIncidentReport(IncidentReport report) async {
    final db = await database;
    await db.insert(
      'incident_reports',
      {
        'id': report.id,
        'reporterId': report.reporterId,
        'reporterName': report.reporterName,
        'title': report.title,
        'description': report.description,
        'type': report.type.name,
        'latitude': report.latitude,
        'longitude': report.longitude,
        'address': report.address,
        'reportedAt': report.reportedAt.toIso8601String(),
        'status': report.status.name,
        'imageUrls': report.imageUrls?.join(','),
        'videoUrls': report.videoUrls?.join(','),
        'audioUrl': report.audioUrl,
        'severity': report.severity,
        'assignedVolunteerId': report.assignedVolunteerId,
        'authorityNotes': report.authorityNotes,
        'resolvedAt': report.resolvedAt?.toIso8601String(),
        'metadata': report.metadata != null ? report.metadata.toString() : null,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<IncidentReport>> getIncidentReports() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('incident_reports');
    return List.generate(maps.length, (i) {
      return IncidentReport(
        id: maps[i]['id'],
        reporterId: maps[i]['reporterId'],
        reporterName: maps[i]['reporterName'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        type: IncidentType.values.firstWhere(
          (e) => e.name == maps[i]['type'],
        ),
        latitude: maps[i]['latitude'],
        longitude: maps[i]['longitude'],
        address: maps[i]['address'],
        reportedAt: DateTime.parse(maps[i]['reportedAt']),
        status: ReportStatus.values.firstWhere(
          (e) => e.name == maps[i]['status'],
        ),
        imageUrls: maps[i]['imageUrls']?.split(','),
        videoUrls: maps[i]['videoUrls']?.split(','),
        audioUrl: maps[i]['audioUrl'],
        severity: maps[i]['severity'],
        assignedVolunteerId: maps[i]['assignedVolunteerId'],
        authorityNotes: maps[i]['authorityNotes'],
        resolvedAt: maps[i]['resolvedAt'] != null
            ? DateTime.parse(maps[i]['resolvedAt'])
            : null,
        metadata: maps[i]['metadata'] != null
            ? Map<String, dynamic>.from(
                Map.fromIterable(
                  maps[i]['metadata']!.substring(1, maps[i]['metadata']!.length - 1)
                      .split(', '),
                  key: (item) => item.split(':')[0].trim(),
                  value: (item) => item.split(':')[1].trim(),
                ),
              )
            : null,
      );
    });
  }

  // Shelter operations
  Future<void> insertShelter(Shelter shelter) async {
    final db = await database;
    await db.insert(
      'shelters',
      {
        'id': shelter.id,
        'name': shelter.name,
        'description': shelter.description,
        'type': shelter.type.name,
        'latitude': shelter.latitude,
        'longitude': shelter.longitude,
        'address': shelter.address,
        'status': shelter.status.name,
        'capacity': shelter.capacity,
        'currentOccupancy': shelter.currentOccupancy,
        'contactNumber': shelter.contactNumber,
        'contactPerson': shelter.contactPerson,
        'amenities': shelter.amenities?.join(','),
        'imageUrl': shelter.imageUrl,
        'lastUpdated': shelter.lastUpdated?.toIso8601String(),
        'additionalInfo': shelter.additionalInfo != null
            ? shelter.additionalInfo.toString()
            : null,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Shelter>> getShelters() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('shelters');
    return List.generate(maps.length, (i) {
      return Shelter(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
        type: ShelterType.values.firstWhere(
          (e) => e.name == maps[i]['type'],
        ),
        latitude: maps[i]['latitude'],
        longitude: maps[i]['longitude'],
        address: maps[i]['address'],
        status: ShelterStatus.values.firstWhere(
          (e) => e.name == maps[i]['status'],
        ),
        capacity: maps[i]['capacity'],
        currentOccupancy: maps[i]['currentOccupancy'],
        contactNumber: maps[i]['contactNumber'],
        contactPerson: maps[i]['contactPerson'],
        amenities: maps[i]['amenities']?.split(','),
        imageUrl: maps[i]['imageUrl'],
        lastUpdated: maps[i]['lastUpdated'] != null
            ? DateTime.parse(maps[i]['lastUpdated'])
            : null,
        additionalInfo: maps[i]['additionalInfo'] != null
            ? Map<String, dynamic>.from(
                Map.fromIterable(
                  maps[i]['additionalInfo']!
                      .substring(1, maps[i]['additionalInfo']!.length - 1)
                      .split(', '),
                  key: (item) => item.split(':')[0].trim(),
                  value: (item) => item.split(':')[1].trim(),
                ),
              )
            : null,
      );
    });
  }

  // Sync queue operations
  Future<void> addToSyncQueue(String tableName, String operation, String data) async {
    final db = await database;
    await db.insert('sync_queue', {
      'tableName': tableName,
      'operation': operation,
      'data': data,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getSyncQueue() async {
    final db = await database;
    return await db.query('sync_queue');
  }

  Future<void> removeFromSyncQueue(int id) async {
    final db = await database;
    await db.delete('sync_queue', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
} 