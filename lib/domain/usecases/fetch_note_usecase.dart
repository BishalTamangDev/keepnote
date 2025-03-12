import 'package:dartz/dartz.dart';
import 'package:keepnote/core/error/failures/app_failure.dart';
import 'package:keepnote/data/repositories/note_repository_impl.dart';
import 'package:keepnote/domain/entities/note_entity.dart';

class FetchNoteUseCase {
  final int id;
  final NoteRepositoryImpl noteRepository;

  const FetchNoteUseCase({required this.noteRepository, required this.id});

  Future<Either<LocalDatabaseFailure, NoteEntity>> call() async {
    final response = await noteRepository.fetchNote(id);

    return response.fold(
      (failure) => Left(failure),
      (noteEntity) => Right(noteEntity),
    );
  }
}
