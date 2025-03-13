import 'package:go_router/go_router.dart';
import 'package:keepnote/config/page_transition/page_transitions.dart';
import 'package:keepnote/domain/entities/note_entity.dart';
import 'package:keepnote/presentation/pages/add_page.dart';
import 'package:keepnote/presentation/pages/page_not_found_page.dart';
import 'package:keepnote/presentation/pages/home_page.dart';
import 'package:keepnote/presentation/pages/view_page.dart';

class AppRouter {
  static final GoRouter appRouter = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: HomePage(),
            transitionsBuilder: PageTransitions.immediateTransition,
          );
        },
      ),
      GoRoute(
        path: '/note',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: PageNotFoundPage(),
            transitionsBuilder: PageTransitions.immediateTransition,
          );
        },
        routes: [
          GoRoute(
            path: 'view/:id',
            pageBuilder: (context, state) {
              final int id = int.parse(state.pathParameters['id'].toString());
              return CustomTransitionPage(
                child: ViewPage(id: id),
                transitionsBuilder: PageTransitions.immediateTransition,
              );
            },
          ),
          GoRoute(
            path: 'add',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                child: AddPage(task: 'add'),
                transitionsBuilder: PageTransitions.immediateTransition,
              );
            },
          ),
          GoRoute(
            path: 'update',
            pageBuilder: (context, state) {
              final note = state.extra as NoteEntity;
              return CustomTransitionPage(
                child: AddPage(task: 'update', note: note),
                transitionsBuilder: PageTransitions.immediateTransition,
              );
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => PageNotFoundPage(),
  );
}
