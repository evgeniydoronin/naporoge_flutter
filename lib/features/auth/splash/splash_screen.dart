import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isar/isar.dart';
import '../../../core/utils/create_missed_weeks.dart';
import '../../planning/domain/entities/stream_entity.dart';
import '../../../core/constants/app_theme.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/services/db_client/isar_service.dart';
import '../../planning/presentation/bloc/active_course/active_stream_bloc.dart';
import '../login/domain/user_model.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final isarService = IsarService();

  startSplashScreenTimer() async {
    var _duration = const Duration(seconds: 3);
    return Timer(_duration, navigateToScreen);
  }

  void navigateToScreen() async {
    final isar = await isarService.db;
    final user = await isar.users.where().findFirst();
    final NPStream? activeStream = await isar.nPStreams.filter().isActiveEqualTo(true).findFirst();
    final createdStreams = await isar.nPStreams.where().findAll();
    bool isCreatedStreams = createdStreams.isNotEmpty ? true : false;
    bool isActiveUser = user != null && user.isLoggedIn! ? true : false;

    DateTime now = DateTime.now();

    print('user: $user');
    // print('user ID: ${user?.id}');
    // print('isActiveUser: $isActiveUser');
    // print('activeStream: ${activeStream!.id}');

    /// пользователь зарегистрирован
    /// и не выходил из приложения
    if (isActiveUser) {
      print('SplashScreen - пользователь зарегистрирован');
      // курс не создан
      if (activeStream == null) {
        print('SplashScreen - курс не создан');

        /// если первый курс не создан
        /// перенаправляем на экран приветствия
        /// иначе на шаги создания дела
        if (isCreatedStreams) {
          if (context.mounted) {
            AutoRouter.of(context).push(const StartDateSelectionScreenRoute());
          }
        } else {
          if (context.mounted) {
            AutoRouter.of(context).push(const WelcomeScreenRoute());
          }
        }
      }
      // курс создан
      else {
        // print('SplashScreen - курс создан');
        DateTime startStream = activeStream.startAt!;
        bool streamNotStarted = startStream.isAfter(now);
        bool streamStarted = startStream.isBefore(now);

        // до старта
        if (streamNotStarted) {
          print('SplashScreen - до старта');
          // неделя создана
          if (activeStream.weekBacklink.isNotEmpty) {
            print('SplashScreen - неделя создана');
            if (context.mounted) {
              context.router.replace(const DashboardScreenRoute());
            }
          }
          // неделя не создана
          else {
            print('SplashScreen - неделя не создана');
            if (context.mounted) {
              /// активное дело
              context.read<ActiveStreamBloc>().add(ActiveStreamChanged(npStream: activeStream));
              context.router.replace(const SelectDayPeriodRoute());
            }
          }
        }
        // во время прохождения и после
        else {
          print('SplashScreen - во время прохождения');

          /// создаем пропущенные недели
          await createMissedWeeks();

          if (mounted) {
            context.router.replace(const DashboardScreenRoute());
          }
        }
      }
    }
    // нет пользователя
    else {
      print('SplashScreen - нет пользователя');
      if (context.mounted) {
        AutoRouter.of(context).navigate(const LoginEmptyRouter());
      }
    }
  }

  @override
  void initState() {
    super.initState();

    startSplashScreenTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.5,
            image: AssetImage('assets/images/waves.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(flex: 3, fit: FlexFit.tight, child: SvgPicture.asset('assets/icons/splash_logo.svg')),
            const Flexible(
                fit: FlexFit.loose,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Объединение молодежного саморазвития',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
