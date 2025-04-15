import 'package:dartz/dartz.dart';
import 'package:keepnote/core/domain/entities/note_entity.dart';
import 'package:keepnote/core/error/failures/app_failure.dart';
import 'package:keepnote/features/view/data/repositories/view_repository_impl.dart';

class FetchNoteUseCase {
  final ViewRepositoryImpl viewRepository;

  const FetchNoteUseCase(this.viewRepository);

  Future<Either<Failure, NoteEntity>> call(int id) async {
    return await viewRepository.fetch(id);
  }
}
