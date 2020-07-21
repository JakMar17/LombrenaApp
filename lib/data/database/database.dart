import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:vreme/data/database/models/data_model.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null)
    return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE data ("
          "id TEXT PRIMARY KEY ON CONFLICT REPLACE,"
          "typeOfData TEXT,"
          "title TEXT,"
          "url TEXT,"
          "geoLat TEXT,"
          "geoLon TEXT,"
          "favorite NUMBER"
          ")");
    });
  }

  insert(DataModel data) async {
    final db = await database;
    var res = await db.insert("data", data.toMap());
    return res;
  }

  getDataById(String id) async {
    final db = await database;
    var res = await db.query("data", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? DataModel.fromMap(res.first) : Null;
  }

  getAllData() async {
    final db = await database;
    var res = await db.query("data");
    List<DataModel> list =
        res.isNotEmpty ? res.map((c) => DataModel.fromMap(c)).toList() : [];
    return list;
  }

  getAllDataOfType(String type) async {
    final db = await database;
    var res = await db.query("data", where: "typeOfData = ?", whereArgs: [type]);
    List<DataModel> list =
        res.isNotEmpty ? res.map((c) => DataModel.fromMap(c)).toList() : [];
    return list;
  }

  getFavorites() async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM data WHERE favorite=1");
    List<DataModel> list =
        res.isNotEmpty ? res.map((c) => DataModel.fromMap(c)).toList() : [];
    return list;
  }

  updateData(DataModel data) async {
    final db = await database;
    //var x = await getDataById(data.id);
    var t = data.toMap();
    var res = await db.update("data", t,
        where: "id = ?", whereArgs: [data.id]);
    return res;
  }

  deleteData(int id) async {
    final db = await database;
    db.delete("data", where: "id = ?", whereArgs: [id]);
  }
}
