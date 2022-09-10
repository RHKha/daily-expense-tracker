import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'database_constants.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database _database;

  DatabaseHelper._();

  factory DatabaseHelper() {
    return instance;
  }

  Future<Database> get db async {
    if (_database != null) {
      return _database;
    }
    _database = await init();
    return _database;
  }

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, DatabaseConstant.DATABASE_NAME);
    var database = openDatabase(
      dbPath,
      version: DatabaseConstant.DATABASE_VERSION,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

    return database;
  }

  void _onCreate(Database db, int version) {
    db.execute(DatabaseQuery.CREATE_TABLE_TRANSACTION);
    print("Database was created!");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    // Run migration according database versions
  }

  Future closeDb() async {
    var client = await db;
    client.close();
  }

  // Remove all Data
  void removeAllData() async {
    var client = await db;
    client.delete(DatabaseTable.TABLE_TRANSACTION);
  }
}
