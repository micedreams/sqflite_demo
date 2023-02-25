import 'dart:io';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'data/person.dart';

class DBHelper {
  /// Create a Database object and instantiate it if not initialized.
  static Database? _database;
  static final DBHelper db = DBHelper._();

  DBHelper._();

  Future<Database?> get database async {
    _database ??= await initDB();

    return _database;
  }

  /// Create the database and the Contacts table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'contacts.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Contacts('
          'id INTEGER PRIMARY KEY,'
          'name TEXT,'
          'city TEXT'
          ')');
    });
  }

  /// Insert a contact to the database
  addNewContact(Person contact, {bool onRefresh = false}) async {
    final db = await database;

    await db?.insert(
      'Contacts',
      contact.toJson(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  /// Read all Contacts from the database.
  Future<List<Person>> getAllContacts() async {
    final db = await database;
    final res = await db?.rawQuery("SELECT * FROM Contacts");

    List<Person> list = null == res || res.isEmpty
        ? []
        : res.map((c) => Person.fromJson(c)).toList();

    return list;
  }

  /// Update a contact to the database
  updateContact(Person contact) async {
    final db = await database;

    await db?.update(
      "Contacts", //table name
      contact.toJson(), // updated contact
      where: "id = ?",
      whereArgs: [contact.id],
    );
  }

  /// Delete a contact from the database
  deleteContact(int id) async {
    final db = await database;

    await db?.delete(
      "Contacts",
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
