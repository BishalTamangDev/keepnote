import 'package:dartz/dartz.dart';
import 'package:keepnote/core/domain/entities/note_entity.dart';
import 'package:keepnote/core/error/failures/app_failure.dart';
import 'package:keepnote/features/add/data/repositories/add_repository_impl.dart';

class AddFetchNoteUseCase {
  final AddRepositoryImpl addRepository;

  AddFetchNoteUseCase(this.addRepository);

  Future<Either<Failure, NoteEntity>> call(int id) async {
    return addRepository.fetch(id);
  }
}
