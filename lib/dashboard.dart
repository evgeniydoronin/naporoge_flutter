import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/services/db_client/isar_service.dart';
import 'core/utils/get_next_week_data.dart';
import 'core/utils/get_stream_status.dart';
import 'features/planning/presentation/bloc/planner_bloc.dart';
import 'core/constants/app_theme.dart';
import 'core/routes/app_router.dart';

@RoutePage()
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final AppLifecycleListener _appLifecycleListener;
  DateTime? lastExitTime;

  @override
  void initState() {
    super.initState();

    // Initialize the AppLifecycleListener class and pass callbacks
    _appLifecycleListener = AppLifecycleListener(
      onStateChange: _onStateChanged,
    );
    _showDialogOnFirstLaunch();
  }

  @override
  void dispose() {
    // Do not forget to dispose the listener
    _appLifecycleListener.dispose();

    super.dispose();
  }

  // Listen to the app lifecycle state changes
  void _onStateChanged(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        _onDetached();
        break;
      case AppLifecycleState.resumed:
        _onResumed();
        break;
      case AppLifecycleState.inactive:
        _onInactive();
        break;
      case AppLifecycleState.hidden:
        _onHidden();
        break;
      case AppLifecycleState.paused:
        _onPaused();
        break;
    }
  }

  void _onDetached() => print('detached');

  // void _onResumed() => context.router.replace(const SplashScreenRoute());
  /// проверяем повторное открытие приложение
  void _onResumed() async {
    final prefs = await SharedPreferences.getInstance();
    final _pausedLastExitTime = prefs.getInt('pausedLastExitTime');
    final _inactiveLastExitTime = prefs.getInt('inactiveLastExitTime');

    if (_pausedLastExitTime != null) {
      final pausedLastExitTime = DateTime.fromMillisecondsSinceEpoch(_pausedLastExitTime);
      final currentTime = DateTime.now();
      final difference = currentTime.difference(pausedLastExitTime);
      final minutesPassed = difference.inMinutes;

      /// если прошло больше 5 минут - обновляем стейты
      if (minutesPassed > 30) {
        if (mounted) {
          context.router.replace(const SplashScreenRoute());
        }
      }
      print('Приложение было свернуто');
      print('Прошло $minutesPassed минут(ы) с момента последнего захода');
      await prefs.remove('pausedLastExitTime');
    } else if (_inactiveLastExitTime != null && _pausedLastExitTime == null) {
      final lastExitTime = DateTime.fromMillisecondsSinceEpoch(_inactiveLastExitTime);
      final currentTime = DateTime.now();
      final difference = currentTime.difference(lastExitTime);
      final minutesPassed = difference.inMinutes;

      /// если прошло больше 10 минут - обновляем стейты
      if (minutesPassed > 30) {
        if (mounted) {
          context.router.replace(const SplashScreenRoute());
        }
      }
      print('Шторка была опущена');
      print('Прошло $minutesPassed минут(ы) с момента последнего захода');
    }
    print('resumed');
  }

  void _onInactive() async {
    // сохраняем текущее время
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('inactiveLastExitTime', DateTime.now().millisecondsSinceEpoch);
    print('inactive inactiveLastExitTime: ${prefs.getInt('inactiveLastExitTime')}');
    print('inactive pausedLastExitTime: ${prefs.getInt('pausedLastExitTime')}');
    print('inactive');
  }

  void _onHidden() async {
    print('hidden');
  }

  void _onPaused() async {
    // Приложение свернуто, сохраняем текущее время
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('pausedLastExitTime', DateTime.now().millisecondsSinceEpoch);
    print('paused pausedLastExitTime: ${prefs.getInt('pausedLastExitTime')}');
    print('paused inactiveLastExitTime: ${prefs.getInt('inactiveLastExitTime')}');
  }

  /// диалоговое окно для составления плана на следующую неделю
  Future<void> _showDialogOnFirstLaunch() async {
    DateTime now = DateTime.now();

    Map streamStatus = await getStreamStatus();
    print('streamStatus: $streamStatus');

    if (streamStatus['status'] != 'before' && streamStatus['status'] != 'after') {
      /// есть ли следующая неделя для создания
      final nextWeekData = await getNextWeekData();

      /// проверка в субботу или воскресенье
      if (now.weekday == 6 || now.weekday == 7) {
        if (!nextWeekData['isExistNextWeek'] && mounted) {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: AppLayout.primaryRadius),
              title: const Text(
                'Пришло время составить план на следующую неделю',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              actionsPadding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.router.navigate(const PlanningScreenRoute());
                        },
                        style: AppLayout.accentBTNStyle,
                        child: const Text(
                          'Перейти в план',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                        'Напомнить позже',
                        style: TextStyle(color: AppColor.grey3),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      animationDuration: const Duration(microseconds: 0),
      routes: const [
        HomesEmptyRouter(),
        PlanningScreenRoute(),
        DiaryScreenRoute(),
        StatisticsScreenRoute(),
        MoreScreenRoute(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        return BottomNavigationBar(
          currentIndex: tabsRouter.activeIndex,
          onTap: (val) {
            // сброс раздела Планирование
            // при переходе по вкладкам
            // необходим для сброса стейта с финальными ячейками
            // если пользователь ушёл с планнера без сохранения
            context.read<PlannerBloc>().add(const FinalCellForCreateStream(finalCellIDs: []));

            // сброс Заметок в Дневнике для Заметок на текущий день
            // context.read<DiaryBloc>().add(DiaryLastNoteChanged({'createAt': DateTime.now()}));

            // сброс Заметок в Дневнике для Результатов дня на текущий день
            // context.read<DiaryBloc>().add(DiaryDayResultsChanged({'createAt': DateTime.now()}));
            // переход по вкладкам
            tabsRouter.setActiveIndex(val);
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColor.lightBGItem,
          elevation: 0,
          fixedColor: const Color(0xff6F6AA6),
          selectedFontSize: 12,
          selectedLabelStyle: const TextStyle(height: 2),
          iconSize: 24,
          items: [
            BottomNavigationBarItem(
              label: 'Главная',
              icon: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SvgPicture.asset(
                  'assets/icons/home.svg',
                  colorFilter: ColorFilter.mode(AppColor.grey3, BlendMode.srcIn),
                ),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SvgPicture.asset(
                  'assets/icons/home.svg',
                  colorFilter: ColorFilter.mode(AppColor.activeBottomIcon, BlendMode.srcIn),
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: 'План',
              icon: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SvgPicture.asset(
                  'assets/icons/planing.svg',
                  colorFilter: ColorFilter.mode(AppColor.grey3, BlendMode.srcIn),
                ),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SvgPicture.asset(
                  'assets/icons/planing.svg',
                  colorFilter: ColorFilter.mode(AppColor.activeBottomIcon, BlendMode.srcIn),
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: 'Дневник',
              icon: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SvgPicture.asset(
                  'assets/icons/diary.svg',
                  colorFilter: ColorFilter.mode(AppColor.grey3, BlendMode.srcIn),
                ),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SvgPicture.asset(
                  'assets/icons/diary.svg',
                  colorFilter: ColorFilter.mode(AppColor.activeBottomIcon, BlendMode.srcIn),
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: 'Статистика',
              icon: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SvgPicture.asset(
                  'assets/icons/statistic.svg',
                  colorFilter: ColorFilter.mode(AppColor.grey3, BlendMode.srcIn),
                ),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SvgPicture.asset(
                  'assets/icons/statistic.svg',
                  colorFilter: ColorFilter.mode(AppColor.activeBottomIcon, BlendMode.srcIn),
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: 'Ещё',
              icon: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SvgPicture.asset(
                  'assets/icons/more.svg',
                  height: 23,
                  fit: BoxFit.scaleDown,
                  colorFilter: ColorFilter.mode(AppColor.grey3, BlendMode.srcIn),
                ),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SvgPicture.asset(
                  'assets/icons/more.svg',
                  height: 23,
                  fit: BoxFit.scaleDown,
                  colorFilter: ColorFilter.mode(AppColor.activeBottomIcon, BlendMode.srcIn),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
