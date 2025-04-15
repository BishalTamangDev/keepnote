import 'package:keepnote/core/data/sources/local/note_local_data_source.dart';
import 'package:keepnote/core/domain/entities/note_entity.dart';
import 'package:keepnote/features/add/data/repositories/add_repository_impl.dart';

class UpdateNoteUseCase {
  final AddRepositoryImpl addRepository;

  UpdateNoteUseCase(this.addRepository);

  Future<bool> call(NoteEntity noteEntity) async {
    return await LocalService.getInstance().updateNote(noteEntity);
  }
}
