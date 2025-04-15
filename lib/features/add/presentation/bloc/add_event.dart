part of 'add_bloc.dart';

@immutable
sealed class AddEvent {}

// add
final class AddNoteEvent extends AddEvent {
  final NoteEntity noteEntity;

  AddNoteEvent(this.noteEntity);
}

// update
final class AddUpdateEvent extends AddEvent {
  final NoteEntity noteEntity;

  AddUpdateEvent(this.noteEntity);
}

// update data
final class AddUpdateDataEvent extends AddEvent {
  final int id;

  AddUpdateDataEvent(this.id);
}

// reset
final class AddResetEvent extends AddEvent {}

// backup
final class AddBackupEvent extends AddEvent {}
