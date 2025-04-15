part of 'view_bloc.dart';

@immutable
sealed class ViewState {}

// initial
final class ViewInitial extends ViewState {}

// loading
final class ViewLoading extends ViewState {}

// loaded
final class ViewLoaded extends ViewState {
  final NoteEntity noteEntity;

  ViewLoaded(this.noteEntity);
}

// error
final class ViewError extends ViewState {}

// not found
final class ViewNoteFound extends ViewState {}

// action states
@immutable
sealed class ViewAction extends ViewState {}

// view
final class ViewUpdateChangingDataAction extends ViewAction {
  final bool completed;

  ViewUpdateChangingDataAction(this.completed);
}

// mark as completed response
final class ViewMarkAsCompletedResponseAction extends ViewAction {
  final bool response;
  final String message;

  ViewMarkAsCompletedResponseAction({
    required this.response,
    required this.message,
  });
}

// mark as pending response
final class ViewMarkAsPendingResponseAction extends ViewAction {
  final bool response;
  final String message;

  ViewMarkAsPendingResponseAction({
    required this.response,
    required this.message,
  });
}

// delete response
final class ViewDeleteResponseAction extends ViewAction {
  final bool response;
  final String message;

  ViewDeleteResponseAction({required this.response, required this.message});
}
