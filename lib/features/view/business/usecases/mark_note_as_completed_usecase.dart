import 'package:keepnote/features/view/data/repositories/view_repository_impl.dart';

class MarkNoteAsCompletedUseCase {
  final ViewRepositoryImpl viewRepository;

  MarkNoteAsCompletedUseCase(this.viewRepository);

  Future<bool> call(int id) async {
    return await viewRepository.markAsCompleted(id);
  }
}
