import 'package:keepnote/data/repositories/note_repository_impl.dart';
import 'package:keepnote/domain/entities/note_entity.dart';

class UpdateNoteUseCase {
  final NoteEntity noteEntity;
  final NoteRepositoryImpl noteRepository;

  UpdateNoteUseCase({required this.noteEntity, required this.noteRepository});

  Future<bool> call() async {
    return await noteRepository.updateNote(noteEntity);
  }
}
