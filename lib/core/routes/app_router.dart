import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../features/auth/login/presentation/screens/activate_account_screen.dart';
import '../../features/auth/login/presentation/screens/login_screen.dart';
import '../../features/auth/login/presentation/screens/phone_confirm_screen.dart';
import '../../features/auth/splash/splash_screen.dart';
import '../../features/diary/presentation/screens/dairy_items.dart';
import '../../features/diary/presentation/screens/diary_screen.dart';
import '../../features/home/presentation/screens/day_results_save_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/results_stream_screen.dart';
import '../../features/more/presentation/screen/more_screen.dart';
import '../../features/planning/domain/entities/stream_entity.dart';
import '../../features/planning/presentation/screens/choice_of_course.dart';
import '../../features/planning/presentation/screens/planning_screen.dart';
import '../../features/planning/presentation/screens/select_day_period.dart';
import '../../features/planning/presentation/screens/start_date_selection_screen.dart';
import '../../features/rules/presentation/screens/personal_data_screen.dart';
import '../../features/rules/presentation/screens/privacy_policy_screen.dart';
import '../../features/rules/presentation/screens/rules_screen.dart';
import '../../features/statistics/presentation/screen/statistics_screen.dart';
import '../../dashboard.dart';
import '../../features/todo/presentation/screens/todo_item_screen.dart';
import '../../features/todo/presentation/screens/todo_screen.dart';
import '../../features/welcome/presentation/screens/welcome_description_screen.dart';
import '../../features/welcome/presentation/screens/welcome_screen.dart';
import '../../test.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Route')
class AppRouter extends _$AppRouter {
  @override
  RouteType get defaultRouteType =>
      const RouteType.adaptive(); //.cupertino, .adaptive ..etc

  // CustomRoute, AutoRoute
  @override
  List<AutoRoute> get routes => [
        CustomRoute(
            page: SplashScreenRoute.page, path: '/splash', initial: true),
        // Authentication
        CustomRoute(
          page: LoginEmptyRouter.page,
          path: '/login',
          children: [
            // RedirectRoute(path: '', redirectTo: 'login/splash'),
            // CustomRoute(page: SplashScreenRoute.page, path: 'login/splash'),
            CustomRoute(
              page: LoginScreenRoute.page,
              path: '',
            ),
            CustomRoute(
              page: LoginPhoneConfirmScreenRoute.page,
              path: 'login/phone-confirm',
            ),
            CustomRoute(
              page: ActivateAccountScreenRoute.page,
              path: 'login/activate-account',
            ),
            CustomRoute(
                page: PrivacyPolicyScreenRoute.page,
                path: 'login/privacy-policy'),
            CustomRoute(
                page: PersonalDataScreenRoute.page,
                path: 'login/personal-data'),
          ],
        ),

        CustomRoute(page: RuleOfAppScreenRoute.page, path: '/rules'),
        CustomRoute(page: WelcomeScreenRoute.page, path: '/welcome'),
        CustomRoute(
            page: StartDateSelectionScreenRoute.page,
            path: '/planner-start-date-selection'),
        CustomRoute(
            page: ChoiceOfCaseScreenRoute.page,
            path: '/planner-choice-of-case'),
        CustomRoute(
            page: SelectDayPeriodRoute.page,
            path: '/planner-select-day-period'),
        CustomRoute(
            page: WelcomeDescriptionScreenRoute.page, path: '/welcome-desc'),

        CustomRoute(
          path: '/dashboard',
          page: DashboardScreenRoute.page,
          // guards: [AuthGuard()],
          children: [
            // RedirectRoute(path: '', redirectTo: 'planning'),
            // CustomRoute(page: SplashScreenRoute.page, path: 'splash'),
            CustomRoute(
              page: HomesEmptyRouter.page,
              path: 'home',
              children: [
                // CustomRoute(page: SplashScreenRoute.page, path: 'home/splash'),
                CustomRoute(page: HomeScreenRoute.page, path: ''),
              ],
            ),
            CustomRoute(
              page: PlanningScreenRoute.page,
              path: 'planning',
              maintainState: false,
            ),
            CustomRoute(
              page: DiaryEmptyRouter.page,
              path: 'diary',
              children: [
                CustomRoute(page: DiaryScreenRoute.page, path: ''),
                CustomRoute(
                    page: DiaryItemsScreenRoute.page, path: 'diary-items'),
              ],
            ),
            CustomRoute(
              page: StatisticsScreenRoute.page,
              path: 'statistics',
            ),
            CustomRoute(
              page: MoreScreenRoute.page,
              path: 'more',
            ),
          ],
        ),
        CustomRoute(page: DayResultsSaveScreenRoute.page, path: '/save-day'),

        CustomRoute(
            page: ResultsStreamScreenRoute.page, path: '/results-stream'),
        CustomRoute(
          path: '/todo',
          page: TodoEmptyRouter.page,
          children: [
            CustomRoute(
              page: TodoScreenRoute.page,
              path: '',
            ),
            CustomRoute(
              page: TodoItemScreenRoute.page,
              path: 'todo/:todo/details',
            ),
          ],
        ),
      ];
}

@RoutePage(name: 'EmptyRouter')
class EmptyRouterPage extends AutoRouter {
  const EmptyRouterPage({super.key});
}

class AuthGuard extends AutoRouteGuard {
  bool get authenticated => false;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // the navigation is paused until resolver.next() is called with either
    // true to resume/continue navigation or false to abort navigation
    if (authenticated) {
      // if user is authenticated we continue
      resolver.next(true);
    } else {
      // // we redirect the user to our login page
      // router.push(LoginScreenRoute(onResult: (success) {
      //   // if success == true the navigation will be resumed
      //   // else it will be aborted
      //   resolver.next(success);
      // }));

      router.push(const LoginScreenRoute());
    }
  }
}
