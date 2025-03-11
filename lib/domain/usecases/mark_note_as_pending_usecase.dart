import 'package:keepnote/data/repositories/note_repository_impl.dart';

class MarkNoteAsPendingUseCase {
  final int id;
  final NoteRepositoryImpl noteRepository;

  MarkNoteAsPendingUseCase({required this.id, required this.noteRepository});

  Future<bool> call() async {
    return await noteRepository.markNoteAsPending(id);
  }
}
