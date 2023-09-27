import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../planning/domain/entities/stream_entity.dart';
import 'dart:math' as math;
import '../../../../core/constants/app_theme.dart';
import '../bloc/diary_bloc.dart';
import '../utils/get_diary_day_results.dart';

class DiaryDayResultsWidget extends StatefulWidget {
  const DiaryDayResultsWidget({super.key});

  @override
  State<DiaryDayResultsWidget> createState() => _DiaryDayResultsWidgetState();
}

class _DiaryDayResultsWidgetState extends State<DiaryDayResultsWidget> {
  DateTime? currentDay;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DiaryBloc, DiaryState>(
      listener: (context, state) {},
      builder: (context, state) {
        currentDay = state.lastNote['createAt'];

        if (state.currentMonth.isNotEmpty) {
          currentDay = state.currentMonth['currentDay'];
        } else {
          currentDay = DateTime.now();
        }

        return FutureBuilder(
            future: getDiaryDayResults(currentDay),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map data = snapshot.data;
                DayResult dayResult = data['dayResult'];
                String completedAt = DateFormat('HH:mm').format(data['completedAt']);

                String wishPowerDesires = '';
                if (dayResult.desires == 'large') {
                  wishPowerDesires = 'Большая';
                } else if (dayResult.desires == 'middle') {
                  wishPowerDesires = 'Средняя';
                } else if (dayResult.desires == 'small') {
                  wishPowerDesires = 'Малая';
                }

                String wishPowerReluctance = '';
                if (dayResult.reluctance == 'large') {
                  wishPowerReluctance = 'Большая';
                } else if (dayResult.reluctance == 'middle') {
                  wishPowerReluctance = 'Средняя';
                } else if (dayResult.reluctance == 'small') {
                  wishPowerReluctance = 'Малая';
                }

                bool isRejoiceWrap = false;
                bool rejoiceResults = false;
                if (dayResult.rejoice != null) {
                  isRejoiceWrap = true;

                  if (dayResult.rejoice == 'yes') {
                    rejoiceResults = true;
                  }
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: AppLayout.boxDecorationShadowBG,
                    child: Theme(
                      data: ThemeData().copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        maintainState: true,
                        tilePadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 18),
                        title: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Учет результатов',
                                  style: AppFont.scaffoldTitleDark,
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Contents
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration:
                                      BoxDecoration(border: Border(top: BorderSide(width: 1, color: AppColor.grey1))),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 17),
                              decoration:
                                  BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: AppColor.grey1))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Фактическое время начала дела'),
                                  Text(completedAt),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 17),
                              decoration:
                                  BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: AppColor.grey1))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Объём выполнения'),
                                  Text('${dayResult.executionScope.toString()}%'),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 17),
                              decoration:
                                  BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: AppColor.grey1))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Результат дня',
                                    style: AppFont.formLabel,
                                  ),
                                  const SizedBox(height: 5),
                                  TextField(
                                    readOnly: true,
                                    style: TextStyle(fontSize: AppFont.small, color: Colors.red),
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: AppColor.grey1,
                                        hintText: dayResult.result,
                                        hintStyle: TextStyle(color: AppColor.accent),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                                        isDense: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: AppLayout.smallRadius,
                                            borderSide: BorderSide(width: 1, color: AppColor.grey1))),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 17),
                              decoration:
                                  BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: AppColor.grey1))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Сила нежеланий'),
                                  Text(wishPowerReluctance),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 17),
                              decoration:
                                  BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: AppColor.grey1))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Иные помехи и трудности',
                                    style: AppFont.formLabel,
                                  ),
                                  const SizedBox(height: 5),
                                  TextField(
                                    readOnly: true,
                                    style: TextStyle(fontSize: AppFont.small, color: Colors.red),
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: AppColor.grey1,
                                        hintText: dayResult.interference,
                                        hintStyle: TextStyle(color: AppColor.accent),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                                        isDense: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: AppLayout.smallRadius,
                                            borderSide: BorderSide(width: 1, color: AppColor.grey1))),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 17),
                              decoration:
                                  BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: AppColor.grey1))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Сила желаний'),
                                  Text(wishPowerDesires),
                                ],
                              ),
                            ),
                          ),
                          isRejoiceWrap
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 18),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 17),
                                    decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(width: 1, color: AppColor.grey1))),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Удалось порадоваться?'),
                                        rejoiceResults
                                            ? Transform(
                                                alignment: Alignment.center,
                                                transform: Matrix4.rotationY(math.pi),
                                                child: SvgPicture.asset('assets/icons/342.svg'),
                                              )
                                            : RotatedBox(
                                                quarterTurns: 2, child: SvgPicture.asset('assets/icons/342.svg')),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            });
      },
    );
  }
}
