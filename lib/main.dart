import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:naporoge/features/home/presentation/bloc/home_screen/home_screen_bloc.dart';
import 'package:naporoge/features/home/presentation/bloc/home_screen/home_screen_bloc.dart';
import 'features/diary/presentation/bloc/diary_bloc.dart';
import 'features/home/presentation/bloc/save_day_result/day_result_bloc.dart';

import 'core/routes/app_router.dart';
import 'core/services/controllers/service_locator.dart';
import 'features/planning/presentation/bloc/planner_bloc.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  await setup();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PlannerBloc>(create: (context) => PlannerBloc()),
        BlocProvider<DayResultBloc>(create: (context) => DayResultBloc()),
        BlocProvider<HomeScreenBloc>(create: (context) => HomeScreenBloc()),
        BlocProvider<DiaryBloc>(create: (context) => DiaryBloc()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ru')],
        routerConfig: _appRouter.config(),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
