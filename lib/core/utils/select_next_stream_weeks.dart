import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/planning/presentation/bloc/planner_bloc.dart';
import '../constants/app_theme.dart';
import '../routes/app_router.dart';

Future selectWeeks(context) async {
  int selectedWeek = 0;

  const List<String> weeks = <String>[
    '1 неделя',
    '2 недели',
    '3 недели',
    '4 недели',
    '5 недель',
    '6 недель',
    '7 недель',
    '8 недель',
    '9 недель',
  ];
  return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => AlertDialog(
            title: const Text(
              'Продолжительность нового дела',
              textAlign: TextAlign.center,
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        style: AppLayout.accentBTNStyle,
                        onPressed: () async {
                          // новое количество недель: _selectedWeek + 1
                          context.read<PlannerBloc>().add(StreamCourseWeeksChanged(selectedWeek + 1, true));
                          context.router.push(const StartDateSelectionScreenRoute());
                        },
                        child: Text(
                          'Выбрать',
                          style: AppFont.largeSemibold,
                        )),
                  ),
                ],
              ),
            ],
            content: SizedBox(
              height: 100,
              child: CupertinoPicker(
                magnification: 1.12,
                squeeze: 1,
                useMagnifier: true,
                itemExtent: 32.0,
                onSelectedItemChanged: (int value) {
                  selectedWeek = value;
                },
                scrollController: FixedExtentScrollController(
                  initialItem: selectedWeek,
                ),
                children: List<Widget>.generate(weeks.length, (int index) {
                  return Center(child: Text(weeks[index]));
                }),
              ),
            ),
            titlePadding: AppLayout.dialogTitlePadding,
            actionsPadding: AppLayout.dialogTitlePadding,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            titleTextStyle: AppLayout.dialogTitleTextStyle,
            shape: AppLayout.dialogShape,
          ));
}
