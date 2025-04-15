import 'package:dartz/dartz.dart';
import 'package:keepnote/core/data/sources/local/note_local_data_source.dart';
import 'package:keepnote/core/domain/entities/note_entity.dart';
import 'package:keepnote/core/error/failures/app_failure.dart';
import 'package:keepnote/features/home/business/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  @override
  Future<Either<Failure, List<NoteEntity>>> fetchAllNotes() async {
    return await LocalService.getInstance().fetchAllNotes();
  }
}
