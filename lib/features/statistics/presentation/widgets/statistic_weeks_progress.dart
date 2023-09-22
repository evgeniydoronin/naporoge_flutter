import 'package:flutter/material.dart';
import 'package:naporoge/core/utils/get_week_number.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/services/controllers/service_locator.dart';
import '../../../../core/utils/circular_loading.dart';
import '../../../planning/data/sources/local/stream_local_storage.dart';
import '../../../planning/domain/entities/stream_entity.dart';
import '../../../planning/presentation/stream_controller.dart';
import '../utils/get_weeks_process.dart';

List weekDayName = [
  'Пн',
  'Вт',
  'Ср',
  'Чт',
  'Пт',
  'Сб',
  'Вс',
];

class WeeksProgressBox extends StatefulWidget {
  const WeeksProgressBox({super.key});

  @override
  State<WeeksProgressBox> createState() => _WeeksProgressBoxState();
}

class _WeeksProgressBoxState extends State<WeeksProgressBox> {
  int activePage = 0;
  final _formKey = GlobalKey<FormState>();
  final PageController pageController = PageController(initialPage: 0);
  final _streamController = getIt<StreamController>();
  TextEditingController progress = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getWeeksProcess(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List weeksProgress = snapshot.data;

          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 390,
                  child: Stack(children: [
                    PageView.builder(
                        controller: pageController,
                        itemCount: weeksProgress.length,
                        onPageChanged: (int page) async {
                          setState(() {
                            activePage = page;
                          });
                        },
                        itemBuilder: (BuildContext context, int index) {
                          Map weekData = weeksProgress[index];
                          Week week = weekData['week'];
                          List daysProgress = weekData['daysProgress'];
                          progress = TextEditingController(text: week.progress);

                          DateTime now = DateTime.now();

                          int currentWeek = getWeekNumber(now);

                          // add data to weekResult
                          List weekResult = [];
                          for (int i = 0; i < daysProgress.length; i++) {
                            String dayResult = '';
                            // есть результат дня
                            if (daysProgress[i]['dayResult'] != null) {
                              DayResult res = daysProgress[i]['dayResult'];
                              dayResult = res.result ?? '';
                            }
                            // нет результата
                            else {
                              // неделя прошла
                              if (currentWeek > week.weekNumber!) {
                                dayResult = 'пропуск';
                              }
                              // текущая неделя
                              else if (currentWeek == week.weekNumber) {
                                if (now.weekday > i + 1) {
                                  dayResult = 'пропуск';
                                }
                              }
                            }

                            weekResult.add(TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    weekDayName[i],
                                    style: TextStyle(fontSize: AppFont.small, color: AppColor.grey2),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    dayResult,
                                    style: dayResult == 'пропуск'
                                        ? TextStyle(fontSize: AppFont.small, color: AppColor.grey2)
                                        : TextStyle(fontSize: AppFont.small),
                                  ),
                                ),
                              ],
                            ));
                          }

                          return Column(
                            children: [
                              Text(
                                'Неделя ${index + 1}',
                                style: AppFont.scaffoldTitleDark,
                              ),
                              const SizedBox(height: 10),
                              Table(
                                columnWidths: const {1: FractionColumnWidth(.9)},
                                border: TableBorder(
                                  horizontalInside: BorderSide(width: 1, color: AppColor.grey1),
                                  verticalInside: BorderSide(width: 1, color: AppColor.grey1),
                                  bottom: BorderSide(width: 1, color: AppColor.grey1),
                                ),
                                children: [...weekResult],
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: progress,
                                style: TextStyle(fontSize: AppFont.small),
                                maxLines: 3,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColor.grey1,
                                    hintText: 'Например: удалось пробежать 5 км, прочитать полкниги, сбросить 2 кг',
                                    hintStyle: TextStyle(color: AppColor.grey3),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                                    isDense: true,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: AppLayout.smallRadius,
                                        borderSide: BorderSide(width: 1, color: AppColor.grey1))),
                                validator: (value) {
                                  // print(maskFormatter.getUnmaskedText().length);
                                  if (value == null || value.isEmpty) {
                                    return 'Обязательное поле';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          );
                        }),
                    Positioned(
                      bottom: 0,
                      child: SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width - 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List<Widget>.generate(
                              weeksProgress.length,
                                  (index) =>
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: CircleAvatar(
                                      maxRadius: 5,
                                      backgroundColor: activePage == index ? AppColor.accent : AppColor.grey1,
                                    ),
                                  )),
                        ),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 25),
                weeksProgress[0]['weekResultsSave'] == true
                    ? Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            CircularLoading(context).startLoading();

                            final streamLocalStorage = StreamLocalStorage();

                            Map progressData = {};
                            int index = pageController.page!.floor().toInt();
                            Week week = weeksProgress[index]['week'];

                            await Future.delayed(const Duration(milliseconds: 200));

                            progressData['week_id'] = week.id;
                            progressData['week_progress'] = progress.text;

                            // create on server
                            var updateWeekProgress = await _streamController.updateWeekProgress(progressData);

                            // print('updateWeekProgress: $updateWeekProgress');

                            // save on local
                            await streamLocalStorage.updateWeekProgress(updateWeekProgress);

                            if (context.mounted) {
                              CircularLoading(context).stopLoading();
                            }
                          }
                        },
                        style: AppLayout.accentBTNStyle,
                        child: Text(
                          'Отметить достижения недели',
                          style: AppFont.regularSemibold,
                        ),
                      ),
                    ),
                  ],
                )
                    : const SizedBox(),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
