import 'package:collection/collection.dart';

Function eq = const ListEquality().equals;

final List<String> weekDaysNameRu = ['пн', 'вт', 'ср', 'чт', 'пт', 'сб', 'вс'];

class NPDayPeriod {
  NPDayPeriod({
    required this.title,
    required this.rows,
    required this.start,
    this.isExpanded = false,
  });

  String title;
  int rows;
  int start;
  bool isExpanded;
}

final List<NPDayPeriod> periodRows = [
  NPDayPeriod(title: 'Утро', rows: 8, start: 4),
  NPDayPeriod(title: 'День', rows: 7, start: 12),
  NPDayPeriod(title: 'Вечер', rows: 8, start: 19),
];

List periodHoursIndexList = [
  {
    "04": [0, 0]
  },
  {
    "05": [0, 1]
  },
  {
    "06": [0, 2]
  },
  {
    "07": [0, 3]
  },
  {
    "08": [0, 4]
  },
  {
    "09": [0, 5]
  },
  {
    "10": [0, 6]
  },
  {
    "11": [0, 7]
  },
  {
    "12": [1, 0]
  },
  {
    "13": [1, 1]
  },
  {
    "14": [1, 2]
  },
  {
    "15": [1, 3]
  },
  {
    "16": [1, 4]
  },
  {
    "17": [1, 5]
  },
  {
    "18": [1, 6]
  },
  {
    "19": [2, 0]
  },
  {
    "20": [2, 1]
  },
  {
    "21": [2, 2]
  },
  {
    "22": [2, 3]
  },
  {
    "23": [2, 4]
  },
  {
    "00": [2, 5]
  },
  {
    "01": [2, 6]
  },
  {
    "02": [2, 7]
  },
];

double defaultAllTitleHeight = 220;

// высота периодов по умолчанию
List<Map> weeksPeriodsHeight = [];
