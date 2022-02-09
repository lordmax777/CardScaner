import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      print("DATABASE HELPER YANGIDAN ISHGA TUSHDI...");
      return DatabaseHelper._internal();
    } else {
      print("DATABASE HELPER ISHGA TUSHIB BO'LGAN...");
      return _databaseHelper!;
    }
  }

  Future<Database> _createDatabase() async {
    Directory _documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(_documentsDirectory.path, "database.db");
    print("PATH DATABASE : $path");

    Database _db = await openDatabase(path, version: 1, onCreate: _onCreate);
    print("DATABASE OCHILDI...");
    return _db;
  }

  Future<Database> _openDatabase() async {
    if (_database == null) {
      print("DATABASE KIRITILMAGAN...");
      return await _createDatabase();
    } else {
      print("DATABASE KIRITILGAN...");
      return _database!;
    }
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE IF NOT EXISTS cards (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            card TEXT NOT NULL,
            year TEXT NOT NULL
          )
          ''');
    print("MA'LUMOTLAR UCHUN JOY YARATILDI...");
  }

  Future<List<Map<String, dynamic>>> fetchCards() async {
    Database database = await _openDatabase(); 
    List<Map<String, dynamic>> maps = await database.query('cards');

    return maps;
  }

  Future<int> addCard(String card, String year) async {
    Database database = await _openDatabase(); 

    return database.insert(
      'cards',
      {
        "card": card,
        "year": year,
      },
    );
  }
}
