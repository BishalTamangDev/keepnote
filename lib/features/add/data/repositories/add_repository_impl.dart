import 'package:dartz/dartz.dart';
import 'package:keepnote/core/data/sources/local/note_local_data_source.dart';
import 'package:keepnote/core/domain/entities/note_entity.dart';
import 'package:keepnote/core/error/failures/app_failure.dart';
import 'package:keepnote/features/add/business/repositories/add_repository.dart';

class AddRepositoryImpl implements AddRepository {
  @override
  Future<Either<Failure, NoteEntity>> fetch(int id) async {
    return await LocalService.getInstance().fetch(id);
  }

  @override
  Future<bool> add(NoteEntity noteEntity) async {
    return await LocalService.getInstance().addNote(noteEntity);
  }

  @override
  Future<bool> update(NoteEntity noteEntity) async {
    return await LocalService.getInstance().updateNote(noteEntity);
  }
}
