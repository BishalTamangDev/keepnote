part of 'add_bloc.dart';

@immutable
sealed class AddState {}

// initial
final class AddInitial extends AddState {}

// loading
final class AddLoading extends AddState {}

// loaded
final class AddLoaded extends AddState {}

// action state
@immutable
sealed class AddActionState extends AddState {}

// update values
final class AddUpdateDataAction extends AddActionState {
  final NoteEntity noteEntity;

  AddUpdateDataAction(this.noteEntity);
}

// add response
final class AddResponseAction extends AddActionState {
  final bool response;
  final String message;

  AddResponseAction({required this.response, required this.message});
}

// update response
final class AddUpdateResponseAction extends AddActionState {
  final bool response;
  final String message;

  AddUpdateResponseAction({required this.response, required this.message});
}

// reset
final class AddResetAction extends AddActionState {}

// backup
final class AddBackupAction extends AddActionState {}
