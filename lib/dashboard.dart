import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naporoge/features/planning/presentation/bloc/planner_bloc.dart';
import 'core/constants/app_theme.dart';

import 'core/routes/app_router.dart';

@RoutePage()
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
            // переход по вкладкам
            tabsRouter.setActiveIndex(val);
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColor.bottomNavBG,
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
