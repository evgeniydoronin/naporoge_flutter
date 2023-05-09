import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../features/diary/presentation/screens/dairy_items.dart';
import '../../features/diary/presentation/screens/diary_screen.dart';
import '../../features/home/presentation/screens/day_results_save_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/results_stream_screen.dart';
import '../../features/more/presentation/screen/more_screen.dart';
import '../../features/planning/presentation/screens/planning_screen.dart';
import '../../features/statistics/presentation/screen/statistics_screen.dart';
import '../../dashboard.dart';
import '../../features/todo/presentation/screens/todo_item_screen.dart';
import '../../features/todo/presentation/screens/todo_screen.dart';
import '../../test.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Route')
class AppRouter extends _$AppRouter {
  @override
  RouteType get defaultRouteType =>
      const RouteType.adaptive(); //.cupertino, .adaptive ..etc

  // CustomRoute, AutoRoute
  @override
  List<CustomRoute> get routes => [
        CustomRoute(
          path: '/',
          page: DashboardScreenRoute.page,
          children: [
            RedirectRoute(path: '', redirectTo: 'home'),
            CustomRoute(
              page: HomesEmptyRouter.page,
              path: 'home',
              children: [
                CustomRoute(page: HomeScreenRoute.page, path: ''),
              ],
            ),
            CustomRoute(
              page: PlanningScreenRoute.page,
              path: 'planning',
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
