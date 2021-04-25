import 'dart:io';
import 'package:knn_citra_digital/Models/training_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class TrainingDbProvider {
  Future<Database> init() async {
    Directory directory =
        await getApplicationDocumentsDirectory(); //returns a directory which stores permanent files
    final path = join(directory.path, "knn_jamur.db"); //create path to database

    return await openDatabase(
        //open the database or create a database if there isn't any
        path,
        version: 1, onCreate: (Database db, int version) async {
      // Create * database + tables for consumtion then
      await db.execute("""
          CREATE TABLE Training(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          state INTEGER,
          r INTEGER,
          g INTEGER,
          b INTEGER,
          base64 TEXT)""");
    });
  }

  Future<int> addTraining(TrainingModel data) async {
    //returns number of items inserted as an integer

    final db = await init(); //open database

    return db.insert(
      "Training", data.toMap(), //toMap() function from MemoModel
      conflictAlgorithm:
          ConflictAlgorithm.ignore, //ignores conflicts due to duplicate entries
    );
  }

  Future<List<TrainingModel>> fetchTraining() async {
    //returns the mk as a list (array)

    final db = await init();
    final maps = await db
        .query("Training"); //query all the rows in a table as an array of maps

    return List.generate(maps.length, (i) {
      //create a list of mk
      return TrainingModel(
        id: maps[i]['id'],
        state: maps[i]['state'],
        r: maps[i]['r'],
        g: maps[i]['g'],
        b: maps[i]['b'],
        base64: maps[i]['base64'],
      );
    });
  }

  Future<int> deleteTraining(int id) async {
    //returns number of items deleted
    final db = await init();

    int result = await db.delete("Training", //table name
        where: "id = ?",
        whereArgs: [id] // use whereArgs to avoid SQL injection
        );

    return result;
  }
}
