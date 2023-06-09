import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isar/isar.dart';
import 'package:naporoge/features/planning/domain/entities/stream_entity.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/constants/app_theme.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/services/db_client/isar_service.dart';
import '../../planning/data/sources/local/stream_local_storage.dart';
import '../login/domain/user_model.dart';
import '../login/presentation/screens/login_screen.dart';

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
    bool isStream = false;
    final isar = await isarService.db;
    final userExists = await isar.users.count();

    // final activeStream = await isar.streams.where().findAll();
    final activeStreamFilter =
        await isar.nPStreams.filter().isActiveEqualTo(true).findAll();

    if (activeStreamFilter.length == 1) {
      isStream = true;
    }

    // if auth code enable
    // else if created stream enable
    // else - login screen
    if (userExists != 0 && !isStream) {
      if (context.mounted) {
        AutoRouter.of(context).push(const WelcomeScreenRoute());
      }
    } else if (userExists != 0 && isStream) {
      if (context.mounted) {
        AutoRouter.of(context).push(const DashboardScreenRoute());
      }
    } else if (userExists == 0) {
      if (context.mounted) {
        AutoRouter.of(context).push(const LoginEmptyRouter());
      }
    }

    // await isar.close();
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
            Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: SvgPicture.asset('assets/icons/splash_logo.svg')),
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
