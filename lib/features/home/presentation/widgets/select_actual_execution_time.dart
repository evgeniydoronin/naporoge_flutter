import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/utils/get_actual_student_day.dart';
import '../bloc/save_day_result/day_result_bloc.dart';

class SelectActualExecutionTime extends StatefulWidget {
  const SelectActualExecutionTime({super.key});

  @override
  State<SelectActualExecutionTime> createState() => _SelectActualExecutionTimeState();
}

class _SelectActualExecutionTimeState extends State<SelectActualExecutionTime> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    List prepareHours = List.generate(23, (index) => index + 4);
    // [04, 05, 06, 07, 08, 09, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 00, 01, 02]
    List<String> hours = [];

    List prepareMinutes = List.generate(12, (index) => index * 5);
    List<String> minutes = [];

    List<String> untilHourCanChoose = [];
    List<String> untilMinuteCanChoose = [];

    int prepareCurrentHour = now.hour;
    String? currentHour;
    if (prepareCurrentHour <= 9) {
      currentHour = '0$prepareCurrentHour';
    } else {
      currentHour = prepareCurrentHour.toString();
    }
    for (int i = 0; i < hours.length; i++) {}

    int currentMinute = now.minute - (now.minute % 5);

    for (int i = 0; i < prepareHours.length; i++) {
      // добавление текущего часа по умолчанию
      prepareCurrentHour = i;
      if (i <= 5) {
        hours.add('0${prepareHours[i]}');
      } else if (i == 20) {
        hours.add('00');
      } else if (i >= 21) {
        hours.add('0${prepareHours[i] - 24}');
      } else {
        hours.add('${prepareHours[i]}');
      }
    }

    for (int i = 0; i < prepareMinutes.length; i++) {
      if (i == 0 || i == 1) {
        minutes.add('0${prepareMinutes[i]}');
      } else {
        minutes.add('${prepareMinutes[i]}');
      }
    }

    // до какого часа можно выбрать
    int? untilHourCanChooseIndex;
    for (int i = 0; i < hours.length; i++) {
      if (int.parse(currentHour) == int.parse(hours[i])) {
        untilHourCanChooseIndex = i + 1;
      }
    }

    if (untilHourCanChooseIndex != null) {
      untilHourCanChoose.addAll(hours.getRange(0, untilHourCanChooseIndex).toList());
    }

    // до какой минуты можно выбрать
    int? untilMinuteCanChooseIndex;
    for (int i = 0; i < minutes.length; i++) {
      if (currentMinute == int.parse(minutes[i])) {
        untilMinuteCanChooseIndex = i + 1;
      }
    }

    if (untilMinuteCanChooseIndex != null) {
      untilMinuteCanChoose.addAll(minutes.getRange(0, untilMinuteCanChooseIndex).toList());
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
        decoration: AppLayout.boxDecorationShadowBG,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Время начала дела', style: AppFont.formLabel),
            const SizedBox(height: 5),
            Column(
              children: [
                BlocBuilder<DayResultBloc, DayResultState>(
                  builder: (context, state) {
                    print('state.completedAt 1: ${state.completedAt}');
                    print('state.completedAt 2: ${context.watch<DayResultBloc>().state.completedAt}');
                    String _hour = currentHour!;
                    String _minute = currentMinute.toString();
                    return TextFormField(
                      readOnly: true,
                      onTap: () async {
                        // сброс минут при открытии попапа
                        context.read<DayResultBloc>().add(UntilMinuteCanChanged(untilMinuteCanChoose));
                        showDialog<void>(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext ctx) {
                            return BlocConsumer<DayResultBloc, DayResultState>(
                              listener: (context, state) {
                                // TODO: implement listener
                              },
                              builder: (context, state) {
                                return AlertDialog(
                                  title: const Text('Выбрать время'),
                                  shape: RoundedRectangleBorder(borderRadius: AppLayout.primaryRadius),
                                  content: SizedBox(
                                    height: 150,
                                    child: CupertinoTheme(
                                      data: const CupertinoThemeData(
                                        textTheme: CupertinoTextThemeData(
                                          dateTimePickerTextStyle: TextStyle(fontSize: 26),
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 230,
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  flex: 1,
                                                  fit: FlexFit.loose,
                                                  child: CupertinoPicker(
                                                    magnification: 1.22,
                                                    squeeze: 1.2,
                                                    useMagnifier: true,
                                                    itemExtent: 32,
                                                    // This sets the initial item.
                                                    scrollController: FixedExtentScrollController(
                                                      initialItem: prepareCurrentHour,
                                                    ),
                                                    // This is called when selected item is changed.
                                                    onSelectedItemChanged: (int selectedHourIndex) {
                                                      // print('hours: $hours');
                                                      // print('selectedHourIndex: $selectedHourIndex');
                                                      // print('currentHour: $currentHour');
                                                      // print('minutes: $minutes');
                                                      // print(
                                                      //     'untilHourCanChoose: ${untilHourCanChoose[selectedHourIndex]}');

                                                      // сброс ограничения минут
                                                      if (untilHourCanChoose[selectedHourIndex] != currentHour) {
                                                        // print('minutes: $minutes');
                                                        context
                                                            .read<DayResultBloc>()
                                                            .add(UntilMinuteCanChanged(minutes));
                                                      }
                                                      // текущий час, ставим ограничение по текущим минутам
                                                      else {
                                                        // print('untilMinuteCanChoose: $untilMinuteCanChoose');
                                                        context
                                                            .read<DayResultBloc>()
                                                            .add(UntilMinuteCanChanged(untilMinuteCanChoose));
                                                      }

                                                      _hour = hours[selectedHourIndex];
                                                    },
                                                    children:
                                                        List<Widget>.generate(untilHourCanChoose.length, (int index) {
                                                      return Center(child: Text(untilHourCanChoose[index]));
                                                    }),
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 1,
                                                  fit: FlexFit.loose,
                                                  child: CupertinoPicker(
                                                    magnification: 1.22,
                                                    squeeze: 1.2,
                                                    useMagnifier: true,
                                                    itemExtent: 32,
                                                    // This sets the initial item.
                                                    scrollController: FixedExtentScrollController(
                                                      initialItem: currentMinute,
                                                    ),
                                                    // This is called when selected item is changed.
                                                    onSelectedItemChanged: (int selectedMinuteIndex) {
                                                      _minute = state.untilMinuteCan != null
                                                          ? state.untilMinuteCan![selectedMinuteIndex]
                                                          : untilMinuteCanChoose[selectedMinuteIndex];
                                                    },
                                                    children: List<Widget>.generate(
                                                        state.untilMinuteCan != null
                                                            ? state.untilMinuteCan!.length
                                                            : untilMinuteCanChoose.length, (int index) {
                                                      return Center(
                                                        child: Text(state.untilMinuteCan != null
                                                            ? state.untilMinuteCan![index]
                                                            : untilMinuteCanChoose[index]),
                                                      );
                                                    }),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                  insetPadding: EdgeInsets.zero,
                                  actions: <Widget>[
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle: Theme.of(context).textTheme.labelLarge,
                                      ),
                                      child: const Text('Отменить'),
                                      onPressed: () async {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle: Theme.of(context).textTheme.labelLarge,
                                      ),
                                      child: const Text('Выбрать'),
                                      onPressed: () async {
                                        DateTime actualStudentDay = getActualStudentDay();
                                        // print('_hour: $_hour');
                                        // print('_minute: $_minute');

                                        DateTime completedTime = DateTime(actualStudentDay.year, actualStudentDay.month,
                                            actualStudentDay.day, int.parse(_hour), int.parse(_minute));

                                        print("completedTime: $completedTime");
                                        final formatter = DateFormat('yyyy-MM-dd HH:mm').format(completedTime);
                                        // print("formatter: $formatter");

                                        if (context.mounted) {
                                          context.read<DayResultBloc>().add(CompletedTimeChanged(formatter.toString()));
                                          Navigator.pop(context);
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Заполните обязательное поле!';
                        }
                        return null;
                      },
                      controller: TextEditingController(
                          text: state.completedAt != null && state.completedAt!.isNotEmpty
                              ? DateFormat('HH:mm').format(DateTime.parse(state.completedAt.toString()))
                              : null),
                      style: TextStyle(fontSize: AppFont.small),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColor.grey1,
                        hintText: state.completedAt != null && state.completedAt!.isNotEmpty
                            ? DateFormat('HH:mm').format(DateTime.parse(state.completedAt.toString()))
                            : 'Выбрать время начала',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: AppLayout.smallRadius,
                          borderSide: BorderSide(width: 1, color: AppColor.grey1),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
