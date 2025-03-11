import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:keepnote/core/error/failures/app_failure.dart';
import 'package:keepnote/data/models/note_model.dart';
import 'package:keepnote/data/repositories/note_repository_impl.dart';
import 'package:keepnote/domain/usecases/get_all_notes_usecase.dart';
import 'package:keepnote/presentation/pages/loading_page.dart';
import 'package:keepnote/presentation/widgets/note_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // variables
  late Future<Either<LocalDatabaseFailure, List<NoteModel>>> _allNotes;

  Future<Either<LocalDatabaseFailure, List<NoteModel>>> getAllNotes() async {
    final noteRepository = NoteRepositoryImpl();
    final getAllNotesUseCase = GetAllNotesUseCase(repository: noteRepository);
    final response = await getAllNotesUseCase.call();
    return response.fold(
      (failure) =>
          Left(LocalDatabaseFailure("Error occurred in fetching notes.")),
      (data) => Right(data),
    );
  }

  @override
  void initState() {
    super.initState();
    _refreshPage();
  }

  void _refreshPage() async {
    _allNotes = getAllNotes();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Notes",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        elevation: 4,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed:
                  () => context.push('/note/add').then((_) => _refreshPage()),
              icon: Icon(Icons.add),
            ),
          ),
        ],
      ),

      backgroundColor: Theme.of(context).canvasColor,

      body: FutureBuilder(
        future: _allNotes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text("Error occurred!");
            } else {
              return snapshot.data!.fold(
                (failure) {
                  return Center(child: Text(failure.message));
                },
                (data) {
                  if (data.isEmpty) {
                    return Center(child: Text("Empty!"));
                  } else {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          spacing: 16.0,
                          children: [
                            ...data.map((note) {
                              return NoteWidget(
                                note: note,
                                callback: _refreshPage,
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  }
                },
              );
            }
          } else {
            return LoadingPage();
          }
        },
      ),
    );
  }
}
