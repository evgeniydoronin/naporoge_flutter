import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/constants/app_theme.dart';
import 'features/home/presentation/bloc/home_screen/home_screen_bloc.dart';
import 'features/diary/presentation/bloc/diary_bloc.dart';
import 'features/home/presentation/bloc/save_day_result/day_result_bloc.dart';

import 'core/routes/app_router.dart';
import 'core/services/controllers/service_locator.dart';
import 'features/planning/presentation/bloc/active_course/active_stream_bloc.dart';
import 'features/planning/presentation/bloc/choice_of_course/choice_of_course_bloc.dart';
import 'features/planning/presentation/bloc/description_count/count_description_bloc.dart';
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
        BlocProvider<ChoiceOfCourseBloc>(create: (context) => ChoiceOfCourseBloc()),
        BlocProvider<ActiveStreamBloc>(create: (context) => ActiveStreamBloc()),
        BlocProvider<CountDescriptionBloc>(create: (context) => CountDescriptionBloc()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: false,
          primarySwatch: Colors.blue,
          dialogTheme: DialogTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: AppLayout.primaryRadius),
            titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColor.blk),
          ),
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
