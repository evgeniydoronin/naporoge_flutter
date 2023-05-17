// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    EmptyRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const EmptyRouterPage(),
      );
    },
    StatisticsScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const StatisticsScreen(),
      );
    },
    ResultsStreamScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ResultsStreamScreen(),
      );
    },
    DayResultsSaveScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DayResultsSaveScreen(),
      );
    },
    HomesEmptyRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: HomesEmptyRouterPage(),
      );
    },
    HomeScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
    SplashScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashScreen(),
      );
    },
    ActivateAccountScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ActivateAccountScreen(),
      );
    },
    LoginPhoneConfirmScreenRoute.name: (routeData) {
      final args = routeData.argsAs<LoginPhoneConfirmScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LoginPhoneConfirmScreen(
          key: args.key,
          phone: args.phone,
        ),
      );
    },
    LoginEmptyRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LoginEmptyRouterPage(),
      );
    },
    LoginScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginScreen(),
      );
    },
    PlanningScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PlanningScreen(),
      );
    },
    WelcomeDescriptionScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const WelcomeDescriptionScreen(),
      );
    },
    WelcomeScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const WelcomeScreen(),
      );
    },
    MoreScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MoreScreen(),
      );
    },
    TodoEmptyRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TodoEmptyRouterPage(),
      );
    },
    TodoScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TodoScreen(),
      );
    },
    TodoItemScreenRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<TodoItemScreenRouteArgs>(
          orElse: () => TodoItemScreenRouteArgs(todo: pathParams.get('todo')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TodoItemScreen(
          key: args.key,
          todo: args.todo,
        ),
      );
    },
    PrivacyPolicyScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PrivacyPolicyScreen(),
      );
    },
    RuleOfAppScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RuleOfAppScreen(),
      );
    },
    PersonalDataScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PersonalDataScreen(),
      );
    },
    DiaryEmptyRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DiaryEmptyRouterPage(),
      );
    },
    DiaryScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DiaryScreen(),
      );
    },
    DiaryItemsScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DiaryItemsScreen(),
      );
    },
    DashboardScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DashboardScreen(),
      );
    },
    TestEmptyRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TestEmptyRouterScreen(),
      );
    },
    TestScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TestScreen(),
      );
    },
    StartDateSelectionScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const StartDateSelectionScreen(),
      );
    },
    ChoiceOfCaseScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ChoiceOfCaseScreen(),
      );
    },
    SelectDayPeriodRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SelectDayPeriod(),
      );
    },
  };
}

/// generated route for
/// [EmptyRouterPage]
class EmptyRouter extends PageRouteInfo<void> {
  const EmptyRouter({List<PageRouteInfo>? children})
      : super(
          EmptyRouter.name,
          initialChildren: children,
        );

  static const String name = 'EmptyRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [StatisticsScreen]
class StatisticsScreenRoute extends PageRouteInfo<void> {
  const StatisticsScreenRoute({List<PageRouteInfo>? children})
      : super(
          StatisticsScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'StatisticsScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ResultsStreamScreen]
class ResultsStreamScreenRoute extends PageRouteInfo<void> {
  const ResultsStreamScreenRoute({List<PageRouteInfo>? children})
      : super(
          ResultsStreamScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'ResultsStreamScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DayResultsSaveScreen]
class DayResultsSaveScreenRoute extends PageRouteInfo<void> {
  const DayResultsSaveScreenRoute({List<PageRouteInfo>? children})
      : super(
          DayResultsSaveScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'DayResultsSaveScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomesEmptyRouterPage]
class HomesEmptyRouter extends PageRouteInfo<void> {
  const HomesEmptyRouter({List<PageRouteInfo>? children})
      : super(
          HomesEmptyRouter.name,
          initialChildren: children,
        );

  static const String name = 'HomesEmptyRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomeScreen]
class HomeScreenRoute extends PageRouteInfo<void> {
  const HomeScreenRoute({List<PageRouteInfo>? children})
      : super(
          HomeScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SplashScreen]
class SplashScreenRoute extends PageRouteInfo<void> {
  const SplashScreenRoute({List<PageRouteInfo>? children})
      : super(
          SplashScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ActivateAccountScreen]
class ActivateAccountScreenRoute extends PageRouteInfo<void> {
  const ActivateAccountScreenRoute({List<PageRouteInfo>? children})
      : super(
          ActivateAccountScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'ActivateAccountScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginPhoneConfirmScreen]
class LoginPhoneConfirmScreenRoute
    extends PageRouteInfo<LoginPhoneConfirmScreenRouteArgs> {
  LoginPhoneConfirmScreenRoute({
    Key? key,
    required String phone,
    List<PageRouteInfo>? children,
  }) : super(
          LoginPhoneConfirmScreenRoute.name,
          args: LoginPhoneConfirmScreenRouteArgs(
            key: key,
            phone: phone,
          ),
          initialChildren: children,
        );

  static const String name = 'LoginPhoneConfirmScreenRoute';

  static const PageInfo<LoginPhoneConfirmScreenRouteArgs> page =
      PageInfo<LoginPhoneConfirmScreenRouteArgs>(name);
}

class LoginPhoneConfirmScreenRouteArgs {
  const LoginPhoneConfirmScreenRouteArgs({
    this.key,
    required this.phone,
  });

  final Key? key;

  final String phone;

  @override
  String toString() {
    return 'LoginPhoneConfirmScreenRouteArgs{key: $key, phone: $phone}';
  }
}

/// generated route for
/// [LoginEmptyRouterPage]
class LoginEmptyRouter extends PageRouteInfo<void> {
  const LoginEmptyRouter({List<PageRouteInfo>? children})
      : super(
          LoginEmptyRouter.name,
          initialChildren: children,
        );

  static const String name = 'LoginEmptyRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginScreen]
class LoginScreenRoute extends PageRouteInfo<void> {
  const LoginScreenRoute({List<PageRouteInfo>? children})
      : super(
          LoginScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PlanningScreen]
class PlanningScreenRoute extends PageRouteInfo<void> {
  const PlanningScreenRoute({List<PageRouteInfo>? children})
      : super(
          PlanningScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'PlanningScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [WelcomeDescriptionScreen]
class WelcomeDescriptionScreenRoute extends PageRouteInfo<void> {
  const WelcomeDescriptionScreenRoute({List<PageRouteInfo>? children})
      : super(
          WelcomeDescriptionScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'WelcomeDescriptionScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [WelcomeScreen]
class WelcomeScreenRoute extends PageRouteInfo<void> {
  const WelcomeScreenRoute({List<PageRouteInfo>? children})
      : super(
          WelcomeScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'WelcomeScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MoreScreen]
class MoreScreenRoute extends PageRouteInfo<void> {
  const MoreScreenRoute({List<PageRouteInfo>? children})
      : super(
          MoreScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'MoreScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TodoEmptyRouterPage]
class TodoEmptyRouter extends PageRouteInfo<void> {
  const TodoEmptyRouter({List<PageRouteInfo>? children})
      : super(
          TodoEmptyRouter.name,
          initialChildren: children,
        );

  static const String name = 'TodoEmptyRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TodoScreen]
class TodoScreenRoute extends PageRouteInfo<void> {
  const TodoScreenRoute({List<PageRouteInfo>? children})
      : super(
          TodoScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'TodoScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TodoItemScreen]
class TodoItemScreenRoute extends PageRouteInfo<TodoItemScreenRouteArgs> {
  TodoItemScreenRoute({
    Key? key,
    required dynamic todo,
    List<PageRouteInfo>? children,
  }) : super(
          TodoItemScreenRoute.name,
          args: TodoItemScreenRouteArgs(
            key: key,
            todo: todo,
          ),
          rawPathParams: {'todo': todo},
          initialChildren: children,
        );

  static const String name = 'TodoItemScreenRoute';

  static const PageInfo<TodoItemScreenRouteArgs> page =
      PageInfo<TodoItemScreenRouteArgs>(name);
}

class TodoItemScreenRouteArgs {
  const TodoItemScreenRouteArgs({
    this.key,
    required this.todo,
  });

  final Key? key;

  final dynamic todo;

  @override
  String toString() {
    return 'TodoItemScreenRouteArgs{key: $key, todo: $todo}';
  }
}

/// generated route for
/// [PrivacyPolicyScreen]
class PrivacyPolicyScreenRoute extends PageRouteInfo<void> {
  const PrivacyPolicyScreenRoute({List<PageRouteInfo>? children})
      : super(
          PrivacyPolicyScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'PrivacyPolicyScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RuleOfAppScreen]
class RuleOfAppScreenRoute extends PageRouteInfo<void> {
  const RuleOfAppScreenRoute({List<PageRouteInfo>? children})
      : super(
          RuleOfAppScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'RuleOfAppScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PersonalDataScreen]
class PersonalDataScreenRoute extends PageRouteInfo<void> {
  const PersonalDataScreenRoute({List<PageRouteInfo>? children})
      : super(
          PersonalDataScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'PersonalDataScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DiaryEmptyRouterPage]
class DiaryEmptyRouter extends PageRouteInfo<void> {
  const DiaryEmptyRouter({List<PageRouteInfo>? children})
      : super(
          DiaryEmptyRouter.name,
          initialChildren: children,
        );

  static const String name = 'DiaryEmptyRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DiaryScreen]
class DiaryScreenRoute extends PageRouteInfo<void> {
  const DiaryScreenRoute({List<PageRouteInfo>? children})
      : super(
          DiaryScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'DiaryScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DiaryItemsScreen]
class DiaryItemsScreenRoute extends PageRouteInfo<void> {
  const DiaryItemsScreenRoute({List<PageRouteInfo>? children})
      : super(
          DiaryItemsScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'DiaryItemsScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [DashboardScreen]
class DashboardScreenRoute extends PageRouteInfo<void> {
  const DashboardScreenRoute({List<PageRouteInfo>? children})
      : super(
          DashboardScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'DashboardScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TestEmptyRouterScreen]
class TestEmptyRouter extends PageRouteInfo<void> {
  const TestEmptyRouter({List<PageRouteInfo>? children})
      : super(
          TestEmptyRouter.name,
          initialChildren: children,
        );

  static const String name = 'TestEmptyRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TestScreen]
class TestScreenRoute extends PageRouteInfo<void> {
  const TestScreenRoute({List<PageRouteInfo>? children})
      : super(
          TestScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'TestScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [StartDateSelectionScreen]
class StartDateSelectionScreenRoute extends PageRouteInfo<void> {
  const StartDateSelectionScreenRoute({List<PageRouteInfo>? children})
      : super(
          StartDateSelectionScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'StartDateSelectionScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ChoiceOfCaseScreen]
class ChoiceOfCaseScreenRoute extends PageRouteInfo<void> {
  const ChoiceOfCaseScreenRoute({List<PageRouteInfo>? children})
      : super(
          ChoiceOfCaseScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChoiceOfCaseScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SelectDayPeriod]
class SelectDayPeriodRoute extends PageRouteInfo<void> {
  const SelectDayPeriodRoute({List<PageRouteInfo>? children})
      : super(
          SelectDayPeriodRoute.name,
          initialChildren: children,
        );

  static const String name = 'SelectDayPeriodRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
