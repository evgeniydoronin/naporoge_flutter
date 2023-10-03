import 'package:intl/intl.dart';

Future getMonthData(date, direction) async {
  await Future.delayed(const Duration(milliseconds: 200));
  Map monthData = {};

  DateTime currentDay = date;

  DateTime firstDayOfPreviousMonth = DateTime(currentDay.year, currentDay.month - 1);

  DateTime firstDayOfMonth = DateTime(currentDay.year, currentDay.month, 1);
  DateTime lastDayOfMonth = DateTime(currentDay.year, currentDay.month + 1, 0);

  DateTime firstDayOfNextMonth = DateTime(currentDay.year, currentDay.month + 1);
  // lastDayOfNextMonth = DateTime(_currentDay.year, _currentDay.month + 1);

  // Начало месяца со сдвигом на нужную неделю
  int offsetStartMonth = firstDayOfMonth.weekday - 1;
  // Дней в месяце
  int daysInMonth = lastDayOfMonth.day;
  // Заголовок
  String monthTitle = DateFormat('LLLL', 'ru').format(currentDay);

  if (direction != null) {
    currentDay =
        direction ? DateTime(currentDay.year, currentDay.month + 1) : DateTime(currentDay.year, currentDay.month - 1);
    firstDayOfMonth = DateTime(currentDay.year, currentDay.month, 1);
    lastDayOfMonth = DateTime(currentDay.year, currentDay.month + 1, 0);
    offsetStartMonth = firstDayOfMonth.weekday - 1;
    daysInMonth = lastDayOfMonth.day;
    monthTitle = DateFormat('LLLL', 'ru').format(DateTime(currentDay.year, currentDay.month));
  }

  monthData = {
    'currentDay': currentDay,
    'monthTitle': monthTitle,
    'days': lastDayOfMonth.day,
    'offsetStartMonth': offsetStartMonth,
  };

  // print("$date, $direction, $monthData");
  return monthData;
}
