import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:keepnote/core/domain/entities/note_entity.dart';
import 'package:keepnote/features/home/business/usecases/fetch_all_notes_usecases.dart';
import 'package:keepnote/features/home/data/repositories/home_repository_impl.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures/app_failure.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {});
    on<HomeFetchEvent>(_homeFetchEvent);
    on<HomeAddNoteEvent>(_homeAddNoteEvent);
    on<HomeViewNoteEvent>(_homeViewNoteEvent);
  }

  // fetch notes
  Future<void> _homeFetchEvent(
    HomeFetchEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    final HomeRepositoryImpl repository = HomeRepositoryImpl();
    final FetchAllNotesUseCase useCase = FetchAllNotesUseCase(repository);
    final Either<Failure, List<NoteEntity>> response = await useCase.call();

    await Future.delayed(const Duration(milliseconds: 100));

    response.fold(
      (failure) {
        emit(HomeError());
      },
      (notes) {
        if (notes.isEmpty) {
          emit(HomeEmpty());
        } else {
          emit(HomeLoaded(notes));
        }
      },
    );
  }

  // add new note
  Future<void> _homeAddNoteEvent(
    HomeAddNoteEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeAddNoteAction());
  }

  // view note
  Future<void> _homeViewNoteEvent(
    HomeViewNoteEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeViewNoteAction(2));
  }
}
