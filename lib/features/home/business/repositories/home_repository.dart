import 'package:dartz/dartz.dart';
import 'package:keepnote/core/domain/entities/note_entity.dart';

import '../../../../core/error/failures/app_failure.dart';

abstract class HomeRepository {
  // fetch add notes
  Future<Either<Failure, List<NoteEntity>>> fetchAllNotes();
}
