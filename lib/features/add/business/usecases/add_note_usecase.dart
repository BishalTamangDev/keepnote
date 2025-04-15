import 'package:keepnote/core/domain/entities/note_entity.dart';
import 'package:keepnote/features/add/data/repositories/add_repository_impl.dart';

class AddNoteUseCase {
  final AddRepositoryImpl addRepository;

  AddNoteUseCase(this.addRepository);

  Future<bool> call(NoteEntity noteEntity) async {
    return await addRepository.add(noteEntity);
  }
}
