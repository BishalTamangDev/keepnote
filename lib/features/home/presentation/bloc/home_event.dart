part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

// fetch
final class HomeFetchEvent extends HomeEvent {}

// add new note
final class HomeAddNoteEvent extends HomeEvent {}

// view note
final class HomeViewNoteEvent extends HomeEvent {
  final int id;

  HomeViewNoteEvent(this.id);
}
