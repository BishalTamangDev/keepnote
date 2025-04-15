import 'package:keepnote/features/view/data/repositories/view_repository_impl.dart';

class DeleteNoteUseCase {
  final ViewRepositoryImpl viewRepository;

  DeleteNoteUseCase(this.viewRepository);

  Future<bool> call(int id) async {
    return await viewRepository.delete(id);
  }
}
