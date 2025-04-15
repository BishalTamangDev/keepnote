import 'package:dartz/dartz.dart';
import 'package:keepnote/core/data/sources/local/note_local_data_source.dart';
import 'package:keepnote/core/domain/entities/note_entity.dart';
import 'package:keepnote/core/error/failures/app_failure.dart';
import 'package:keepnote/features/view/business/repositories/view_repository.dart';

class ViewRepositoryImpl implements ViewRepository {
  @override
  Future<Either<Failure, NoteEntity>> fetch(int id) async {
    return await LocalService.getInstance().fetch(id);
  }

  @override
  Future<bool> markAsPending(int id) async {
    return await LocalService.getInstance().markNoteAsPending(id);
  }

  @override
  Future<bool> markAsCompleted(int id) async {
    return await LocalService.getInstance().markNoteAsCompleted(id);
  }

  @override
  Future<bool> delete(int id) async {
    return await LocalService.getInstance().deleteNote(id);
  }
}
