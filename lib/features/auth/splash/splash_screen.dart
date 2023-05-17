import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_theme.dart';
import '../../../core/routes/app_router.dart';
import '../login/presentation/screens/login_screen.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _innerRouterKey = GlobalKey<AutoRouterState>();

  startSplashScreenTimer() async {
    var _duration = const Duration(seconds: 3);
    return Timer(_duration, navigateToScreen);
  }

  void navigateToScreen() {
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => LoginScreen()),
    // );
    AutoRouter.of(context).push(const LoginEmptyRouter());
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
                child: GestureDetector(
                    onTap: () {
                      print('object');
                      // var _r = context.router.parent<StackRouter>();
                      var _r = context.router.root;
                      print(_r);
                      print(_r.stack);
                      context.router.root.push(DashboardScreenRoute());
                      // _r.push(WelcomeScreenRoute());
                    },
                    child: SvgPicture.asset('assets/icons/splash_logo.svg'))),
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
