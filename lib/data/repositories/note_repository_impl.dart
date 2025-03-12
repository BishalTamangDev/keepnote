import 'package:dartz/dartz.dart';
import 'package:keepnote/core/error/failures/app_failure.dart';
import 'package:keepnote/data/models/note_model.dart';
import 'package:keepnote/data/source/local/sqflite/note_local_data_source.dart';
import 'package:keepnote/domain/entities/note_entity.dart';
import 'package:keepnote/domain/repositories/note_repository.dart';

class NoteRepositoryImpl extends NoteRepository {
  // fetch al notes
  @override
  Future<Either<LocalDatabaseFailure, List<NoteModel>>> getAllNotes() async {
    final response = await NoteLocalDataSource.getInstance().getAllNotes();

    return response.fold(
      (failure) => Left(LocalDatabaseFailure(failure.toString())),
      (data) => Right(data),
    );
  }

  // fetch note
  @override
  Future<Either<LocalDatabaseFailure, NoteEntity>> fetchNote(int id) async {
    final response = await NoteLocalDataSource.getInstance().fetchNote(id);

    return await response.fold(
      (failure) => left(failure),
      (noteEntity) => Right(noteEntity),
    );
  }

  // add new note
  @override
  Future<bool> addNewNote(NoteEntity noteEntity) async {
    final response = await NoteLocalDataSource.getInstance().insertNote(
      noteEntity,
    );
    return response;
  }

  // delete note
  @override
  Future<bool> deleteNote(int id) async {
    return await NoteLocalDataSource.getInstance().deleteNote(id);
  }

  // mark note as completed
  @override
  Future<bool> markNoteAsCompleted(int id) async {
    return await NoteLocalDataSource.getInstance().markNoteAsCompleted(id);
  }

  // mark note as pending
  @override
  Future<bool> markNoteAsPending(int id) async {
    return await NoteLocalDataSource.getInstance().markNoteAsPending(id);
  }

  // update note
  @override
  Future<bool> updateNote(NoteEntity noteEntity) async {
    return await NoteLocalDataSource.getInstance().updateNote(noteEntity);
  }
}
