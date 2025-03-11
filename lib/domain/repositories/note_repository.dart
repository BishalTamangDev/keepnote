import 'package:dartz/dartz.dart';
import 'package:keepnote/core/error/failures/app_failure.dart';
import 'package:keepnote/data/models/note_model.dart';

import '../entities/note_entity.dart';

abstract class NoteRepository {
  // get all notes
  Future<Either<AppFailure, List<NoteModel>>> getAllNotes();

  // add new note
  Future<bool> addNewNote(NoteEntity noteEntity);
}
