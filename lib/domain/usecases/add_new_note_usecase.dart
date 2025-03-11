import 'package:keepnote/data/repositories/note_repository_impl.dart';
import 'package:keepnote/domain/entities/note_entity.dart';

class AddNewNoteUseCase {
  final NoteEntity noteEntity;
  final NoteRepositoryImpl noteRepository;

  AddNewNoteUseCase({required this.noteRepository, required this.noteEntity});

  Future<bool> call() async {
    try {
      bool response = await noteRepository.addNewNote(noteEntity);
      return response;
    } catch (e) {
      return false;
    }
  }
}
