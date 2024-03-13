import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../widgets/random_message_widget.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/utils/show_closeApp_dialog.dart';
import '../widgets/header_messages.dart';
import '../widgets/total_button.dart';
import '../widgets/video_box.dart';
import '../widgets/course_progress.dart';
import '../widgets/week_status_point.dart';

@RoutePage(name: 'HomesEmptyRouter')
class HomesEmptyRouterPage extends AutoRouter {}

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final closeApp = await showCloseAppDialog(context);
        return closeApp ?? false;
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          backgroundColor: AppColor.lightBG,
          body: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppLayout.contentPadding, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(DateFormat('dd MMMM, EEEE', 'ru_RU').format(DateTime.now()))),
                    const HeaderMessageWidget(),
                  ],
                ),
              ),
              const RandomMessageWidget(),
              const SizedBox(height: 10),
              const WeekStatusPoint(),
              const SizedBox(height: 10),
              const CourseProgress(),
              const SizedBox(height: 22),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppLayout.contentPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 4,
                      fit: FlexFit.tight,
                      child: ElevatedButton(
                        onPressed: () {
                          context.router.push(const TodoEmptyRouter());
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                          backgroundColor: AppColor.primary,
                          shape: RoundedRectangleBorder(borderRadius: AppLayout.primaryRadius),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/icons/todo_home_screen.svg'),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Перечень дел',
                                style: AppFont.regularSemibold,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      flex: 3,
                      child: ElevatedButton(
                        onPressed: () {
                          // context.router.push(SplashScreenRoute());
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                          backgroundColor: AppColor.primary,
                          shape: RoundedRectangleBorder(borderRadius: AppLayout.primaryRadius),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/icons/rules_home_screen.svg'),
                            const SizedBox(width: 10),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  context.router.push(const RuleOfAppScreenRoute());
                                },
                                child: Text(
                                  'Правила',
                                  style: AppFont.regularSemibold,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const VideoBox(),
              const SizedBox(height: 25),
              const TotalButton(),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
