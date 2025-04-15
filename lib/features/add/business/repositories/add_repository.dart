import 'package:dartz/dartz.dart';
import 'package:keepnote/core/domain/entities/note_entity.dart';
import 'package:keepnote/core/error/failures/app_failure.dart';

abstract class AddRepository {
  // fetch note
  Future<Either<Failure, NoteEntity>> fetch(int id);

  // add note
  Future<bool> add(NoteEntity noteEntity);

  // update note
  Future<bool> update(NoteEntity noteEntity);
}
