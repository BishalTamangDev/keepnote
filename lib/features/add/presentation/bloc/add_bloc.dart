import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:keepnote/core/domain/entities/note_entity.dart';
import 'package:keepnote/core/error/failures/app_failure.dart';
import 'package:keepnote/features/add/business/usecases/add_fetch_note_usecase.dart';
import 'package:keepnote/features/add/business/usecases/add_note_usecase.dart';
import 'package:keepnote/features/add/business/usecases/update_note_usecase.dart';
import 'package:keepnote/features/add/data/repositories/add_repository_impl.dart';

part 'add_event.dart';
part 'add_state.dart';

class AddBloc extends Bloc<AddEvent, AddState> {
  AddBloc() : super(AddInitial()) {
    on<AddNoteEvent>(_addNoteEvent);
    on<AddUpdateEvent>(_addUpdateEvent);
    on<AddResetEvent>(_addResetEvent);
    on<AddBackupEvent>(_addBackupEvent);
    on<AddUpdateDataEvent>(_addUpdateDataEvent);
  }

  // add note
  Future<void> _addNoteEvent(event, Emitter<AddState> emit) async {
    final AddRepositoryImpl repository = AddRepositoryImpl();
    final AddNoteUseCase usecase = AddNoteUseCase(repository);
    final bool response = await usecase.call(event.noteEntity);
    emit(
      AddResponseAction(
        response: response,
        message: response ? 'Note added successfully.' : "Couldn't add node!",
      ),
    );
  }

  // update note
  Future<void> _addUpdateEvent(
    AddUpdateEvent event,
    Emitter<AddState> emit,
  ) async {
    final AddRepositoryImpl repository = AddRepositoryImpl();
    final UpdateNoteUseCase usecase = UpdateNoteUseCase(repository);
    final bool response = await usecase.call(event.noteEntity);
    emit(
      AddUpdateResponseAction(
        response: response,
        message:
            response ? 'Note updated successfully' : "Couldn't update note.",
      ),
    );
  }

  // update data
  Future<void> _addUpdateDataEvent(
    AddUpdateDataEvent event,
    Emitter<AddState> emit,
  ) async {
    // fetch data
    final AddRepositoryImpl repository = AddRepositoryImpl();
    final AddFetchNoteUseCase useCase = AddFetchNoteUseCase(repository);
    final Either<Failure, NoteEntity> response = await useCase.call(event.id);
    response.fold(
      (failure) {
        debugPrint(failure.message);
      },
      (noteEntity) {
        emit(AddUpdateDataAction(noteEntity));
      },
    );
  }

  // reset
  Future<void> _addResetEvent(
    AddResetEvent event,
    Emitter<AddState> emit,
  ) async {
    emit(AddResetAction());
  }

  // backup
  Future<void> _addBackupEvent(
    AddBackupEvent event,
    Emitter<AddState> emit,
  ) async {
    emit(AddBackupAction());
  }
}
