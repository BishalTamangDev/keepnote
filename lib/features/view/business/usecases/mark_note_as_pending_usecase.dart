import 'package:keepnote/features/view/data/repositories/view_repository_impl.dart';

class MarkNoteAsPendingUseCase {
  final ViewRepositoryImpl viewRepository;

  MarkNoteAsPendingUseCase(this.viewRepository);

  Future<bool> call(int id) async {
    return await viewRepository.markAsPending(id);
  }
}
