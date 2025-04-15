import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:keepnote/config/page_transition/page_transitions.dart';
import 'package:keepnote/features/add/presentation/pages/add_page.dart';
import 'package:keepnote/features/independent_pages/page_not_found_page.dart';
import 'package:keepnote/features/view/presentation/bloc/view_bloc.dart';
import 'package:keepnote/features/view/presentation/pages/view_page.dart';

import '../../features/home/presentation/pages/home_page.dart';

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
              context.read<ViewBloc>().add(ViewFetchNoteEvent(id));
              return CustomTransitionPage(
                child: ViewPage(),
                transitionsBuilder: PageTransitions.immediateTransition,
              );
            },
          ),
          GoRoute(
            path: 'add',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                child: AddPage(task: 'add', id: 0),
                transitionsBuilder: PageTransitions.immediateTransition,
              );
            },
          ),
          GoRoute(
            path: 'update/:id',
            pageBuilder: (context, state) {
              final int id = int.parse(state.pathParameters['id'] ?? '0');
              return CustomTransitionPage(
                child: AddPage(task: 'update', id: id),
                transitionsBuilder: PageTransitions.immediateTransition,
              );
            },
          ),
        ],
      ),
    ],
    errorPageBuilder:
        (context, state) => CustomTransitionPage(
          child: PageNotFoundPage(),
          transitionsBuilder: PageTransitions.immediateTransition,
        ),
  );
}
