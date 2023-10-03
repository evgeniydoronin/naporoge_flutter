import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:naporoge/features/diary/domain/entities/diary_note_entity.dart';
import 'package:naporoge/features/diary/presentation/bloc/diary_bloc.dart';
import 'package:naporoge/features/planning/domain/entities/stream_entity.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/services/db_client/isar_service.dart';
import '../../../../core/utils/circular_loading.dart';
import '../utils/get_diary_last_note.dart';
import '../utils/get_month_data.dart';
import '../utils/get_diary_day_results.dart';

List<String> weekDay = [
  'пн',
  'вт',
  'ср',
  'чт',
  'пт',
  'сб',
  'вс',
];

class DiaryCalendarWidget extends StatefulWidget {
  const DiaryCalendarWidget({Key? key}) : super(key: key);

  @override
  State<DiaryCalendarWidget> createState() => _DiaryCalendarWidgetState();
}

class _DiaryCalendarWidgetState extends State<DiaryCalendarWidget> {
  DateTime? currentDay;

  @override
  Widget build(BuildContext context) {
    Map? monthData;
    return BlocConsumer<DiaryBloc, DiaryState>(
      listener: (context, state) {},
      builder: (context, state) {
        // print('DiaryCalendarWidget : $state');
        currentDay = DateTime.now();
        return FutureBuilder(
            future: getMonthData(currentDay, null),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                monthData = snapshot.data;

                // print('monthData: $monthData');

                if (state.currentMonth.isNotEmpty) {
                  monthData = state.currentMonth;
                }

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () async {
                              // CircularLoading(context).startLoading();
                              monthData = await getMonthData(monthData!['currentDay'], false);
                              if (monthData != null) {
                                if (context.mounted) {
                                  context.read<DiaryBloc>().add(DiaryMonthChanged(monthData!));
                                }
                                setState(() {
                                  currentDay = monthData!['currentDay'];
                                });
                                if (context.mounted) {
                                  // CircularLoading(context).stopAutoRouterLoading();
                                }
                              }
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              size: 15,
                            )),
                        Text(
                          monthData!['monthTitle'],
                          style: AppFont.scaffoldTitleDark,
                        ),
                        IconButton(
                          onPressed: () async {
                            // CircularLoading(context).startLoading();

                            monthData = await getMonthData(monthData!['currentDay'], true);

                            if (context.mounted) {
                              context.read<DiaryBloc>().add(DiaryMonthChanged(monthData!));
                            }
                            setState(() {
                              currentDay = monthData!['currentDay'];
                            });
                            if (context.mounted) {
                              // CircularLoading(context).stopAutoRouterLoading();
                            }
                          },
                          icon: const RotatedBox(
                            quarterTurns: 2,
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 7,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 7,
                                childAspectRatio: 2 / 1,
                              ),
                              itemBuilder: (BuildContext ctx, gridIndex) {
                                return Center(
                                    child: Text(
                                  weekDay[gridIndex].toUpperCase(),
                                  style: TextStyle(color: AppColor.grey3, fontSize: 13),
                                ));
                              }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    DiaryCalendarGrid(monthData: monthData ?? {}),
                    const SizedBox(height: 10),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            });
      },
    );
  }
}

class DiaryCalendarGrid extends StatefulWidget {
  final Map monthData;

  const DiaryCalendarGrid({super.key, required this.monthData});

  @override
  State<DiaryCalendarGrid> createState() => _DiaryCalendarGridState();
}

class _DiaryCalendarGridState extends State<DiaryCalendarGrid> {
  late DateTime isActiveDay;
  late DateTime selectedDay;

  @override
  void initState() {
    selectedDay = widget.monthData['currentDay'];
    isActiveDay = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print('isActiveDay: $isActiveDay');
    // print('widget.monthData: ${widget.monthData}');
    return FutureBuilder(
        future: getAllNotesInMonth(widget.monthData),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List noteInDays = snapshot.data;
            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 10,
                  mainAxisExtent: 30,
                ),
                itemCount: widget.monthData['days'] + widget.monthData['offsetStartMonth'],
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, cellIndex) {
                  DateTime? isNoteInDay;
                  final index = cellIndex + 1;
                  final _day = index - widget.monthData['offsetStartMonth'];
                  DateTime day =
                      DateTime(widget.monthData['currentDay'].year, widget.monthData['currentDay'].month, _day.toInt());

                  if (noteInDays.isNotEmpty) {
                    for (int i = 0; i < noteInDays.length; i++) {
                      DateTime noteInDay = DateTime.parse(noteInDays[i]);
                      // print('${noteInDay is DateTime}');
                      if (day.isAtSameMomentAs(noteInDay)) {
                        isNoteInDay = day;
                      }
                    }
                  }
                  // print('isNoteInDay: $isNoteInDay');
                  // вывод дней со сдвигом ячейки
                  if (widget.monthData['offsetStartMonth'] <= cellIndex) {
                    return GestureDetector(
                      onTap: () async {
                        // await Future.delayed(const Duration(seconds: 1));
                        // CircularLoading(context).startLoading();
                        // print('day: $day');

                        setState(() {
                          isActiveDay = day;
                        });

                        final lastNote = await getDiaryLastNote(day);
                        final dayResults = await getDiaryDayResults(day);
                        final monthResults = await getMonthData(day, null);

                        if (context.mounted) {
                          // данные для последней заметки
                          if (lastNote != null) {
                            DiaryNote note = lastNote;
                            Map _lastNote = {
                              'id': note.id,
                              'diaryNote': note.diaryNote,
                              'createAt': note.createAt,
                              'updateAt': note.updateAt,
                            };
                            context.read<DiaryBloc>().add(DiaryLastNoteChanged(_lastNote));
                          } else {
                            context.read<DiaryBloc>().add(DiaryLastNoteChanged({'day': day}));
                          }
                          // данные для результатов дня
                          if (dayResults != null) {
                            Map dR = dayResults;
                            DayResult result = dR['dayResult'];

                            Map _dayResults = {
                              'reluctance': result.reluctance,
                              'desires': result.desires,
                              'executionScope': result.executionScope,
                              'result': result.result,
                              'interference': result.interference,
                              'rejoice': result.rejoice,
                              'completedDay': dR['completedAt'],
                            };
                            context.read<DiaryBloc>().add(DiaryDayResultsChanged(_dayResults));
                          } else {
                            context.read<DiaryBloc>().add(DiaryDayResultsChanged({'day': day}));
                          }
                          // данные месяца
                          if (monthResults != null) {
                            context.read<DiaryBloc>().add(DiaryMonthChanged(monthResults));
                          }

                          // CircularLoading(context).stopAutoRouterLoading();
                        }
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isNoteInDay == day
                                  ? isActiveDay == day
                                      ? AppColor.accent.withOpacity(0.5)
                                      : AppColor.accent.withOpacity(0.1)
                                  : isActiveDay == day
                                      ? AppColor.accent.withOpacity(0.5)
                                      : AppColor.accent.withOpacity(0)),
                          child: Center(
                              child: Text(
                            day.day.toString(),
                            style: const TextStyle(fontSize: 20),
                          ))),
                    );
                  } else {
                    return const SizedBox();
                  }
                });
          } else {
            return const SizedBox();
          }
        });
  }
}

Future getAllNotesInMonth(monthData) async {
  List allNotes = [];

  final isarService = IsarService();
  final isar = await isarService.db;

  DateTime currentDay = monthData['currentDay'];
  DateTime firstDayOfMonth = DateTime(currentDay.year, currentDay.month, 1);
  DateTime lastDayOfMonth = DateTime(currentDay.year, currentDay.month + 1, 0);

  List notes =
      await isar.diaryNotes.filter().createAtBetween(firstDayOfMonth, lastDayOfMonth).sortByCreateAtDesc().findAll();

  for (DiaryNote note in notes) {
    allNotes.add(DateFormat('yyyy-MM-dd').format(note.createAt!));
  }

  return allNotes.toSet().toList();
}
