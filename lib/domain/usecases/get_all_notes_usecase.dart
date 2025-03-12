import 'package:dartz/dartz.dart';
import 'package:keepnote/core/error/failures/app_failure.dart';
import 'package:keepnote/data/models/note_model.dart';
import 'package:keepnote/data/repositories/note_repository_impl.dart';

class GetAllNotesUseCase {
  final NoteRepositoryImpl repository;

  GetAllNotesUseCase({required this.repository});

  Future<Either<LocalDatabaseFailure, List<NoteModel>>> call() async {
    try {
      final result = await repository.getAllNotes();
      return result.fold(
        (failure) => Left(LocalDatabaseFailure(failure.message.toString())),
        (data) => Right(data),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }
}
