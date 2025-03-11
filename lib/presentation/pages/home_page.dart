import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:keepnote/data/models/note_model.dart';
import 'package:keepnote/presentation/pages/loading_page.dart';
import 'package:keepnote/presentation/widgets/note_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // variables
  late List<NoteModel> allNotes;

  @override
  void initState() {
    allNotes = [
      NoteModel(
        description: 'This is the first note description',
        title: 'First Note',
        priority: 'low',
      ),
      NoteModel(
        description: 'This is the second note description',
        priority: 'high',
      ),
      NoteModel(
        description: 'This is the third note description',
        title: 'Third Note',
        completed: true,
      ),
      NoteModel(
        description: 'This is the fourth note description',
        priority: 'high',
      ),
      NoteModel(description: 'This is the fifth note description'),
      NoteModel(
        description: 'This is the sixth note description',
        priority: 'low',
        completed: true,
      ),
      NoteModel(
        description: 'This is the seventh note description',
        priority: 'high',
      ),
      NoteModel(description: 'This is the eighth note description'),
      NoteModel(description: 'This is the ninth note description'),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 16.0,
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                child: LoadingPage(),
              ),

              ...allNotes.map((note) {
                return NoteWidget(note: note);
              }),
              // NoteWidget(note: note),
            ],
          ),
        ),
      ),
    );
  }
}
