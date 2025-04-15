part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

// initial state
final class HomeInitial extends HomeState {}

// loading
final class HomeLoading extends HomeState {}

// loaded
final class HomeLoaded extends HomeState {
  final List<NoteEntity> notes;

  HomeLoaded(this.notes);
}

// empty
final class HomeEmpty extends HomeState {}

// error
final class HomeError extends HomeState {}

// action states
@immutable
sealed class HomeActionState extends HomeState {}

// add new note
final class HomeAddNoteAction extends HomeActionState {}

// view note
final class HomeViewNoteAction extends HomeActionState {
  final int id;

  HomeViewNoteAction(this.id);
}
