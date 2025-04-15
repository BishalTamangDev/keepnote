part of 'view_bloc.dart';

@immutable
sealed class ViewEvent {}

// fetch
final class ViewFetchNoteEvent extends ViewEvent {
  final int id;

  ViewFetchNoteEvent(this.id);
}

// mark as completed
final class ViewMarkAsCompletedEvent extends ViewEvent {
  final int id;

  ViewMarkAsCompletedEvent(this.id);
}

// mark as pending
final class ViewMarkAsPendingEvent extends ViewEvent {
  final int id;

  ViewMarkAsPendingEvent(this.id);
}

// delete note
final class ViewDeleteNoteEvent extends ViewEvent {
  final int id;

  ViewDeleteNoteEvent(this.id);
}
