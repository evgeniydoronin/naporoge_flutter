import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import '../../../../../core/utils/get_actual_week_day.dart';
import '../../../../../core/services/db_client/isar_service.dart';
import '../../../../../core/utils/get_actual_student_day.dart';
import '../../../domain/entities/stream_entity.dart';
import '../core.dart';

Future getWeekData(NPStream stream, String status) async {
  final isarService = IsarService();
  final isar = await isarService.db;
  Map data = {};

  DateTime now = DateTime.now();

  // создано недель на курсе
  int createdWeeks = stream.weekBacklink.length;

  // формируем все недели с данными
  List weeksOnPage = [];
  // количество недель на курсе
  int weeks = stream.weeks!;

  // актуальный день студента
  DateTime actualStudentDay = getActualStudentDay();

  // индекс страницы для создания
  int? nextPageIndex;
  final lastWeekRaw = stream.weekBacklink.indexed.last;
  final lastWeekIndex = lastWeekRaw.$1;
  final lastWeek = lastWeekRaw.$2;

  // Первая неделя курса
  Week firstWeek = stream.weekBacklink.elementAt(0);
  List firstWeekCells = jsonDecode(firstWeek.cells!);

  /// неделя по умолчанию
  /// индекс недели по умолчанию
  int defaultPageIndex = 0;

  /// всего недель с индексом
  List allWeeksIndexed = stream.weekBacklink.indexed.toList();

  /// понедельник текущей недели
  final currMonday = findFirstDateOfTheWeek(actualStudentDay);

  /// меняем индекс недели по умолчанию
  for (int i = 0; i < allWeeksIndexed.length; i++) {
    int weekIndex = allWeeksIndexed[i].$1;
    Week week = allWeeksIndexed[i].$2;

    if (currMonday.isAtSameMomentAs(week.monday!)) {
      defaultPageIndex = weekIndex;
    }
  }

  // До старта курса
  if (status == 'before') {
    // // индекс первой недели
    // currentWeekIndex = 0;
    // планер открыт на первой неделе
    defaultPageIndex = 0;

    //////////////////////////////////////////
    // Формируем первую неделю с данными
    // Если первая неделя не пустая
    //////////////////////////////////////////
    if (firstWeekCells.isNotEmpty) {
      // Дни недели по порядку
      final allWeekDays = await firstWeek.dayBacklink.filter().sortByStartAt().thenByStartAt().findAll();

      for (int createdWeek = 0; createdWeek < stream.weekBacklink.length; createdWeek++) {
        Week week = stream.weekBacklink.elementAt(createdWeek);
        List cells = jsonDecode(week.cells!);

        List cellsWeekData = [];
        List weekOpenedPeriod = [];

        //////////////////////////////////////////
        // Формирование данных ячеек
        //////////////////////////////////////////

        for (int cell = 0; cell < cells.length; cell++) {
          int cellIndex = cells[cell]['cellId'][2];

          // добавляем индекс заполненного периода
          // если воскресенье - НЕ добавляем
          if (cells[cell]['cellId'][2] != 6) {
            weekOpenedPeriod.add(cells[cell]['cellId'][0]);
          }

          // день получаем по cells[cell]['dayId']
          final day = week.dayBacklink.where((day) => day.id == cells[cell]['dayId']).first;

          // ячейки
          cellsWeekData.addAll([
            {
              'day_id': day.id,
              'cellId': cells[cell]['cellId'],
              'start_at': DateFormat('HH:mm').format(day.startAt!),
              'completed_at': '',
            }
          ]);
        }

        // print('weekOpenedPeriod: ${weekOpenedPeriod.toSet().toList()}');

        //////////////////////////////////////////
        // Добавление недель с данными
        //////////////////////////////////////////
        weeksOnPage.addAll([
          {
            'pageIndex': createdWeek,
            'monday': allWeekDays[0].startAt,
            'sunday': allWeekDays[6].startAt,
            'cellsWeekData': cellsWeekData,
            'weekOpenedPeriod': weekOpenedPeriod.toSet().toList(), // [0, 2, 1]
            'weekId': week.id,
            'isEditable': true,
          }
        ]);
      }
    }
    // Неделя пустая
    else {
      weeksOnPage.addAll([
        {
          'pageIndex': 0,
          'monday': stream.startAt,
          'sunday': stream.startAt!.add(const Duration(days: 6)),
          'cellsWeekData': [],
          'weekOpenedPeriod': [0, 1, 2], // открываем 3 периода по умолчанию
          'weekId': firstWeek.id,
          'isEditable': true,
        }
      ]);
    }
  }
  // Во время прохождения курса
  else if (status == 'process') {
    if (createdWeeks < weeks) {
      nextPageIndex = lastWeekIndex;

      /// future week
      if (!now.isBefore(lastWeek.monday!)) {
        nextPageIndex = createdWeeks;
        createdWeeks = createdWeeks + 1;
      }
    }

    /// Формирование недель с данными
    for (int i = 0; i < stream.weekBacklink.length; i++) {
      Week week = stream.weekBacklink.elementAt(i);
      DateTime monday = week.monday!;
      DateTime sunday = week.monday!.add(const Duration(days: 6));

      /// недели с подсказками
      bool isEmptyWeek = week.systemConfirmed ?? false;

      List cells = jsonDecode(week.cells!);

      /// будущая неделя
      bool isFutureWeek = now.isBefore(monday);

      /// заполненные периоды недели
      List weekOpenedPeriod = [];

      /// ячейки для вывода
      List cellsWeekData = [];

      /// Неделя подсказок
      /// неделя подсказок для текущей недели
      Week? lastWeekWithHint;

      /// ячейки подсказок
      List cellsLastWeekWithHint = [];

      /// Формируем неделю с подсказками
      if (isEmptyWeek) {
        List<Week>? allConfirmedWeeks =
            await stream.weekBacklink.filter().idLessThan(week.id).userConfirmedEqualTo(true).findAll();

        lastWeekWithHint = allConfirmedWeeks.lastOrNull;
        cellsLastWeekWithHint = lastWeekWithHint != null ? jsonDecode(lastWeekWithHint.cells!) : [];
      }

      /// формирование ячеек
      for (int cell = 0; cell < cells.length; cell++) {
        // день получаем по cells[cell]['dayId']
        Day day = week.dayBacklink.where((day) => day.id == cells[cell]['dayId']).first;

        /// подсказка
        List? hintCellId;
        DateTime? hintCellStartAt;
        bool isHint = false;
        if (day.startAt == null) {
          isHint = true;
        }

        /// формируем подсказки
        if (isHint && cellsLastWeekWithHint.isNotEmpty) {
          for (Map cellHint in cellsLastWeekWithHint) {
            /// соответствие дню недели
            /// например, подсказка из предыдущего понедельника в текущий
            if (cellHint['cellId'][2] == cells[cell]['cellId'][2]) {
              Day? dayHint = await isar.days.get(cellHint['dayId']);
              hintCellStartAt = dayHint?.startAt;
              hintCellId = cellHint['cellId'];

              // если день не выполнен
              if (day.completedAt == null) {
                // добавляем индекс заполненного периода
                // если воскресенье - НЕ добавляем
                if (cellHint['cellId'][2] != 6) {
                  weekOpenedPeriod.add(cellHint['cellId'][0]);
                }
              }
            }
          }
        }

        /// соответствие намеченному выполнению дня
        /// проверка только на неделях
        /// созданных пользователем
        List? newCellId;
        bool completedOnTime = false;

        /// не пустая неделя
        if (!isEmptyWeek) {
          if (day.completedAt != null) {
            /// добавляем индекс заполненного периода - воскресенье
            if (cells[cell]['cellId'][2] == 6) {
              weekOpenedPeriod.add(cells[cell]['cellId'][0]);
            }
            // час старта дела по плану
            String startAtHour = DateFormat('H').format(day.startAt!);
            // час завершения дела актуальный
            String completedAtHour = DateFormat('H').format(day.completedAt!);

            // Час выполнения не совпадает
            if (startAtHour != completedAtHour) {
              for (Map hour in periodHoursIndexList) {
                // час завершения дела актуальный
                if (hour.keys.first == completedAtHour) {
                  /// находим индекс дня ячейки
                  int gridIndex = cells[cell]['cellId'].last;

                  /// Создаем новый список
                  List newHourCellId = List.from(hour.values.first);
                  newHourCellId.add(gridIndex);
                  newCellId = newHourCellId;

                  /// добавляем индекс заполненного периода
                  weekOpenedPeriod.add(newHourCellId[0]);
                }
              }
            }
            // Если час выполнения совпадает
            else if (startAtHour == completedAtHour) {
              weekOpenedPeriod.add(cells[cell]['cellId'][0]);
              completedOnTime = true;
            }
          }

          /// пропущенный день
          else {
            /// добавляем индекс заполненного периода
            /// если не воскресенье
            if (cells[cell]['cellId'][2] != 6) {
              weekOpenedPeriod.add(cells[cell]['cellId'][0]);
            }
          }
        }

        /// пустая неделя
        else {
          /// День выполнен
          if (day.completedAt != null) {
            // час завершения дела актуальный
            String completedAtHour = DateFormat('H').format(day.completedAt!);

            for (Map hour in periodHoursIndexList) {
              // час завершения дела актуальный
              if (hour.keys.first == completedAtHour) {
                // находим индекс дня ячейки
                int gridIndex = cells[cell]['cellId'].last;
                // Создаем новый список
                List newHourCellId = List.from(hour.values.first);
                newHourCellId.add(gridIndex);

                newCellId = newHourCellId;

                // добавляем индекс заполненного периода
                weekOpenedPeriod.add(newHourCellId[0]);
              }
            }
          }

          // /// День не выполнен
          // else {
          //   print('day: ${day.dateAt}');
          // }
        }

        /// формирование списка ячеек
        cellsWeekData.addAll([
          {
            'day_id': day.id,
            'dateAt': day.dateAt,
            'cellId': cells[cell]['cellId'],
            'hintCellId': hintCellId,
            'hintCellStartAt': hintCellStartAt,
            'newCellId': newCellId,
            'start_at': day.startAt != null ? DateFormat('HH:mm').format(day.startAt!) : null,
            'completed_at': day.completedAt != null ? DateFormat('HH:mm').format(day.completedAt!) : null,
            'completedOnTime': completedOnTime,
          }
        ]);
      }

      /// формирование недель
      weeksOnPage.addAll([
        {
          'pageIndex': i,
          'monday': monday,
          'sunday': sunday,
          'cellsWeekData': cellsWeekData,
          'weekOpenedPeriod': isFutureWeek ? [0, 1, 2] : weekOpenedPeriod.toSet().toList(),
          'isEditable': isFutureWeek,
          'weekId': week.id,
          'week': week,
        }
      ]);
    }

    /// будущая редактируемая неделя
    if (nextPageIndex != null) {
      /// ячейки для вывода
      List nextCellsWeekData = [];

      Week? nextWeek = stream.weekBacklink.elementAtOrNull(nextPageIndex);

      /// Будущая неделя создана
      if (nextWeek != null) {
        DateTime monday = nextWeek.monday!;
        DateTime sunday = nextWeek.monday!.add(const Duration(days: 6));
        List nextWeekCells = jsonDecode(nextWeek.cells!);

        /// формирование ячеек
        for (int cell = 0; cell < nextWeekCells.length; cell++) {
          // день получаем по cells[cell]['dayId']
          Day day = nextWeek.dayBacklink.where((day) => day.id == nextWeekCells[cell]['dayId']).first;

          /// формирование списка ячеек
          nextCellsWeekData.addAll([
            {
              'day_id': day.id,
              'dateAt': day.dateAt,
              'cellId': nextWeekCells[cell]['cellId'],
              'start_at': DateFormat('HH:mm').format(day.startAt!),
            }
          ]);
        }

        /// формирование недель
        weeksOnPage.addAll([
          {
            'pageIndex': nextPageIndex,
            'monday': monday,
            'sunday': sunday,
            'cellsWeekData': nextCellsWeekData,
            'weekOpenedPeriod': [0, 1, 2],
            'isEditable': true,
            'weekId': nextWeek.id,
            'week': nextWeek,
          }
        ]);
      }

      /// Будущая неделя не создана
      else {
        Week? lastCreatedWeek = stream.weekBacklink.last;
        DateTime lastCreatedWeekMonday = lastCreatedWeek.monday!;
        weeksOnPage.addAll([
          {
            'pageIndex': nextPageIndex,
            'monday': lastCreatedWeekMonday.add(const Duration(days: 7)),
            'sunday': lastCreatedWeekMonday.add(const Duration(days: 13)),
            'cellsWeekData': [],
            'weekOpenedPeriod': [0, 1, 2],
            'isEditable': true,
          }
        ]);
      }
    }
  }
  // После окончания курса
  else if (status == 'after') {
    // по умолчанию последняя неделя курса
    defaultPageIndex = allWeeksIndexed.last.$1;

    /// Формирование недель с данными
    for (int i = 0; i < stream.weekBacklink.length; i++) {
      Week week = stream.weekBacklink.elementAt(i);
      DateTime monday = week.monday!;
      DateTime sunday = week.monday!.add(const Duration(days: 6));

      /// недели с подсказками
      bool isEmptyWeek = week.systemConfirmed ?? false;

      List cells = jsonDecode(week.cells!);

      /// будущая неделя
      bool isFutureWeek = now.isBefore(monday);

      /// заполненные периоды недели
      List weekOpenedPeriod = [];

      /// ячейки для вывода
      List cellsWeekData = [];

      /// Неделя подсказок
      /// неделя подсказок для текущей недели
      Week? lastWeekWithHint;

      /// ячейки подсказок
      List cellsLastWeekWithHint = [];

      /// Формируем неделю с подсказками
      if (isEmptyWeek) {
        List<Week>? allConfirmedWeeks =
            await stream.weekBacklink.filter().idLessThan(week.id).userConfirmedEqualTo(true).findAll();

        lastWeekWithHint = allConfirmedWeeks.lastOrNull;
        cellsLastWeekWithHint = lastWeekWithHint != null ? jsonDecode(lastWeekWithHint.cells!) : [];
      }

      /// формирование ячеек
      for (int cell = 0; cell < cells.length; cell++) {
        // день получаем по cells[cell]['dayId']
        Day day = week.dayBacklink.where((day) => day.id == cells[cell]['dayId']).first;

        /// подсказка
        List? hintCellId;
        DateTime? hintCellStartAt;
        bool isHint = false;
        if (day.startAt == null) {
          isHint = true;
        }

        /// формируем подсказки
        if (isHint && cellsLastWeekWithHint.isNotEmpty) {
          for (Map cellHint in cellsLastWeekWithHint) {
            /// соответствие дню недели
            /// например, подсказка из предыдущего понедельника в текущий
            if (cellHint['cellId'][2] == cells[cell]['cellId'][2]) {
              Day? dayHint = await isar.days.get(cellHint['dayId']);
              hintCellStartAt = dayHint?.startAt;
              hintCellId = cellHint['cellId'];

              // если день не выполнен
              if (day.completedAt == null) {
                // добавляем индекс заполненного периода
                // если воскресенье - НЕ добавляем
                if (cellHint['cellId'][2] != 6) {
                  weekOpenedPeriod.add(cellHint['cellId'][0]);
                }
              }
            }
          }
        }

        /// соответствие намеченному выполнению дня
        /// проверка только на неделях
        /// созданных пользователем
        List? newCellId;
        bool completedOnTime = false;

        /// не пустая неделя
        if (!isEmptyWeek) {
          if (day.completedAt != null) {
            /// добавляем индекс заполненного периода - воскресенье
            if (cells[cell]['cellId'][2] == 6) {
              weekOpenedPeriod.add(cells[cell]['cellId'][0]);
            }
            // час старта дела по плану
            String startAtHour = DateFormat('H').format(day.startAt!);
            // час завершения дела актуальный
            String completedAtHour = DateFormat('H').format(day.completedAt!);

            // Час выполнения не совпадает
            if (startAtHour != completedAtHour) {
              for (Map hour in periodHoursIndexList) {
                // час завершения дела актуальный
                if (hour.keys.first == completedAtHour) {
                  /// находим индекс дня ячейки
                  int gridIndex = cells[cell]['cellId'].last;

                  /// Создаем новый список
                  List newHourCellId = List.from(hour.values.first);
                  newHourCellId.add(gridIndex);
                  newCellId = newHourCellId;

                  /// добавляем индекс заполненного периода
                  weekOpenedPeriod.add(newHourCellId[0]);
                }
              }
            }
            // Если час выполнения совпадает
            else if (startAtHour == completedAtHour) {
              weekOpenedPeriod.add(cells[cell]['cellId'][0]);
              completedOnTime = true;
            }
          }

          /// пропущенный день
          else {
            /// добавляем индекс заполненного периода
            /// если не воскресенье
            if (cells[cell]['cellId'][2] != 6) {
              weekOpenedPeriod.add(cells[cell]['cellId'][0]);
            }
          }
        }

        /// пустая неделя
        else {
          /// День выполнен
          if (day.completedAt != null) {
            // час завершения дела актуальный
            String completedAtHour = DateFormat('H').format(day.completedAt!);

            for (Map hour in periodHoursIndexList) {
              // час завершения дела актуальный
              if (hour.keys.first == completedAtHour) {
                // находим индекс дня ячейки
                int gridIndex = cells[cell]['cellId'].last;
                // Создаем новый список
                List newHourCellId = List.from(hour.values.first);
                newHourCellId.add(gridIndex);

                newCellId = newHourCellId;

                // добавляем индекс заполненного периода
                weekOpenedPeriod.add(newHourCellId[0]);
              }
            }
          }

          // /// День не выполнен
          // else {
          //   print('day: ${day.dateAt}');
          // }
        }

        /// формирование списка ячеек
        cellsWeekData.addAll([
          {
            'day_id': day.id,
            'dateAt': day.dateAt,
            'cellId': cells[cell]['cellId'],
            'hintCellId': hintCellId,
            'hintCellStartAt': hintCellStartAt,
            'newCellId': newCellId,
            'start_at': day.startAt != null ? DateFormat('HH:mm').format(day.startAt!) : null,
            'completed_at': day.completedAt != null ? DateFormat('HH:mm').format(day.completedAt!) : null,
            'completedOnTime': completedOnTime,
          }
        ]);
      }

      /// формирование недель
      weeksOnPage.addAll([
        {
          'pageIndex': i,
          'monday': monday,
          'sunday': sunday,
          'cellsWeekData': cellsWeekData,
          'weekOpenedPeriod': isFutureWeek ? [0, 1, 2] : weekOpenedPeriod.toSet().toList(),
          'isEditable': isFutureWeek,
          'weekId': week.id,
          'week': week,
        }
      ]);
    }
  }

  // print('weekOpenedPeriod 0: ${weeksOnPage[0]['weekOpenedPeriod']}');
  // print('weekOpenedPeriod 1: ${weeksOnPage[1]['weekOpenedPeriod']}');
  // print('weekOpenedPeriod 2: ${weeksOnPage[2]['weekOpenedPeriod']}');
  // print('weeksOnPage: ${weeksOnPage}');
  // print('createdWeeks: ${createdWeeks}');
  // print('defaultPageIndex: ${defaultPageIndex}');

  data['weeksOnPage'] = weeksOnPage;
  data['createdWeeks'] = createdWeeks;
  data['defaultPageIndex'] = defaultPageIndex;

  return data;
}
