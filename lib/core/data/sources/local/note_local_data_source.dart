import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:keepnote/core/data/models/note_model.dart';
import 'package:keepnote/core/domain/entities/note_entity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../constants/app_constants.dart';
import '../../../error/failures/app_failure.dart';

class LocalService {
  // private constructor
  LocalService._();

  // single instance
  static final LocalService _instance = LocalService._();

  static LocalService getInstance() => _instance;

  // database
  Database? _database;

  // database name
  static final String databaseName = "note.db";

  // table
  static final String tableName = "note_tbl";

  // create database
  static Future<Database?> initializeDatabase() async {
    try {
      final int version = 1;

      // database path
      final String path = join(await getDatabasesPath(), databaseName);

      return await openDatabase(
        path,
        version: version,
        onCreate: (db, version) async {
          await db.execute(
            "CREATE TABLE IF NOT EXISTS $tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, priority TEXT, completed INTEGER, date_time TEXT)",
          );
        },
      );
    } catch (e) {
      debugPrint("Couldn't create a database :: $e");
      return null;
    }
  }

  // get database
  Future<Database?> getDatabase() async {
    _database ??= await initializeDatabase();
    return _database;
  }

  // get all notes
  Future<Either<LocalDatabaseFailure, List<NoteModel>>> fetchAllNotes() async {
    try {
      final Database? db = await getDatabase();

      if (db == null) {
        throw Exception("Error in getting notes.");
      } else {
        final unMutableNotes = await db.query(tableName);
        final List<NoteModel> notes = unMutableNotes.map((datum) => NoteModel.fromMap(datum)).toList();
        return Right(notes.reversed.toList());
      }
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  // fetch note
  Future<Either<Failure, NoteEntity>> fetch(int id) async {
    try {
      final Database? db = await getDatabase();

      if (db == null) {
        throw Exception("Error in getting notes.");
      } else {
        try {
          final unMutableNotes = await db.query(tableName, where: "id = ?", whereArgs: [id], limit: 1);

          if (unMutableNotes.isEmpty) {
            return Left(LocalDatabaseFailure("Note not found!"));
          }

          final mutableNotes = unMutableNotes.map((datum) => {...datum}).toList();

          final noteEntity = NoteEntity(
            id: int.parse(mutableNotes[0]['id'].toString()),
            title: mutableNotes[0]['title'].toString(),
            description: mutableNotes[0]['description'].toString(),
            completed: mutableNotes[0]['completed'] == 1,
            priority: NotePriorityEnum.getOption(mutableNotes[0]['priority'].toString()),
            dateTime: DateTime.tryParse(mutableNotes[0]['date_time'].toString()) ?? DateTime.now(),
          );

          return Right(noteEntity);
        } catch (e) {
          return Left(LocalDatabaseFailure(e.toString()));
        }
      }
    } catch (e) {
      return Left(LocalDatabaseFailure("Note not found!"));
    }
  }

  // insert new note
  Future<bool> addNote(NoteEntity noteEntity) async {
    try {
      final Database? db = await getDatabase();

      if (db == null) {
        throw Exception("Error in getting notes.");
      } else {
        final NoteModel note = NoteModel.fromEntity(noteEntity);

        final Map<String, dynamic> data = {
          'title': note.title ?? "",
          'description': note.description,
          'priority': NotePriorityEnum.getTitle(noteEntity.priority),
          'completed': note.completed ? 1 : 0,
          'date_time': note.dateTime.toString(),
        };

        final int rowAffected = await db.insert(tableName, data);
        return rowAffected > 0;
      }
    } catch (e) {
      debugPrint("Error adding note :: $e");
      return false;
    }
  }

  // update note
  Future<bool> updateNote(NoteEntity noteEntity) async {
    try {
      final Database? db = await getDatabase();

      if (db == null) {
        throw Exception("Error in getting notes.");
      } else {
        try {
          final Map<String, dynamic> data = {
            'title': noteEntity.title ?? "",
            'description': noteEntity.description,
            'priority': NotePriorityEnum.getTitle(noteEntity.priority),
            'completed': noteEntity.completed ? 1 : 0,
            'date_time': noteEntity.dateTime.toString(),
          };

          final int rowsAffected = await db.update(tableName, data, where: "id = ?", whereArgs: [noteEntity.id]);
          return rowsAffected > 0;
        } catch (e) {
          rethrow;
        }
      }
    } catch (e) {
      debugPrint("Error updating note :: $e");
      return false;
    }
  }

  // delete noe
  Future<bool> deleteNote(int id) async {
    try {
      final Database? db = await getDatabase();

      if (db == null) {
        throw Exception("Error in getting notes.");
      } else {
        final int rowAffected = await db.delete(tableName, where: "id = ?", whereArgs: [id]);
        return rowAffected > 0;
      }
    } catch (e) {
      debugPrint("Error deleting note :: $e");
      return false;
    }
  }

  // mark note as completed
  Future<bool> markNoteAsCompleted(int id) async {
    try {
      final Database? db = await getDatabase();

      if (db == null) {
        throw Exception("Error in getting notes.");
      } else {
        final int rowAffected = await db.update(tableName, {'completed': 1}, where: "id = ?", whereArgs: [id]);
        return rowAffected > 0;
      }
    } catch (e) {
      return false;
    }
  }

  // mark note as pending
  Future<bool> markNoteAsPending(int id) async {
    try {
      final Database? db = await getDatabase();

      if (db == null) {
        throw Exception("Error in getting notes.");
      } else {
        final int rowAffected = await db.update(tableName, {'completed': 0}, where: "id = ?", whereArgs: [id]);
        return rowAffected > 0;
      }
    } catch (e) {
      debugPrint("Error marking note as pending :: $e");
      return false;
    }
  }
}
