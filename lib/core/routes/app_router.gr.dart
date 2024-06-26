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
    ActivateAccountScreenRoute.name: (routeData) {
      final args = routeData.argsAs<ActivateAccountScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ActivateAccountScreen(
          key: args.key,
          phone: args.phone,
        ),
      );
    },
    ArchiveItemScreenRoute.name: (routeData) {
      final args = routeData.argsAs<ArchiveItemScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ArchiveItemScreen(
          key: args.key,
          stream: args.stream,
        ),
      );
    },
    ArchivesScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ArchivesScreen(),
      );
    },
    ChoiceOfCaseScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ChoiceOfCaseScreen(),
      );
    },
    DashboardScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DashboardScreen(),
      );
    },
    DayResultsSaveScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DayResultsSaveScreen(),
      );
    },
    DiaryEmptyRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DiaryEmptyRouterPage(),
      );
    },
    DiaryItemsScreenRoute.name: (routeData) {
      final args = routeData.argsAs<DiaryItemsScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DiaryItemsScreen(
          key: args.key,
          dateTime: args.dateTime,
        ),
      );
    },
    DiaryRulesScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DiaryRulesScreen(),
      );
    },
    DiaryScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DiaryScreen(),
      );
    },
    EmptyRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const EmptyRouterPage(),
      );
    },
    ExperienceOfOthersScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ExperienceOfOthersScreen(),
      );
    },
    ExplanationsForThePlanningRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ExplanationsForThePlanning(),
      );
    },
    ExplanationsForTheStreamRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ExplanationsForTheStream(),
      );
    },
    HomeScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
    HomesEmptyRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: HomesEmptyRouterPage(),
      );
    },
    InstructionAppScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const InstructionAppScreen(),
      );
    },
    LoginEmptyRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LoginEmptyRouterPage(),
      );
    },
    LoginPhoneConfirmScreenRoute.name: (routeData) {
      final args = routeData.argsAs<LoginPhoneConfirmScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LoginPhoneConfirmScreen(
          key: args.key,
          phone: args.phone,
          code: args.code,
        ),
      );
    },
    LoginScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginScreen(),
      );
    },
    MoreScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MoreScreen(),
      );
    },
    OurMissionScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OurMissionScreen(),
      );
    },
    PersonalDataScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PersonalDataScreen(),
      );
    },
    PlanningScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PlanningScreen(),
      );
    },
    PrivacyPolicyScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PrivacyPolicyScreen(),
      );
    },
    ResultsStreamScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ResultsStreamScreen(),
      );
    },
    RuleOfAppScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RuleOfAppScreen(),
      );
    },
    SelectDayPeriodRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SelectDayPeriod(),
      );
    },
    SplashScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashScreen(),
      );
    },
    StartDateSelectionScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const StartDateSelectionScreen(),
      );
    },
    StatisticsScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const StatisticsScreen(),
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
    TheoriesRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TheoriesRouterScreen(),
      );
    },
    TheoriesScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TheoriesScreen(),
      );
    },
    TheoryPostScreenRoute.name: (routeData) {
      final args = routeData.argsAs<TheoryPostScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TheoryPostScreen(
          key: args.key,
          data: args.data,
          postId: args.postId,
        ),
      );
    },
    TodoEmptyRouter.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TodoEmptyRouterPage(),
      );
    },
    TodoInfoScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TodoInfoScreen(),
      );
    },
    TodoItemScreenRoute.name: (routeData) {
      final args = routeData.argsAs<TodoItemScreenRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TodoItemScreen(
          key: args.key,
          todo: args.todo,
        ),
      );
    },
    TodoScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TodoScreen(),
      );
    },
    TwoTargetScreenRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TwoTargetScreen(),
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
  };
}

/// generated route for
/// [ActivateAccountScreen]
class ActivateAccountScreenRoute
    extends PageRouteInfo<ActivateAccountScreenRouteArgs> {
  ActivateAccountScreenRoute({
    Key? key,
    required String phone,
    List<PageRouteInfo>? children,
  }) : super(
          ActivateAccountScreenRoute.name,
          args: ActivateAccountScreenRouteArgs(
            key: key,
            phone: phone,
          ),
          initialChildren: children,
        );

  static const String name = 'ActivateAccountScreenRoute';

  static const PageInfo<ActivateAccountScreenRouteArgs> page =
      PageInfo<ActivateAccountScreenRouteArgs>(name);
}

class ActivateAccountScreenRouteArgs {
  const ActivateAccountScreenRouteArgs({
    this.key,
    required this.phone,
  });

  final Key? key;

  final String phone;

  @override
  String toString() {
    return 'ActivateAccountScreenRouteArgs{key: $key, phone: $phone}';
  }
}

/// generated route for
/// [ArchiveItemScreen]
class ArchiveItemScreenRoute extends PageRouteInfo<ArchiveItemScreenRouteArgs> {
  ArchiveItemScreenRoute({
    Key? key,
    required NPStream stream,
    List<PageRouteInfo>? children,
  }) : super(
          ArchiveItemScreenRoute.name,
          args: ArchiveItemScreenRouteArgs(
            key: key,
            stream: stream,
          ),
          initialChildren: children,
        );

  static const String name = 'ArchiveItemScreenRoute';

  static const PageInfo<ArchiveItemScreenRouteArgs> page =
      PageInfo<ArchiveItemScreenRouteArgs>(name);
}

class ArchiveItemScreenRouteArgs {
  const ArchiveItemScreenRouteArgs({
    this.key,
    required this.stream,
  });

  final Key? key;

  final NPStream stream;

  @override
  String toString() {
    return 'ArchiveItemScreenRouteArgs{key: $key, stream: $stream}';
  }
}

/// generated route for
/// [ArchivesScreen]
class ArchivesScreenRoute extends PageRouteInfo<void> {
  const ArchivesScreenRoute({List<PageRouteInfo>? children})
      : super(
          ArchivesScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'ArchivesScreenRoute';

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
/// [DiaryItemsScreen]
class DiaryItemsScreenRoute extends PageRouteInfo<DiaryItemsScreenRouteArgs> {
  DiaryItemsScreenRoute({
    Key? key,
    required DateTime dateTime,
    List<PageRouteInfo>? children,
  }) : super(
          DiaryItemsScreenRoute.name,
          args: DiaryItemsScreenRouteArgs(
            key: key,
            dateTime: dateTime,
          ),
          initialChildren: children,
        );

  static const String name = 'DiaryItemsScreenRoute';

  static const PageInfo<DiaryItemsScreenRouteArgs> page =
      PageInfo<DiaryItemsScreenRouteArgs>(name);
}

class DiaryItemsScreenRouteArgs {
  const DiaryItemsScreenRouteArgs({
    this.key,
    required this.dateTime,
  });

  final Key? key;

  final DateTime dateTime;

  @override
  String toString() {
    return 'DiaryItemsScreenRouteArgs{key: $key, dateTime: $dateTime}';
  }
}

/// generated route for
/// [DiaryRulesScreen]
class DiaryRulesScreenRoute extends PageRouteInfo<void> {
  const DiaryRulesScreenRoute({List<PageRouteInfo>? children})
      : super(
          DiaryRulesScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'DiaryRulesScreenRoute';

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
/// [ExperienceOfOthersScreen]
class ExperienceOfOthersScreenRoute extends PageRouteInfo<void> {
  const ExperienceOfOthersScreenRoute({List<PageRouteInfo>? children})
      : super(
          ExperienceOfOthersScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'ExperienceOfOthersScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ExplanationsForThePlanning]
class ExplanationsForThePlanningRoute extends PageRouteInfo<void> {
  const ExplanationsForThePlanningRoute({List<PageRouteInfo>? children})
      : super(
          ExplanationsForThePlanningRoute.name,
          initialChildren: children,
        );

  static const String name = 'ExplanationsForThePlanningRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ExplanationsForTheStream]
class ExplanationsForTheStreamRoute extends PageRouteInfo<void> {
  const ExplanationsForTheStreamRoute({List<PageRouteInfo>? children})
      : super(
          ExplanationsForTheStreamRoute.name,
          initialChildren: children,
        );

  static const String name = 'ExplanationsForTheStreamRoute';

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
/// [InstructionAppScreen]
class InstructionAppScreenRoute extends PageRouteInfo<void> {
  const InstructionAppScreenRoute({List<PageRouteInfo>? children})
      : super(
          InstructionAppScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'InstructionAppScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
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
/// [LoginPhoneConfirmScreen]
class LoginPhoneConfirmScreenRoute
    extends PageRouteInfo<LoginPhoneConfirmScreenRouteArgs> {
  LoginPhoneConfirmScreenRoute({
    Key? key,
    required String phone,
    required String code,
    List<PageRouteInfo>? children,
  }) : super(
          LoginPhoneConfirmScreenRoute.name,
          args: LoginPhoneConfirmScreenRouteArgs(
            key: key,
            phone: phone,
            code: code,
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
    required this.code,
  });

  final Key? key;

  final String phone;

  final String code;

  @override
  String toString() {
    return 'LoginPhoneConfirmScreenRouteArgs{key: $key, phone: $phone, code: $code}';
  }
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
/// [OurMissionScreen]
class OurMissionScreenRoute extends PageRouteInfo<void> {
  const OurMissionScreenRoute({List<PageRouteInfo>? children})
      : super(
          OurMissionScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'OurMissionScreenRoute';

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
/// [TheoriesRouterScreen]
class TheoriesRouter extends PageRouteInfo<void> {
  const TheoriesRouter({List<PageRouteInfo>? children})
      : super(
          TheoriesRouter.name,
          initialChildren: children,
        );

  static const String name = 'TheoriesRouter';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TheoriesScreen]
class TheoriesScreenRoute extends PageRouteInfo<void> {
  const TheoriesScreenRoute({List<PageRouteInfo>? children})
      : super(
          TheoriesScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'TheoriesScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TheoryPostScreen]
class TheoryPostScreenRoute extends PageRouteInfo<TheoryPostScreenRouteArgs> {
  TheoryPostScreenRoute({
    Key? key,
    required Map<dynamic, dynamic> data,
    required int postId,
    List<PageRouteInfo>? children,
  }) : super(
          TheoryPostScreenRoute.name,
          args: TheoryPostScreenRouteArgs(
            key: key,
            data: data,
            postId: postId,
          ),
          rawPathParams: {'postId': postId},
          initialChildren: children,
        );

  static const String name = 'TheoryPostScreenRoute';

  static const PageInfo<TheoryPostScreenRouteArgs> page =
      PageInfo<TheoryPostScreenRouteArgs>(name);
}

class TheoryPostScreenRouteArgs {
  const TheoryPostScreenRouteArgs({
    this.key,
    required this.data,
    required this.postId,
  });

  final Key? key;

  final Map<dynamic, dynamic> data;

  final int postId;

  @override
  String toString() {
    return 'TheoryPostScreenRouteArgs{key: $key, data: $data, postId: $postId}';
  }
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
/// [TodoInfoScreen]
class TodoInfoScreenRoute extends PageRouteInfo<void> {
  const TodoInfoScreenRoute({List<PageRouteInfo>? children})
      : super(
          TodoInfoScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'TodoInfoScreenRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TodoItemScreen]
class TodoItemScreenRoute extends PageRouteInfo<TodoItemScreenRouteArgs> {
  TodoItemScreenRoute({
    Key? key,
    required TodoEntity todo,
    List<PageRouteInfo>? children,
  }) : super(
          TodoItemScreenRoute.name,
          args: TodoItemScreenRouteArgs(
            key: key,
            todo: todo,
          ),
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

  final TodoEntity todo;

  @override
  String toString() {
    return 'TodoItemScreenRouteArgs{key: $key, todo: $todo}';
  }
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
/// [TwoTargetScreen]
class TwoTargetScreenRoute extends PageRouteInfo<void> {
  const TwoTargetScreenRoute({List<PageRouteInfo>? children})
      : super(
          TwoTargetScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'TwoTargetScreenRoute';

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
