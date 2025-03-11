import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:keepnote/domain/entities/note_entity.dart';
import 'package:keepnote/presentation/pages/loading_page.dart';
import 'package:keepnote/presentation/widgets/note_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // variables
  Future<List<NoteEntity>>? _allNotes;

  // get all notes
  Future<List<NoteEntity>> getAllNotes() async {
    await Future.delayed(const Duration(seconds: 2));

    final List<NoteEntity> allNotes = [
      NoteEntity(
        id: 1,
        priority: NotePriorityEnum.low,
        title: 'Flutter',
        description: 'This is the first note description',
        dateTime: DateTime.now(),
        completed: false,
      ),
      NoteEntity(
        id: 2,
        priority: NotePriorityEnum.normal,
        title: 'PHP',
        description: 'This is the second note description',
        dateTime: DateTime.now(),
        completed: true,
      ),
      NoteEntity(
        id: 3,
        priority: NotePriorityEnum.high,
        title: 'React Js',
        description: 'This is the third note description',
        dateTime: DateTime.now(),
        completed: false,
      ),
    ];
    return allNotes;
  }

  @override
  void initState() {
    super.initState();
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
              onPressed: () => context.push('/note/add'),
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
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    spacing: 16.0,
                    children: [
                      ...snapshot.data!.map((note) {
                        return NoteWidget(note: note);
                      }),
                    ],
                  ),
                ),
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
