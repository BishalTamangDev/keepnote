import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:keepnote/features/home/presentation/bloc/home_bloc.dart';
import 'package:keepnote/shared/note_widget.dart';

import '../widgets/empty_page.dart';
import '../widgets/error_page.dart';
import '../widgets/loading_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
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
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: () => context.push('/note/add'),
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),

      backgroundColor: Theme.of(context).canvasColor,

      body: BlocConsumer<HomeBloc, HomeState>(
        listenWhen: (previous, current) => current is HomeActionState,
        buildWhen: (previous, current) => current is! HomeActionState,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state) {
            case HomeEmpty():
              return const EmptyPage();
            case HomeError():
              return const ErrorPage(error: 'An error occurred!');
            case HomeLoaded():
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    spacing: 16.0,
                    children: [
                      ...state.notes.map((note) => NoteWidget(note: note)),
                    ],
                  ),
                ),
              );
            default:
              return const LoadingPage();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<HomeBloc>().add(HomeFetchEvent()),
        child: const Icon(Icons.refresh_outlined),
      ),
    );
  }
}
