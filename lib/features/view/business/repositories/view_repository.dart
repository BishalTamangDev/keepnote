import 'package:dartz/dartz.dart';
import 'package:keepnote/core/domain/entities/note_entity.dart';
import 'package:keepnote/core/error/failures/app_failure.dart';

abstract class ViewRepository {
  // fetch note
  Future<Either<Failure, NoteEntity>> fetch(int id);

  // mark as completed
  Future<bool> markAsCompleted(int id);

  // mark as pending
  Future<bool> markAsPending(int id);

  // delete
  Future<bool> delete(int id);
}
