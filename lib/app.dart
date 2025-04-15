import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keepnote/config/routes/app_routes.dart';
import 'package:keepnote/config/theme/app_theme.dart';
import 'package:keepnote/features/add/presentation/bloc/add_bloc.dart';
import 'package:keepnote/features/home/presentation/bloc/home_bloc.dart';
import 'package:keepnote/features/view/presentation/bloc/view_bloc.dart';

class KeepNote extends StatelessWidget {
  const KeepNote({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeBloc()..add(HomeFetchEvent())),
        BlocProvider(create: (context) => ViewBloc()),
        BlocProvider(create: (context) => AddBloc()),
      ],
      child: MaterialApp.router(
        title: 'Keep Note',
        routerConfig: AppRouter.appRouter,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
