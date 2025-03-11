import 'package:dartz/dartz.dart';
import 'package:keepnote/core/error/failures/app_failure.dart';
import 'package:keepnote/data/models/note_model.dart';
import 'package:keepnote/data/source/local/sqflite/note_local_data_source.dart';
import 'package:keepnote/domain/entities/note_entity.dart';
import 'package:keepnote/domain/repositories/note_repository.dart';

class NoteRepositoryImpl extends NoteRepository {
  @override
  Future<Either<LocalDatabaseFailure, List<NoteModel>>> getAllNotes() async {
    final response = await NoteLocalDataSource.getInstance().getAllNotes();

    return response.fold(
      (failure) => Left(LocalDatabaseFailure(failure.toString())),
      (data) => Right(data),
    );
  }

  @override
  Future<bool> addNewNote(NoteEntity noteEntity) async {
    final response = await NoteLocalDataSource.getInstance().insertNote(
      noteEntity,
    );
    return response;
  }
}
