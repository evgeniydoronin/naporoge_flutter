import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:naporoge/core/constants/app_theme.dart';

import '../presentation/bloc/save_day_result/day_result_bloc.dart';

Future selectActualExecutionTime(context) async {
  DateTime now = DateTime.now();
  int currentHour = now.hour;
  int currentMinute = now.minute - (now.minute % 5);

  List prepareHours = List.generate(23, (index) => index + 4);
  List<String> hours = [];
  for (int i = 0; i < prepareHours.length; i++) {
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
  List prepareMinutes = List.generate(12, (index) => index * 5);
  List<String> minutes = [];
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
    if (currentHour == int.parse(hours[i])) {
      untilHourCanChooseIndex = i + 1;
    }
  }
  List<String> untilHourCanChoose = [];
  if (untilHourCanChooseIndex != null) {
    untilHourCanChoose.addAll(hours.getRange(0, untilHourCanChooseIndex).toList());
  }

  print('untilHourCanChoose: $untilHourCanChoose');

  // до какой минуты можно выбрать
  int? untilMinuteCanChooseIndex;
  for (int i = 0; i < minutes.length; i++) {
    if (currentMinute == int.parse(minutes[i])) {
      untilMinuteCanChooseIndex = i + 1;
    }
  }
  List<String> untilMinuteCanChoose = [];
  if (untilMinuteCanChooseIndex != null) {
    untilMinuteCanChoose.addAll(minutes.getRange(0, untilMinuteCanChooseIndex).toList());
  }
  print('untilMinuteCanChoose : $untilMinuteCanChoose');

  showDialog<void>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext ctx) {
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
                            initialItem: currentHour,
                          ),
                          // This is called when selected item is changed.
                          onSelectedItemChanged: (int selectedHour) {
                            print('selectedHour: $selectedHour');
                            print('currentHour: $currentHour');
                            print('untilHourCanChoose: ${untilHourCanChoose[selectedHour]}');

                            if (untilHourCanChoose[selectedHour] != currentHour.toString()) {
                              print('object');
                              untilMinuteCanChoose = [];
                            }
                            // setState(() {
                            //   _selectedFruit = selectedItem;
                            // });
                          },
                          children: List<Widget>.generate(untilHourCanChoose.length, (int index) {
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
                          onSelectedItemChanged: (int selectedMinute) {
                            // setState(() {
                            //   _selectedFruit = selectedItem;
                            // });
                          },
                          children: List<Widget>.generate(untilMinuteCanChoose.length, (int index) {
                            return Center(child: Text(untilMinuteCanChoose[index]));
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
              textStyle: Theme
                  .of(context)
                  .textTheme
                  .labelLarge,
            ),
            child: const Text('Отменить'),
            onPressed: () async {
              Navigator.pop(context);
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme
                  .of(context)
                  .textTheme
                  .labelLarge,
            ),
            child: const Text('Выбрать'),
            onPressed: () {
              // DateTime now = DateTime.now();
              // DateTime time = DateFormat('HH:mm').parse(duration.toString());
              // DateTime completedTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
              //
              // final formatter = DateFormat('yyyy-MM-dd HH:mm').format(completedTime);

              // context
              //     .read<DayResultBloc>()
              //     .add(CompletedTimeChanged(formatter.toString()));

              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );

  return [1];
}
