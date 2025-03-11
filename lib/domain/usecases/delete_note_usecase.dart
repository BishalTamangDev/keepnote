import 'package:keepnote/data/repositories/note_repository_impl.dart';

class DeleteNoteUseCase {
  final int id;
  final NoteRepositoryImpl noteRepository;

  DeleteNoteUseCase({required this.id, required this.noteRepository});

  Future<bool> call() async {
    return await noteRepository.deleteNote(id);
  }
}
