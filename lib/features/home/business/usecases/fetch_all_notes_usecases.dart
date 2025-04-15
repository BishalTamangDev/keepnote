import 'package:dartz/dartz.dart';
import 'package:keepnote/core/domain/entities/note_entity.dart';
import 'package:keepnote/core/error/failures/app_failure.dart';
import 'package:keepnote/features/home/data/repositories/home_repository_impl.dart';

class FetchAllNotesUseCase {
  final HomeRepositoryImpl repository;

  FetchAllNotesUseCase(this.repository);

  Future<Either<Failure, List<NoteEntity>>> call() async {
    return await repository.fetchAllNotes();
  }
}
