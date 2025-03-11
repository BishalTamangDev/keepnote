import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:keepnote/core/error/failures/app_failure.dart';
import 'package:keepnote/data/models/note_model.dart';
import 'package:keepnote/domain/entities/note_entity.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class NoteLocalDataSource {
  // private constructor
  NoteLocalDataSource._();

  // single instance
  static final NoteLocalDataSource _instance = NoteLocalDataSource._();

  static NoteLocalDataSource getInstance() => _instance;

  // database
  Database? _database;

  // database name
  final String dbName = "note.db";

  // table
  final String tblName = "note_tbl";

  // create database
  Future<Either<AppFailure, Database>> openDb() async {
    try {
      if (_database != null) return Right(_database!);

      int version = 1;

      // add data path
      Directory appDocumentDirectory = await getApplicationCacheDirectory();

      // database path
      String dbPath = join(appDocumentDirectory.path, dbName);

      final db = await openDatabase(
        dbPath,
        version: version,
        onCreate: (db, version) async {
          await db.execute(
            "CREATE TABLE $tblName (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, priority TEXT, completed INTEGER, date_time TEXT)",
          );
        },
      );
      print("Database created successfully!");
      _database = db;
      return Right(db);
    } catch (e) {
      return Left(LocalDatabaseFailure("Couldn't create a database"));
    }
  }

  // get database
  Future<Either<AppFailure, Database>> getDb() async {
    try {
      final result = await openDb();

      return result.fold(
        (failure) => Left(LocalDatabaseFailure("Couldn't create a database.")),
        (db) => Right(db),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  // get all notes
  Future<Either<LocalDatabaseFailure, List<NoteModel>>> getAllNotes() async {
    try {
      final response = await getDb();

      return await response.fold(
        (failure) async => Left(LocalDatabaseFailure(failure.toString())),
        (db) async {
          final unMutableNotes = await db.query(tblName);

          print("Data :: $unMutableNotes");

          final List<NoteModel> notes =
              unMutableNotes.map((datum) => NoteModel.fromJson(datum)).toList();

          return Right(notes);
        },
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  // insert new note
  Future<bool> insertNote(NoteEntity noteEntity) async {
    try {
      final response = await getDb();

      NoteModel note = NoteModel.fromEntity(noteEntity);

      String priorityString = "";

      switch (note.priority) {
        case NotePriorityEnum.low:
          priorityString = "low";
          break;
        case NotePriorityEnum.high:
          priorityString = "high";
          break;
        case NotePriorityEnum.normal:
          priorityString = "normal";
      }

      return await response.fold((failure) => false, (db) async {
        Map<String, dynamic> data = {
          'title': note.title ?? "",
          'description': note.description,
          'priority': priorityString,
          'completed': note.completed ? 1 : 0,
          'date_time': note.dateTime.toString(),
        };

        print(data);

        int rowAffected = await db.insert(tblName, data);
        return rowAffected > 0;
      });
    } catch (e) {
      return false;
    }
  }

  // delete noe
  Future<bool> deleteNote(int id) async {
    try {
      final response = await getDb();

      return await response.fold((failure) => false, (db) async {
        int rowAffected = await db.delete(
          tblName,
          where: "id = ?",
          whereArgs: [id],
        );
        return rowAffected > 0;
      });
    } catch (e) {
      return false;
    }
  }

  // mark note as completed
  Future<bool> markNoteAsCompleted(int id) async {
    try {
      final response = await getDb();

      return await response.fold((failure) => false, (db) async {
        int rowAffected = await db.update(
          tblName,
          {'completed': 1},
          where: "id = ?",
          whereArgs: [id],
        );
        return rowAffected > 0;
      });
    } catch (e) {
      return false;
    }
  }

  // mark note as pending
  Future<bool> markNoteAsPending(int id) async {
    try {
      final response = await getDb();

      return await response.fold((failure) => false, (db) async {
        int rowAffected = await db.update(
          tblName,
          {'completed': 0},
          where: "id = ?",
          whereArgs: [id],
        );
        return rowAffected > 0;
      });
    } catch (e) {
      return false;
    }
  }
}
