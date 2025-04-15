import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:keepnote/core/domain/entities/note_entity.dart';
import 'package:keepnote/features/view/business/usecases/delete_note_usecase.dart';
import 'package:keepnote/features/view/business/usecases/fetch_note_usecase.dart';
import 'package:keepnote/features/view/business/usecases/mark_note_as_completed_usecase.dart';
import 'package:keepnote/features/view/data/repositories/view_repository_impl.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures/app_failure.dart';
import '../../business/usecases/mark_note_as_pending_usecase.dart';

part 'view_event.dart';
part 'view_state.dart';

class ViewBloc extends Bloc<ViewEvent, ViewState> {
  ViewBloc() : super(ViewInitial()) {
    on<ViewEvent>((event, emit) {});
    on<ViewFetchNoteEvent>(_viewFetchNoteEvent);
    on<ViewMarkAsCompletedEvent>(_viewMarkAsCompletedEvent);
    on<ViewMarkAsPendingEvent>(_viewMarkAsPendingEvent);
    on<ViewDeleteNoteEvent>(_viewDeleteNoteEvent);
  }

  // fetch note
  Future<void> _viewFetchNoteEvent(
    ViewFetchNoteEvent event,
    Emitter<ViewState> emit,
  ) async {
    final ViewRepositoryImpl repository = ViewRepositoryImpl();
    final FetchNoteUseCase usecase = FetchNoteUseCase(repository);
    final Either<Failure, NoteEntity> response = await usecase.call(event.id);

    if (response.isLeft()) {
      emit(ViewError());
    } else {
      final NoteEntity noteEntity = response.getOrElse(
        () => NoteEntity(description: '', dateTime: DateTime.now()),
      );
      emit(ViewLoaded(noteEntity));
      await Future.delayed(const Duration(milliseconds: 100));
      emit(ViewUpdateChangingDataAction(noteEntity.completed));
    }
  }

  // mark as completed
  Future<void> _viewMarkAsCompletedEvent(event, emit) async {
    final ViewRepositoryImpl repository = ViewRepositoryImpl();
    final MarkNoteAsCompletedUseCase usecase = MarkNoteAsCompletedUseCase(
      repository,
    );

    final bool response = await usecase.call(event.id);

    final message = response ? "Marked as completed." : "An error occurred!";

    emit(
      ViewMarkAsCompletedResponseAction(response: response, message: message),
    );

    await Future.delayed(const Duration(milliseconds: 100));

    emit(ViewUpdateChangingDataAction(true));
  }

  // mark as pending
  Future<void> _viewMarkAsPendingEvent(event, emit) async {
    final ViewRepositoryImpl repository = ViewRepositoryImpl();
    final MarkNoteAsPendingUseCase usecase = MarkNoteAsPendingUseCase(
      repository,
    );

    final bool response = await usecase.call(event.id);

    final message = response ? "Marked as pending." : "An error occurred!";

    emit(ViewMarkAsPendingResponseAction(response: response, message: message));

    await Future.delayed(const Duration(milliseconds: 100));

    emit(ViewUpdateChangingDataAction(false));
  }

  // delete note
  Future<void> _viewDeleteNoteEvent(event, emit) async {
    final ViewRepositoryImpl repository = ViewRepositoryImpl();
    final DeleteNoteUseCase usecase = DeleteNoteUseCase(repository);

    final bool response = await usecase.call(event.id);

    final message =
        response ? "Note deleted successfully." : "Couldn't delete note.";

    emit(ViewDeleteResponseAction(response: response, message: message));
  }
}
