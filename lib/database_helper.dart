import 'dart:io';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBPHelper {
  static Database? _database;
  static final DBPHelper db = DBPHelper._();

  DBPHelper._();

  Future<Database?> get database async {
    _database ??= await initDB();

    return _database;
  }

  /// Create the database and the Person table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'contacts.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Person('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'name TEXT,'
          'city TEXT,'
          ')');
    });
  }
}
