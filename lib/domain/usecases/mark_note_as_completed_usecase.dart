import 'package:keepnote/data/repositories/note_repository_impl.dart';

class MarkNoteAsCompletedUseCase {
  final int id;
  final NoteRepositoryImpl noteRepository;

  MarkNoteAsCompletedUseCase({required this.id, required this.noteRepository});

  Future<bool> call() async {
    return await noteRepository.markNoteAsCompleted(id);
  }
}
