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
  late String currentHour;
  late String currentMinute;
  List<String> hours = [];
  List<String> minutes = [];
  List<String> availableMinutes = [];

  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    currentHour = now.hour.toString().padLeft(2, '0');
    currentMinute = (now.minute - (now.minute % 5)).toString().padLeft(2, '0');

    hours = List.generate(now.hour - 3, (index) => (index + 4).toString().padLeft(2, '0'));
    minutes = List.generate(12, (index) => (index * 5).toString().padLeft(2, '0'));
    availableMinutes = _getAvailableMinutes(now);

    hourController = FixedExtentScrollController(initialItem: int.parse(currentHour) - 4);
    minuteController = FixedExtentScrollController(initialItem: int.parse(currentMinute) ~/ 5);
  }

  List<String> _getAvailableMinutes(DateTime now) {
    if (int.parse(currentHour) == now.hour) {
      return List.generate((now.minute ~/ 5) + 1, (index) => (index * 5).toString().padLeft(2, '0'));
    } else {
      return minutes;
    }
  }

  void _openTimePicker(BuildContext context) {
    showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            DateTime now = DateTime.now();
            setState(() {
              availableMinutes = (int.parse(currentHour) == now.hour) ? _getAvailableMinutes(now) : minutes;
              minuteController.dispose();
              minuteController = FixedExtentScrollController(initialItem: int.parse(currentMinute) ~/ 5);
            });
            return AlertDialog(
              title: const Text('Выбрать время'),
              shape: RoundedRectangleBorder(borderRadius: AppLayout.primaryRadius),
              backgroundColor: Colors.white,
              content: SizedBox(
                height: 150,
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                        fontSize: 26,
                        color:
                            MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        fit: FlexFit.loose,
                        child: CupertinoPicker(
                          magnification: 1.22,
                          squeeze: 1.2,
                          useMagnifier: true,
                          itemExtent: 32,
                          scrollController: hourController,
                          onSelectedItemChanged: (int selectedHourIndex) {
                            setState(() {
                              currentHour = hours[selectedHourIndex];
                              availableMinutes =
                                  (int.parse(currentHour) == now.hour) ? _getAvailableMinutes(now) : minutes;
                              minuteController.dispose();
                              minuteController = FixedExtentScrollController(initialItem: 0);
                            });
                          },
                          children: List<Widget>.generate(hours.length, (int index) {
                            return Center(child: Text(hours[index], style: const TextStyle(color: Colors.black)));
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
                          scrollController: minuteController,
                          onSelectedItemChanged: (int selectedMinuteIndex) {
                            setState(() {
                              currentMinute = availableMinutes[selectedMinuteIndex];
                            });
                          },
                          children: List<Widget>.generate(availableMinutes.length, (int index) {
                            return Center(
                                child: Text(availableMinutes[index], style: const TextStyle(color: Colors.black)));
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Отменить'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: const Text('Выбрать'),
                  onPressed: () {
                    DateTime actualStudentDay = getActualStudentDay();
                    DateTime completedTime = DateTime(
                      actualStudentDay.year,
                      actualStudentDay.month,
                      actualStudentDay.day,
                      int.parse(currentHour),
                      int.parse(currentMinute),
                    );

                    final formatter = DateFormat('yyyy-MM-dd HH:mm').format(completedTime);
                    if (context.mounted) {
                      print('formatter: $formatter');
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
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: AppLayout.boxDecorationShadowBG,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Время начала дела', style: AppFont.formLabel),
            const SizedBox(height: 5),
            BlocBuilder<DayResultBloc, DayResultState>(
              builder: (context, state) {
                return TextFormField(
                  readOnly: true,
                  onTap: () {
                    setState(() {
                      DateTime now = DateTime.now();
                      currentHour = now.hour.toString().padLeft(2, '0');
                      currentMinute = (now.minute - (now.minute % 5)).toString().padLeft(2, '0');
                      availableMinutes = (int.parse(currentHour) == now.hour) ? _getAvailableMinutes(now) : minutes;
                      hourController = FixedExtentScrollController(initialItem: int.parse(currentHour) - 4);
                      minuteController = FixedExtentScrollController(initialItem: int.parse(currentMinute) ~/ 5);
                    });
                    _openTimePicker(context);
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Заполните обязательное поле!';
                    }
                    return null;
                  },
                  controller: TextEditingController(
                    text: state.completedAt != null && state.completedAt!.isNotEmpty
                        ? DateFormat('HH:mm').format(DateTime.parse(state.completedAt!))
                        : '',
                  ),
                  style: TextStyle(fontSize: AppFont.small),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColor.grey1,
                    hintText: 'Выбрать время начала',
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
      ),
    );
  }
}
