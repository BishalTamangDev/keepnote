import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:keepnote/core/error/failures/app_failure.dart';
import 'package:keepnote/data/models/note_model.dart';
import 'package:keepnote/domain/entities/note_entity.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/constants/app_constants.dart';

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
  Future<Either<LocalDatabaseFailure, Database>> openDb() async {
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
      _database = db;
      return Right(db);
    } catch (e) {
      return Left(LocalDatabaseFailure("Couldn't create a database"));
    }
  }

  // get database
  Future<Either<LocalDatabaseFailure, Database>> getDb() async {
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

          final List<NoteModel> notes =
              unMutableNotes.map((datum) => NoteModel.fromJson(datum)).toList();

          return Right(notes);
        },
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  // fetch note
  Future<Either<LocalDatabaseFailure, NoteEntity>> fetchNote(int id) async {
    try {
      final response = await getDb();

      return await response.fold((failure) => Left(failure), (db) async {
        try {
          final unMutableNotes = await db.query(
            tblName,
            where: "id = ?",
            whereArgs: [id],
            limit: 1,
          );

          if (unMutableNotes.isEmpty) {
            return Left(LocalDatabaseFailure("Not not found!"));
          }

          final mutableNotes =
              unMutableNotes.map((datum) => {...datum}).toList();

          final noteEntity = NoteEntity(
            id: int.parse(mutableNotes[0]['id'].toString()),
            title: mutableNotes[0]['title'].toString(),
            description: mutableNotes[0]['description'].toString(),
            completed: mutableNotes[0]['completed'] == 1,
            priority: NotePriorityEnum.getOption(
              mutableNotes[0]['priority'].toString(),
            ),
            dateTime:
                DateTime.tryParse(mutableNotes[0]['date_time'].toString()) ??
                DateTime.now(),
          );

          return Right(noteEntity);
        } catch (e) {
          return Left(LocalDatabaseFailure(e.toString()));
        }
      });
    } catch (e) {
      return Left(LocalDatabaseFailure("Note not found!"));
    }
  }

  // insert new note
  Future<bool> insertNote(NoteEntity noteEntity) async {
    try {
      final response = await getDb();

      NoteModel note = NoteModel.fromEntity(noteEntity);

      return await response.fold((failure) => false, (db) async {
        Map<String, dynamic> data = {
          'title': note.title ?? "",
          'description': note.description,
          'priority': NotePriorityEnum.getTitle(noteEntity.priority),
          'completed': note.completed ? 1 : 0,
          'date_time': note.dateTime.toString(),
        };

        int rowAffected = await db.insert(tblName, data);
        return rowAffected > 0;
      });
    } catch (e) {
      return false;
    }
  }

  // update note
  Future<bool> updateNote(NoteEntity noteEntity) async {
    try {
      final response = await getDb();

      return await response.fold((failure) => false, (db) async {
        try {
          final Map<String, dynamic> data = {
            'title': noteEntity.title ?? "",
            'description': noteEntity.description ?? "",
            'priority': NotePriorityEnum.getTitle(noteEntity.priority),
            'completed': noteEntity.completed ? 1 : 0,
            'date_time': noteEntity.dateTime.toString(),
          };

          int rowsAffected = await db.update(
            tblName,
            data,
            where: "id = ?",
            whereArgs: [noteEntity.id],
          );
          return rowsAffected > 0;
        } catch (e) {
          return false;
        }
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
