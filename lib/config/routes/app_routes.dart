import 'package:go_router/go_router.dart';
import 'package:keepnote/domain/entities/note_entity.dart';
import 'package:keepnote/presentation/pages/add_page.dart';
import 'package:keepnote/presentation/pages/error_page.dart';
import 'package:keepnote/presentation/pages/home_page.dart';
import 'package:keepnote/presentation/pages/view_page.dart';

class AppRouter {
  static final GoRouter appRouter = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(path: '/home', builder: (context, state) => HomePage()),
      GoRoute(
        path: '/note',
        builder: (context, state) => ErrorPage(),
        routes: [
          GoRoute(
            path: '/view',
            builder: (context, state) {
              final note = state.extra as NoteEntity;
              return ViewPage(note: note);
            },
          ),
          GoRoute(
            path: '/add',
            builder: (context, state) => AddPage(task: 'add'),
          ),
          GoRoute(
            path: '/update',
            builder: (context, state) {
              final note = state.extra as NoteEntity;
              return AddPage(task: 'update', note: note);
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => ErrorPage(),
  );
}
