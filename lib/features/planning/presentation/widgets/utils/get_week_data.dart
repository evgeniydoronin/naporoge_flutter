import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:isar/isar.dart';

import '../../../../../core/services/db_client/isar_service.dart';
import '../../../../../core/utils/get_actual_student_day.dart';
import '../../../../../core/utils/get_week_number.dart';
import '../../../domain/entities/stream_entity.dart';
import '../core.dart';

Future getWeekData(NPStream stream, String status) async {
  final isarService = IsarService();
  final isar = await isarService.db;
  Map data = {};

  // страниц планера
  int allPages = stream.weekBacklink.length;
  // формируем все недели с данными
  List weeksOnPage = [];
  // количество недель на курсе
  int weeks = stream.weeks!;

  // актуальный день студента
  DateTime actualStudentDay = getActualStudentDay();
  // текущая неделя
  int actualWeek = getWeekNumber(actualStudentDay);

  // индекс недели по умолчанию
  int defaultPageIndex = 0;
  // индекс страницы для создания
  int? nextPageIndex;

  // Первая неделя курса
  Week firstWeek = stream.weekBacklink.elementAt(0);
  List firstWeekCells = jsonDecode(firstWeek.cells!);

  // print(stream.startAt);
  DateTime firstDayOfStream = stream.startAt!;

  DateTime now = DateTime.now();

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
    for (int i = 0; i < stream.weekBacklink.length; i++) {
      Week week = stream.weekBacklink.elementAt(i);
      DateTime monday = week.monday!;
      DateTime sunday = week.monday!.add(const Duration(days: 6));
      bool isEmptyWeek = week.systemConfirmed ?? false;
      List cells = jsonDecode(week.cells!);

      /// будущая неделя
      bool isFutureWeek = now.isBefore(monday);

      /// заполненные периоды недели
      List weekOpenedPeriod = [];

      /// ячейки для вывода
      List cellsWeekData = [];

      // неделя по умолчанию
      if (actualWeek == week.weekNumber) {
        defaultPageIndex = i;
      }

      /// Неделя подсказок
      /// неделя подсказок для текущей недели
      Week? lastWeekWithHint;

      /// ячейки подсказок
      List? cellsLastWeekWithHint;

      /// Формируем неделю с подсказками
      if (isEmptyWeek) {
        List<Week>? allConfirmedWeeks =
            await stream.weekBacklink.filter().idLessThan(week.id).userConfirmedEqualTo(true).findAll();
        lastWeekWithHint = allConfirmedWeeks.lastOrNull;
        cellsLastWeekWithHint = jsonDecode(lastWeekWithHint!.cells!);
      }

      // текущая и прошедшие недели
      if (!isFutureWeek) {
        // // пустые недели
        // if (isEmptyWeek) {
        //   print('текущая и прошедшие недели, пустые недели ${week.monday}');
        // }
        // // недели с данными
        // else {
        //   print('текущая и прошедшие недели, недели с данными ${week.monday}');
        // }

        // print(
        //     'week: ${week.id}, i: $i, cells: $cells, lastWeekWithHint: ${lastWeekWithHint?.id}, isEmptyWeek: $isEmptyWeek');

        for (int cell = 0; cell < cells.length; cell++) {
          // добавляем индекс заполненного периода
          // если воскресенье - НЕ добавляем
          if (cells[cell]['cellId'][2] != 6) {
            weekOpenedPeriod.add(cells[cell]['cellId'][0]);
          }

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
          if (isHint && cellsLastWeekWithHint != null) {
            for (Map cellHint in cellsLastWeekWithHint) {
              /// соответствие дню недели
              /// например, подсказка из предыдущего понедельника в текущий
              if (cellHint['cellId'][2] == cells[cell]['cellId'][2]) {
                Day? dayHint = await isar.days.get(cellHint['dayId']);
                hintCellStartAt = dayHint?.startAt;
                hintCellId = cellHint['cellId'];
              }
            }
          }

          /// соответствие намеченному выполнению дня
          /// проверка только на неделях
          /// созданных пользователем
          List? newCellId;
          if (!isEmptyWeek) {
            if (day.completedAt != null) {
              // час старта дела по плану
              String startAtHour = DateFormat('H').format(day.startAt!);
              // час завершения дела актуальный
              String completedAtHour = DateFormat('H').format(day.completedAt!);

              // Если час выполнения не совпадает
              if (startAtHour != completedAtHour) {
                for (Map hour in periodHoursIndexList) {
                  // час завершения дела актуальный
                  if (hour.keys.first == completedAtHour) {
                    // находим индекс дня ячейки
                    int gridIndex = cells[cell]['cellId'].last;
                    // Создаем новый список
                    List newHourCellId = List.from(hour.values.first);
                    newHourCellId.add(gridIndex);

                    newCellId = newHourCellId;

                    // добавляем новую ячейку с новым индексом
                    // cellsWeekData.addAll([
                    //   {
                    //     'day_id': day.id,
                    //     'cellId': newHourCellId,
                    //     'start_at': DateFormat('HH:mm').format(day.startAt!),
                    //     'completed_at': DateFormat('HH:mm').format(day.completedAt!),
                    //     'newCellId': true,
                    //   }
                    // ]);

                    // добавляем индекс заполненного периода
                    weekOpenedPeriod.add(newHourCellId[0]);

                    // print('hourIndex: $hourIndex');
                  }
                  // час завершения дела НЕ актуальный
                  else if (hour.keys.first == startAtHour) {
                    // добавляем  ячейку
                    // cellsWeekData.addAll([
                    //   {
                    //     'day_id': day.id,
                    //     'cellId': cells[cell]['cellId'],
                    //     'start_at': DateFormat('HH:mm').format(day.startAt!),
                    //     'completed_at': DateFormat('HH:mm').format(day.completedAt!),
                    //     'oldCellId': true,
                    //   }
                    // ]);
                  }
                }
              }
              // Если час выполнения совпадает
              else if (startAtHour == completedAtHour) {
                // print('Если час выполнения совпадает');
                // cellsWeekData.addAll([
                //   {
                //     'day_id': day.id,
                //     'cellId': cells[cell]['cellId'],
                //     'start_at': DateFormat('HH:mm').format(day.startAt!),
                //     'completed_at': DateFormat('HH:mm').format(day.completedAt!),
                //     'day_matches': true,
                //   }
                // ]);
              }
            }
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
            }
          ]);
        }

        // print('cellsWeekData: ${cellsWeekData}');
      }

      weeksOnPage.addAll([
        {
          'pageIndex': i,
          'monday': monday,
          'sunday': sunday,
          'cellsWeekData': [],
          'weekOpenedPeriod': isFutureWeek ? [0, 1, 2] : weekOpenedPeriod.toSet().toList(),
          'isEditable': isFutureWeek,
          'weekId': week.id,
          'week': week,
        }
      ]);
    }

    /// i: 3, nextPageIndex: 5
    /// Текущая неделя с индексом 3
    /// Которую нужно создать 5, но она не открывается

    // for (int i = 0; i < stream.weekBacklink.length; i++) {
    //   // Неделя
    //   Week week = stream.weekBacklink.elementAt(i);
    //   List cells = jsonDecode(week.cells!);
    //
    //   DateTime weekMonday = firstDayOfStream.add(Duration(days: i * 7));
    //   DateTime weekSunday = firstDayOfStream.add(Duration(days: (i * 7) + 6));
    //
    //   //////////////////////////////////////////
    //   // PageIndex текущей недели
    //   //////////////////////////////////////////
    //
    //   // Рабочий сценарий
    //
    //   // Сейчас 4-я неделя
    //   // flutter: getWeekNumber(actualStudentDay): 51
    //   // flutter: week.weekNumber: 51
    //   // flutter: nextPageIndex: 4
    //
    //   // Сейчас 5-я неделя
    //   // 6я неделя следующего года не создана
    //   // flutter: getWeekNumber(actualStudentDay): 52
    //   // flutter: week.weekNumber: 52
    //   // flutter: nextPageIndex: 5
    //
    //   // После создания 6й недели на 5й
    //   // flutter: getWeekNumber(actualStudentDay): 52
    //   // flutter: week.weekNumber: 1
    //   // flutter: nextPageIndex: 6
    //   int actualWeek = getWeekNumber(actualStudentDay);
    //
    //   // if (actualWeek == 52) {
    //   //   actualWeek = 1;
    //   // }
    //
    //   // print('getWeekNumber(actualStudentDay): $actualWeek');
    //   // print('current week: ${week.id}');
    //   // print('week.weekNumber: ${week.weekNumber}');
    //   // print('nextPageIndex: $nextPageIndex');
    //
    //   if (actualWeek == week.weekNumber) {
    //     defaultPageIndex = i;
    //   } else if (actualWeek < week.weekNumber!) {
    //     nextPageIndex = i;
    //   }
    //
    //   // будущая неделя при условии
    //   // defaultPageIndex + 1 == nextPageIndex
    //   // defaultPageIndex + 1: 5, nextPageIndex: 5
    //   print('defaultPageIndex + 1: ${defaultPageIndex + 1}, nextPageIndex: $nextPageIndex');
    //
    //   List cellsWeekData = [];
    //
    //   //////////////////////////////////////////
    //   // Подсказки
    //   // Текущая неделя пустая, создана системой
    //   // дни недели не созданы
    //   //////////////////////////////////////////
    //   if (week.dayBacklink.first.startAt == null) {
    //     // print('дни текущей недели созданы 5533');
    //
    //     Week? lastWeek;
    //     List<Week>? allConfirmedWeeks = await stream.weekBacklink.filter().userConfirmedEqualTo(true).findAll();
    //
    //     if (allConfirmedWeeks.isNotEmpty) {
    //       // удаляем будущую неделю, если есть
    //       List<Week>? w = allConfirmedWeeks.where((week) => week.monday!.isBefore(DateTime.now())).toList();
    //       lastWeek = w.lastOrNull;
    //     }
    //
    //     //////////////////////////////////////
    //     // Подсказки из предыдущей недели
    //     // если есть неделя с данными дней
    //     if (lastWeek != null) {
    //       // print('Подсказки из предыдущей недели');
    //       List lastWeekCells = jsonDecode(lastWeek.cells!);
    //       // print(lastWeekCells);
    //       // List lastWeekCells = lastWeek.cells;
    //       // Дни недели по порядку
    //       var allWeekDays = await lastWeek.dayBacklink.filter().sortByStartAt().thenByStartAt().findAll();
    //
    //       // Если требуется добавить новую неделю
    //       if (nextPageIndex != null) {
    //         // TODO: PROBLEM
    //         // Созданные недели
    //         if (i < nextPageIndex) {
    //           // print('Подсказки: Созданные недели');
    //
    //           List weekOpenedPeriod = [];
    //
    //           // Дни предыдущей недели созданы
    //           if (lastWeekCells.isNotEmpty) {
    //             // print('lastWeekCells Дни недели созданы');
    //
    //             // print('cells: $cells');
    //
    //             //////////////////////////////////////////
    //             // Если НЕ требуется создать следующую неделю
    //             //////////////////////////////////////////
    //
    //             // для отображения подсказок формируем lastCell
    //             for (int lastCell = 0; lastCell < lastWeekCells.length; lastCell++) {
    //               // день получаем по cells[cell]['dayId']
    //               final lastDay = lastWeek.dayBacklink.where((day) => day.id == lastWeekCells[lastCell]['dayId']).first;
    //
    //               if (lastWeekCells[lastCell]['cellId'][2] != 6) {
    //                 weekOpenedPeriod.add(lastWeekCells[lastCell]['cellId'][0]);
    //               }
    //
    //               // print('lastDay startAt: ${lastDay.startAt}');
    //
    //               // для отображения текущих ячеек
    //               for (int cell = 0; cell < cells.length; cell++) {
    //                 final day = week.dayBacklink.where((day) => day.id == cells[cell]['dayId']).first;
    //
    //                 // print('cell: ${cells[cell]}');
    //                 // индекс ячейки текущего дня
    //                 int indexCell = cells[cell]['cellId'][2];
    //                 // индекс ячейки дня прошлой недели
    //                 int indexLastCell = lastWeekCells[lastCell]['cellId'][2];
    //
    //                 // Соответствие предыдущих и текущих дней
    //                 if (indexCell == indexLastCell) {
    //                   // День завершен
    //                   if (day.completedAt != null) {
    //                     String completedAtHour = DateFormat('H').format(day.completedAt!);
    //                     // print('День завершен cellId: ${cells[cell]['cellId']}');
    //                     // print('День завершен: $day');
    //                     // print('День завершен id: ${day.id}');
    //                     // print('соответствие День завершен: ${day.completedAt}');
    //                     // print('День завершен: ${DateFormat('HH:mm').format(day.completedAt!)}');
    //                     for (Map hour in periodHoursIndexList) {
    //                       // print('hour: $hour');
    //                       // час завершения дела актуальный
    //                       if (hour.keys.first == completedAtHour) {
    //                         // находим индекс дня ячейки
    //                         int gridIndex = cells[cell]['cellId'].last;
    //                         // Создаем новый список
    //                         List newHourCellId = List.from(hour.values.first);
    //
    //                         newHourCellId.add(gridIndex);
    //
    //                         // добавляем новую ячейку с новым индексом
    //                         cellsWeekData.addAll([
    //                           {
    //                             'day_id': day.id,
    //                             'cellId': newHourCellId,
    //                             'start_at': '',
    //                             'completed_at': DateFormat('HH:mm').format(day.completedAt!),
    //                             'statusCell': 'completed',
    //                           }
    //                         ]);
    //
    //                         // добавляем индекс заполненного периода
    //                         weekOpenedPeriod.add(newHourCellId[0]);
    //
    //                         // print('hourIndex: $hourIndex');
    //                       }
    //                     }
    //                   }
    //                   // День не завершен
    //                   else {
    //                     // print('День НЕ завершен: $day');
    //                     cellsWeekData.addAll([
    //                       {
    //                         'day_id': day.id,
    //                         'cellId': lastWeekCells[lastCell]['cellId'],
    //                         'start_at': DateFormat('HH:mm').format(lastDay.startAt!),
    //                         'completed_at': '',
    //                         'statusCell': 'helper',
    //                       }
    //                     ]);
    //                   }
    //                 }
    //               }
    //             }
    //
    //             // print('daysOfWeek: $daysOfWeek');
    //             // print('allWeekDays[0].startAt: ${allWeekDays[0].startAt is DateTime}');
    //
    //             weeksOnPage.addAll([
    //               {
    //                 'pageIndex': i,
    //                 'monday': weekMonday,
    //                 'sunday': weekSunday,
    //                 'weekDayEmpty': true,
    //                 'lastWeekId': lastWeek.id,
    //                 'cellsWeekData': cellsWeekData,
    //                 'weekOpenedPeriod': weekOpenedPeriod.toSet().toList(),
    //                 'isEditable': false,
    //                 'weekId': week.id,
    //                 'week': week,
    //               }
    //             ]);
    //           }
    //           // Дни НЕ созданы
    //           else {
    //             // print('Дни недели НЕ созданы 1');
    //
    //             weeksOnPage.addAll([
    //               {
    //                 'pageIndex': i,
    //                 'monday': weekMonday,
    //                 'sunday': weekSunday,
    //                 'cellsWeekData': [],
    //                 'weekOpenedPeriod': [0, 1, 2],
    //                 'isEditable': true,
    //                 'weekId': week.id,
    //                 'week': week,
    //               }
    //             ]);
    //           }
    //         }
    //         // Созданная БУДУЩАЯ неделя
    //         else {
    //           // print('Созданная БУДУЩАЯ неделя 2');
    //           // Дни созданы
    //           if (cells.isNotEmpty) {
    //             // print('Дни БУДУЩЕЙ недели созданы');
    //             List weekOpenedPeriodFutureWeek = [];
    //
    //             for (int cell = 0; cell < cells.length; cell++) {
    //               // добавляем индекс заполненного периода
    //               // если воскресенье - НЕ добавляем
    //               if (cells[cell]['cellId'][2] != 6) {
    //                 weekOpenedPeriodFutureWeek.add(cells[cell]['cellId'][0]);
    //               }
    //
    //               // день получаем по cells[cell]['dayId']
    //               final day = week.dayBacklink.where((day) => day.id == cells[cell]['dayId']).first;
    //
    //               // print('Если требуется добавить новую неделю');
    //               // print('nextPageIndex: $nextPageIndex');
    //               // print('i: $i');
    //               // print('day: $day');
    //               // print('day id: ${day.id}');
    //               // print('startAt: ${day.startAt}');
    //               // print('Если требуется добавить новую неделю');
    //
    //               // ячейки
    //               cellsWeekData.addAll([
    //                 {
    //                   'day_id': day.id,
    //                   'cellId': cells[cell]['cellId'],
    //                   'start_at': day.startAt != null ? DateFormat('HH:mm').format(day.startAt!) : '',
    //                   'completed_at': '',
    //                 }
    //               ]);
    //             }
    //
    //             weeksOnPage.addAll([
    //               {
    //                 'pageIndex': i,
    //                 'monday': weekMonday,
    //                 'sunday': weekSunday,
    //                 'cellsWeekData': cellsWeekData,
    //                 'weekOpenedPeriod': weekOpenedPeriodFutureWeek.toSet().toList(),
    //                 'isEditable': true,
    //                 'weekId': week.id,
    //                 'week': week,
    //               }
    //             ]);
    //           }
    //           // Дни НЕ созданы
    //           // TODO: создать функционал
    //           else {
    //             // print('Дни недели НЕ созданы 2');
    //
    //             weeksOnPage.addAll([
    //               {
    //                 'pageIndex': i,
    //                 'monday': weekMonday,
    //                 'sunday': weekSunday,
    //                 'cellsWeekData': [],
    //                 'weekOpenedPeriod': [0, 1, 2],
    //                 'isEditable': true,
    //                 'weekId': week.id,
    //                 'week': week,
    //               }
    //             ]);
    //           }
    //         }
    //
    //         ///////////////////////////////////////////////
    //         // Будущая неделя
    //         ///////////////////////////////////////////////
    //         if (isNextWeek) {
    //           if (defaultPageIndex + 1 == nextPageIndex) {
    //             Week? nextWeek = stream.weekBacklink.elementAtOrNull(nextPageIndex);
    //             // Неделя создана
    //             if (nextWeek == null) {
    //               // print('Будущая Неделя НЕ создана');
    //               // Добавляем cледующую неделю
    //               allPages = stream.weekBacklink.length + 1;
    //               weeksOnPage.add({
    //                 'pageIndex': nextPageIndex,
    //                 'monday': weekMonday.add(const Duration(days: 7)),
    //                 'sunday': weekSunday.add(const Duration(days: 7)),
    //                 'cellsWeekData': [],
    //                 'weekOpenedPeriod': [0, 1, 2],
    //                 'isEditable': true,
    //                 'weekId': null, // если неделя не создана - week.id НЕТ
    //                 'weekOfYear': week.weekNumber! + 1,
    //                 'week': week,
    //               });
    //             }
    //           }
    //         }
    //       }
    //       // Если НЕ требуется новая неделя
    //       else {
    //         List weekOpenedPeriod = [];
    //
    //         // Подсказки берутся из предыдущей недели
    //         if (cells.isNotEmpty) {
    //           // print('Подсказки текущей недели созданы');
    //           // print('Актуальные ячейки: $cells');
    //           // print('Ячейки недели подсказок: $lastWeekCells');
    //
    //           // для отображения подсказок формируем lastCell
    //           for (int lastCell = 0; lastCell < lastWeekCells.length; lastCell++) {
    //             // день получаем по cells[cell]['dayId']
    //             final lastDay = lastWeek.dayBacklink.where((day) => day.id == lastWeekCells[lastCell]['dayId']).first;
    //
    //             // TODO: спустить на уровень вниз для проверки выполненных дней
    //             if (lastWeekCells[lastCell]['cellId'][2] != 6) {
    //               weekOpenedPeriod.add(lastWeekCells[lastCell]['cellId'][0]);
    //             }
    //
    //             // print('lastDay startAt: ${lastDay.startAt}');
    //
    //             // для отображения текущей недели с подсказками
    //             // после старта недели
    //             // для отображения подсказок формируем lastCell
    //             for (int lastCell = 0; lastCell < lastWeekCells.length; lastCell++) {
    //               // день получаем по cells[cell]['dayId']
    //               final lastDay = lastWeek.dayBacklink.where((day) => day.id == lastWeekCells[lastCell]['dayId']).first;
    //
    //               if (lastWeekCells[lastCell]['cellId'][2] != 6) {
    //                 weekOpenedPeriod.add(lastWeekCells[lastCell]['cellId'][0]);
    //               }
    //
    //               // print('lastDay startAt: ${lastDay.startAt}');
    //
    //               // для отображения текущих ячеек
    //               for (int cell = 0; cell < cells.length; cell++) {
    //                 final day = week.dayBacklink.where((day) => day.id == cells[cell]['dayId']).first;
    //
    //                 // print('cell: ${cells[cell]}');
    //                 // индекс ячейки текущего дня
    //                 int indexCell = cells[cell]['cellId'][2];
    //                 // индекс ячейки дня прошлой недели
    //                 int indexLastCell = lastWeekCells[lastCell]['cellId'][2];
    //
    //                 // Соответствие предыдущих и текущих дней
    //                 if (indexCell == indexLastCell) {
    //                   // День завершен
    //                   if (day.completedAt != null) {
    //                     String completedAtHour = DateFormat('H').format(day.completedAt!);
    //                     // print('День завершен cellId: ${cells[cell]['cellId']}');
    //                     // print('День завершен: $day');
    //                     // print('День завершен id: ${day.id}');
    //                     // print('соответствие День завершен: ${day.completedAt}');
    //                     // print('День завершен: ${DateFormat('HH:mm').format(day.completedAt!)}');
    //                     for (Map hour in periodHoursIndexList) {
    //                       // print('hour: $hour');
    //                       // час завершения дела актуальный
    //                       if (hour.keys.first == completedAtHour) {
    //                         // находим индекс дня ячейки
    //                         int gridIndex = cells[cell]['cellId'].last;
    //                         // Создаем новый список
    //                         List newHourCellId = List.from(hour.values.first);
    //
    //                         newHourCellId.add(gridIndex);
    //
    //                         // добавляем новую ячейку с новым индексом
    //                         cellsWeekData.addAll([
    //                           {
    //                             'day_id': day.id,
    //                             'cellId': newHourCellId,
    //                             'start_at': '',
    //                             'completed_at': DateFormat('HH:mm').format(day.completedAt!),
    //                             'statusCell': 'completed',
    //                           }
    //                         ]);
    //
    //                         // добавляем индекс заполненного периода
    //                         weekOpenedPeriod.add(newHourCellId[0]);
    //
    //                         // print('hourIndex: $hourIndex');
    //                       }
    //                     }
    //                   }
    //                   // День не завершен
    //                   else {
    //                     // print('День НЕ завершен: $day');
    //                     cellsWeekData.addAll([
    //                       {
    //                         'day_id': day.id,
    //                         'cellId': lastWeekCells[lastCell]['cellId'],
    //                         'start_at': DateFormat('HH:mm').format(lastDay.startAt!),
    //                         'completed_at': '',
    //                         'statusCell': 'helper',
    //                       }
    //                     ]);
    //                   }
    //                 }
    //               }
    //             }
    //           }
    //
    //           weeksOnPage.addAll([
    //             {
    //               'pageIndex': i,
    //               'monday': weekMonday,
    //               'sunday': weekSunday,
    //               'cellsWeekData': cellsWeekData,
    //               'weekOpenedPeriod': weekOpenedPeriod.toSet().toList(),
    //               'isEditable': false,
    //               'weekId': week.id,
    //               'week': week,
    //             }
    //           ]);
    //         }
    //         // Дни НЕ созданы
    //         else {
    //           // print('Дни недели НЕ созданы 3');
    //
    //           weeksOnPage.addAll([
    //             {
    //               'pageIndex': i,
    //               'monday': weekMonday,
    //               'sunday': weekSunday,
    //               'cellsWeekData': [],
    //               'weekOpenedPeriod': [0, 1, 2],
    //               'isEditable': true,
    //               'weekId': week.id,
    //               'week': week,
    //             }
    //           ]);
    //         }
    //       }
    //     }
    //     // данных для подсказок нет
    //     else {
    //       // print('данных для подсказок нет');
    //
    //       // Если требуется добавить новую неделю
    //       if (nextPageIndex != null) {
    //         // print('требуется добавить новую неделю');
    //         // Созданные недели
    //         if (i < nextPageIndex) {
    //           // print('Созданные недели');
    //
    //           List weekOpenedPeriod = [];
    //           // Дни созданы
    //           if (cells.isNotEmpty) {
    //             // print('Неделя создана');
    //
    //             for (int cell = 0; cell < cells.length; cell++) {
    //               // добавляем индекс заполненного периода
    //               // если воскресенье - НЕ добавляем
    //               // if (cells[cell]['cellId'][2] != 6) {
    //               //   weekOpenedPeriod.add(cells[cell]['cellId'][0]);
    //               // }
    //
    //               // день получаем по cells[cell]['dayId']
    //               final day = week.dayBacklink.where((day) => day.id == cells[cell]['dayId']).first;
    //
    //               ///////////////////////////////
    //               // Статус дня
    //               ///////////////////////////////
    //
    //               // День завершен
    //               if (day.completedAt != null) {
    //                 // час завершения дела актуальный
    //                 String completedAtHour = DateFormat('H').format(day.completedAt!);
    //
    //                 // print('day 33: ${day.id} : ${day.completedAt}');
    //
    //                 for (Map hour in periodHoursIndexList) {
    //                   // print('hour: $hour');
    //                   // час завершения дела актуальный
    //                   if (hour.keys.first == completedAtHour) {
    //                     // находим индекс дня ячейки
    //                     int gridIndex = cells[cell]['cellId'].last;
    //                     // Создаем новый список
    //                     List newHourCellId = List.from(hour.values.first);
    //
    //                     newHourCellId.add(gridIndex);
    //
    //                     // добавляем новую ячейку с новым индексом
    //                     cellsWeekData.addAll([
    //                       {
    //                         'day_id': day.id,
    //                         'cellId': newHourCellId,
    //                         'start_at': '',
    //                         'completed_at': DateFormat('HH:mm').format(day.completedAt!),
    //                         'statusCell': 'completed',
    //                       }
    //                     ]);
    //
    //                     // добавляем индекс заполненного периода
    //                     weekOpenedPeriod.add(newHourCellId[0]);
    //
    //                     // print('hourIndex: $hourIndex');
    //                   }
    //                 }
    //               }
    //             }
    //
    //             // print('weekOpenedPeriod 3: $weekOpenedPeriod');
    //
    //             weeksOnPage.addAll([
    //               {
    //                 'pageIndex': i,
    //                 'monday': weekMonday,
    //                 'sunday': weekSunday,
    //                 'cellsWeekData': cellsWeekData,
    //                 'weekOpenedPeriod': weekOpenedPeriod.toSet().toList(),
    //                 'isEditable': false,
    //                 'weekId': week.id,
    //                 'week': week,
    //               }
    //             ]);
    //           }
    //           // Дни НЕ созданы
    //           // TODO: создать функционал
    //           else {
    //             // print('Дни недели НЕ созданы 1');
    //
    //             weeksOnPage.addAll([
    //               {
    //                 'pageIndex': i,
    //                 'monday': weekMonday,
    //                 'sunday': weekSunday,
    //                 'cellsWeekData': [],
    //                 'weekOpenedPeriod': [0, 1, 2],
    //                 'isEditable': true,
    //                 'weekId': week.id,
    //                 'week': week,
    //               }
    //             ]);
    //           }
    //         }
    //         // Если НЕ требуется новая неделя
    //         else {
    //           List weekOpenedPeriod = [];
    //           // Дни созданы
    //           if (cells.isNotEmpty) {
    //             // print('Дни текущей недели и созданных. Без недели с подсказками 55');
    //
    //             for (int cell = 0; cell < cells.length; cell++) {
    //               // добавляем индекс заполненного периода
    //               // если воскресенье - НЕ добавляем
    //               if (cells[cell]['cellId'][2] != 6) {
    //                 weekOpenedPeriod.add(cells[cell]['cellId'][0]);
    //               }
    //
    //               // день получаем по cells[cell]['dayId']
    //               final day = week.dayBacklink.where((day) => day.id == cells[cell]['dayId']).first;
    //
    //               ///////////////////////////////
    //               // Статус дня
    //               ///////////////////////////////
    //
    //               // День завершен
    //               if (day.completedAt != null) {
    //                 // час старта дела по плану
    //                 String startAtHour = DateFormat('H').format(day.startAt!);
    //                 // час завершения дела актуальный
    //                 String completedAtHour = DateFormat('H').format(day.completedAt!);
    //                 // print('startAtHour: $startAtHour');
    //                 // print('completedAtHour: $completedAtHour');
    //
    //                 // TODO: продолжить тут
    //                 // Если час выполнения не совпадает
    //                 if (startAtHour != completedAtHour) {
    //                   // print('Если час выполнения не совпадает 33');
    //                   // print('day: ${day.startAt}');
    //                   // print('day: ${day.completedAt}');
    //                   // print('cell: ${cells[cell]}');
    //                   for (Map hour in periodHoursIndexList) {
    //                     // час завершения дела актуальный
    //                     if (hour.keys.first == completedAtHour) {
    //                       // находим индекс дня ячейки
    //                       int gridIndex = cells[cell]['cellId'].last;
    //                       // Создаем новый список
    //                       List newHourCellId = List.from(hour.values.first);
    //
    //                       newHourCellId.add(gridIndex);
    //
    //                       // добавляем новую ячейку с новым индексом
    //                       cellsWeekData.addAll([
    //                         {
    //                           'day_id': day.id,
    //                           'cellId': newHourCellId,
    //                           'start_at': DateFormat('HH:mm').format(day.startAt!),
    //                           'completed_at': DateFormat('HH:mm').format(day.completedAt!),
    //                           'newCellId': true,
    //                         }
    //                       ]);
    //
    //                       // добавляем индекс заполненного периода
    //                       weekOpenedPeriod.add(newHourCellId[0]);
    //
    //                       // print('hourIndex: $hourIndex');
    //                     }
    //                     // час завершения дела НЕ актуальный
    //                     else if (hour.keys.first == startAtHour) {
    //                       // добавляем  ячейку
    //                       cellsWeekData.addAll([
    //                         {
    //                           'day_id': day.id,
    //                           'cellId': cells[cell]['cellId'],
    //                           'start_at': DateFormat('HH:mm').format(day.startAt!),
    //                           'completed_at': DateFormat('HH:mm').format(day.completedAt!),
    //                           'oldCellId': true,
    //                         }
    //                       ]);
    //                     }
    //                   }
    //                 }
    //                 // Если час выполнения совпадает
    //                 else if (startAtHour == completedAtHour) {
    //                   // print('Если час выполнения совпадает');
    //                   cellsWeekData.addAll([
    //                     {
    //                       'day_id': day.id,
    //                       'cellId': cells[cell]['cellId'],
    //                       'start_at': DateFormat('HH:mm').format(day.startAt!),
    //                       'completed_at': DateFormat('HH:mm').format(day.completedAt!),
    //                       'day_matches': true,
    //                     }
    //                   ]);
    //                 }
    //               }
    //               // День НЕ завершен
    //               else {
    //                 cellsWeekData.addAll([
    //                   {
    //                     'day_id': day.id,
    //                     'cellId': cells[cell]['cellId'],
    //                     'start_at': DateFormat('HH:mm').format(day.startAt!),
    //                     'completed_at': '',
    //                   }
    //                 ]);
    //               }
    //             }
    //
    //             weeksOnPage.addAll([
    //               {
    //                 'pageIndex': i,
    //                 'monday': weekMonday,
    //                 'sunday': weekSunday,
    //                 'cellsWeekData': cellsWeekData,
    //                 'weekOpenedPeriod': weekOpenedPeriod.toSet().toList(),
    //                 'isEditable': false,
    //                 'weekId': week.id,
    //                 'week': week,
    //               }
    //             ]);
    //           }
    //           // Дни НЕ созданы
    //           else {
    //             // print('Дни недели НЕ созданы 3');
    //
    //             weeksOnPage.addAll([
    //               {
    //                 'pageIndex': i,
    //                 'monday': weekMonday,
    //                 'sunday': weekSunday,
    //                 'cellsWeekData': [],
    //                 'weekOpenedPeriod': [0, 1, 2],
    //                 'isEditable': true,
    //                 'weekId': week.id,
    //                 'week': week,
    //               }
    //             ]);
    //           }
    //         }
    //
    //         ///////////////////////////////////////////////
    //         // Будущая неделя
    //         ///////////////////////////////////////////////
    //         if (isNextWeek) {
    //           // print('nextPageIndex: $nextPageIndex');
    //           // print('defaultPageIndex: $defaultPageIndex');
    //           if (defaultPageIndex + 1 == nextPageIndex) {
    //             Week? nextWeek = stream.weekBacklink.elementAtOrNull(nextPageIndex);
    //             // Неделя создана
    //             if (nextWeek == null) {
    //               // print('Будущая Неделя НЕ 55 создана');
    //               // Добавляем cледующую неделю
    //               allPages = stream.weekBacklink.length + 1;
    //               weeksOnPage.add({
    //                 'pageIndex': nextPageIndex,
    //                 'monday': weekMonday.add(const Duration(days: 7)),
    //                 'sunday': weekSunday.add(const Duration(days: 7)),
    //                 'cellsWeekData': [],
    //                 'weekOpenedPeriod': [0, 1, 2],
    //                 'isEditable': true,
    //                 'weekId': null, // если неделя не создана - week.id НЕТ
    //                 'weekOfYear': week.weekNumber! + 1,
    //                 'week': week,
    //               });
    //             }
    //           }
    //         }
    //       }
    //       // Если НЕ требуется новая неделя
    //       else {
    //         // print('НЕ требуется новая неделя');
    //
    //         List weekOpenedPeriod = [];
    //         // Дни созданы
    //         if (cells.isNotEmpty) {
    //           // print('Дни текущей недели и созданных. Без недели с подсказками 55');
    //
    //           for (int cell = 0; cell < cells.length; cell++) {
    //             // добавляем индекс заполненного периода
    //             // если воскресенье - НЕ добавляем
    //             if (cells[cell]['cellId'][2] != 6) {
    //               weekOpenedPeriod.add(cells[cell]['cellId'][0]);
    //             }
    //
    //             // день получаем по cells[cell]['dayId']
    //             final day = week.dayBacklink.where((day) => day.id == cells[cell]['dayId']).first;
    //
    //             ///////////////////////////////
    //             // Статус дня
    //             ///////////////////////////////
    //
    //             // День завершен
    //             if (day.completedAt != null) {
    //               // час завершения дела актуальный
    //               String completedAtHour = DateFormat('H').format(day.completedAt!);
    //
    //               // print('day 33: ${day.id} : ${day.completedAt}');
    //
    //               for (Map hour in periodHoursIndexList) {
    //                 // print('hour: $hour');
    //                 // час завершения дела актуальный
    //                 if (hour.keys.first == completedAtHour) {
    //                   // находим индекс дня ячейки
    //                   int gridIndex = cells[cell]['cellId'].last;
    //                   // Создаем новый список
    //                   List newHourCellId = List.from(hour.values.first);
    //
    //                   newHourCellId.add(gridIndex);
    //
    //                   // добавляем новую ячейку с новым индексом
    //                   cellsWeekData.addAll([
    //                     {
    //                       'day_id': day.id,
    //                       'cellId': newHourCellId,
    //                       'start_at': '',
    //                       'completed_at': DateFormat('HH:mm').format(day.completedAt!),
    //                       'statusCell': 'completed',
    //                     }
    //                   ]);
    //
    //                   // добавляем индекс заполненного периода
    //                   weekOpenedPeriod.add(newHourCellId[0]);
    //                 }
    //               }
    //             }
    //             // день не завершен
    //             else {
    //               // print('day 334: ${day.id}');
    //               // добавляем индекс заполненного периода
    //               // weekOpenedPeriod.add();
    //               // добавляем новую ячейку с новым индексом
    //               // cellsWeekData.addAll([
    //               //   {
    //               //     'day_id': day.id,
    //               //     'cellId': cells[cell]['cellId'],
    //               //     'start_at': '',
    //               //     'completed_at': '',
    //               //     'statusCell': 'empty',
    //               //   }
    //               // ]);
    //             }
    //           }
    //
    //           weeksOnPage.addAll([
    //             {
    //               'pageIndex': i,
    //               'monday': weekMonday,
    //               'sunday': weekSunday,
    //               'cellsWeekData': cellsWeekData,
    //               'weekOpenedPeriod': weekOpenedPeriod.toSet().toList(),
    //               'isEditable': false,
    //               'weekId': week.id,
    //               'week': week,
    //             }
    //           ]);
    //         }
    //         // Дни НЕ созданы
    //         else {
    //           // print('Дни недели НЕ созданы 3');
    //
    //           weeksOnPage.addAll([
    //             {
    //               'pageIndex': i,
    //               'monday': weekMonday,
    //               'sunday': weekSunday,
    //               'cellsWeekData': [],
    //               'weekOpenedPeriod': [0, 1, 2],
    //               'isEditable': true,
    //               'weekId': week.id,
    //               'week': week,
    //             }
    //           ]);
    //         }
    //       }
    //     }
    //   }
    //   //////////////////////////////////////////
    //   // дни недели созданы
    //   //////////////////////////////////////////
    //   else {
    //     // print('дни текущей недели созданы 543 $i');
    //
    //     // Если требуется добавить новую неделю
    //     if (nextPageIndex != null) {
    //       // Созданные недели
    //       if (i < nextPageIndex) {
    //         print('i: $i, nextPageIndex: $nextPageIndex');
    //         // print('Созданные недели');
    //
    //         List weekOpenedPeriod = [];
    //
    //         // Дни созданы
    //         if (cells.isNotEmpty) {
    //           // print('Дни недели созданы');
    //
    //           // print('cells: $cells');
    //
    //           for (int cell = 0; cell < cells.length; cell++) {
    //             // добавляем индекс заполненного периода
    //             // если воскресенье - НЕ добавляем
    //             if (cells[cell]['cellId'][2] != 6) {
    //               weekOpenedPeriod.add(cells[cell]['cellId'][0]);
    //             }
    //
    //             // день получаем по cells[cell]['dayId']
    //             final day = week.dayBacklink.where((day) => day.id == cells[cell]['dayId']).first;
    //
    //             ///////////////////////////////
    //             // Статус дня
    //             ///////////////////////////////
    //             DateTime startAtDate = DateTime.parse(DateFormat('y-MM-dd').format(day.startAt!));
    //
    //             // День завершен
    //             if (day.completedAt != null) {
    //               // час старта дела по плану
    //               String startAtHour = DateFormat('H').format(day.startAt!);
    //               // час завершения дела актуальный
    //               String completedAtHour = DateFormat('H').format(day.completedAt!);
    //               // print('startAtHour: $startAtHour');
    //               // print('completedAtHour: $completedAtHour');
    //
    //               // Если час выполнения не совпадает
    //               if (startAtHour != completedAtHour) {
    //                 for (Map hour in periodHoursIndexList) {
    //                   // час завершения дела актуальный
    //                   if (hour.keys.first == completedAtHour) {
    //                     // находим индекс дня ячейки
    //                     int gridIndex = cells[cell]['cellId'].last;
    //                     // Создаем новый список
    //                     List newHourCellId = List.from(hour.values.first);
    //
    //                     newHourCellId.add(gridIndex);
    //
    //                     // добавляем новую ячейку с новым индексом
    //                     cellsWeekData.addAll([
    //                       {
    //                         'day_id': day.id,
    //                         'cellId': newHourCellId,
    //                         'start_at': DateFormat('HH:mm').format(day.startAt!),
    //                         'completed_at': DateFormat('HH:mm').format(day.completedAt!),
    //                         'newCellId': true,
    //                       }
    //                     ]);
    //
    //                     // добавляем индекс заполненного периода
    //                     weekOpenedPeriod.add(newHourCellId[0]);
    //
    //                     // print('hourIndex: $hourIndex');
    //                   } else if (hour.keys.first == startAtHour) {
    //                     // добавляем  ячейку
    //                     cellsWeekData.addAll([
    //                       {
    //                         'day_id': day.id,
    //                         'cellId': cells[cell]['cellId'],
    //                         'start_at': DateFormat('HH:mm').format(day.startAt!),
    //                         'completed_at': DateFormat('HH:mm').format(day.completedAt!),
    //                         'oldCellId': true,
    //                       }
    //                     ]);
    //                   }
    //                 }
    //               }
    //               // Если час выполнения совпадает
    //               else if (startAtHour == completedAtHour) {
    //                 // print('Если час выполнения совпадает');
    //                 cellsWeekData.addAll([
    //                   {
    //                     'day_id': day.id,
    //                     'cellId': cells[cell]['cellId'],
    //                     'start_at': DateFormat('HH:mm').format(day.startAt!),
    //                     'completed_at': DateFormat('HH:mm').format(day.completedAt!),
    //                     'day_matches': true,
    //                   }
    //                 ]);
    //               }
    //             }
    //             // День НЕ завершен
    //             else {
    //               cellsWeekData.addAll([
    //                 {
    //                   'day_id': day.id,
    //                   'cellId': cells[cell]['cellId'],
    //                   'start_at': DateFormat('HH:mm').format(day.startAt!),
    //                   'completed_at': '',
    //                 }
    //               ]);
    //             }
    //           }
    //
    //           // print('weekOpenedPeriod: $weekOpenedPeriod');
    //
    //           weeksOnPage.addAll([
    //             {
    //               'pageIndex': i,
    //               'monday': weekMonday,
    //               'sunday': weekSunday,
    //               'cellsWeekData': cellsWeekData,
    //               'weekOpenedPeriod': weekOpenedPeriod.toSet().toList(),
    //               'isEditable': false,
    //               'weekId': week.id,
    //               'week': week,
    //             }
    //           ]);
    //         }
    //         // Дни НЕ созданы
    //         // TODO: создать функционал
    //         else {
    //           // print('Дни недели НЕ созданы 1');
    //
    //           weeksOnPage.addAll([
    //             {
    //               'pageIndex': i,
    //               'monday': weekMonday,
    //               'sunday': weekSunday,
    //               'cellsWeekData': [],
    //               'weekOpenedPeriod': [0, 1, 2],
    //               'isEditable': true,
    //               'weekId': week.id,
    //               'week': week,
    //             }
    //           ]);
    //         }
    //       }
    //       // Созданная БУДУЩАЯ неделя
    //       else {
    //         // print('Созданная БУДУЩАЯ неделя 3');
    //         // Дни созданы
    //         if (cells.isNotEmpty) {
    //           // print('Дни БУДУЩЕЙ недели созданы 2');
    //           List weekOpenedPeriodFutureWeek = [];
    //
    //           for (int cell = 0; cell < cells.length; cell++) {
    //             // добавляем индекс заполненного периода
    //             // если воскресенье - НЕ добавляем
    //             if (cells[cell]['cellId'][2] != 6) {
    //               weekOpenedPeriodFutureWeek.add(cells[cell]['cellId'][0]);
    //             }
    //
    //             // день получаем по cells[cell]['dayId']
    //             final day = week.dayBacklink.where((day) => day.id == cells[cell]['dayId']).first;
    //
    //             // ячейки
    //             cellsWeekData.addAll([
    //               {
    //                 'day_id': day.id,
    //                 'cellId': cells[cell]['cellId'],
    //                 'start_at': DateFormat('HH:mm').format(day.startAt!),
    //                 'completed_at': '',
    //               }
    //             ]);
    //           }
    //
    //           weeksOnPage.addAll([
    //             {
    //               'pageIndex': i,
    //               'monday': weekMonday,
    //               'sunday': weekSunday,
    //               'cellsWeekData': cellsWeekData,
    //               'weekOpenedPeriod': weekOpenedPeriodFutureWeek.toSet().toList(),
    //               'isEditable': true,
    //               'weekId': week.id,
    //               'week': week,
    //             }
    //           ]);
    //         }
    //         // Дни НЕ созданы
    //         // TODO: создать функционал
    //         else {
    //           // print('Дни недели НЕ созданы 2');
    //
    //           weeksOnPage.addAll([
    //             {
    //               'pageIndex': i,
    //               'monday': weekMonday,
    //               'sunday': weekSunday,
    //               'cellsWeekData': [],
    //               'weekOpenedPeriod': [0, 1, 2],
    //               'isEditable': true,
    //               'weekId': week.id,
    //               'week': week,
    //             }
    //           ]);
    //         }
    //       }
    //
    //       ///////////////////////////////////////////////
    //       // Будущая неделя
    //       ///////////////////////////////////////////////
    //       if (isNextWeek) {
    //         print('i2: $i, nextPageIndex: $nextPageIndex');
    //         if (defaultPageIndex + 1 == nextPageIndex) {
    //           Week? nextWeek = stream.weekBacklink.elementAtOrNull(nextPageIndex);
    //           // Неделя создана
    //           if (nextWeek == null) {
    //             // print('Будущая Неделя НЕ 33 создана');
    //             // Добавляем cледующую неделю
    //             allPages = stream.weekBacklink.length + 1;
    //             weeksOnPage.add({
    //               'pageIndex': nextPageIndex,
    //               'monday': weekMonday.add(const Duration(days: 7)),
    //               'sunday': weekSunday.add(const Duration(days: 7)),
    //               'cellsWeekData': [],
    //               'weekOpenedPeriod': [0, 1, 2],
    //               'isEditable': true,
    //               'weekId': null, // если неделя не создана - week.id НЕТ
    //               'weekOfYear': week.weekNumber! + 1,
    //             });
    //           }
    //         }
    //       }
    //     }
    //     // Если НЕ требуется новая неделя
    //     else {
    //       List weekOpenedPeriod = [];
    //       // Дни созданы
    //       if (cells.isNotEmpty) {
    //         // print('Дни текущей недели и созданных. Без недели с подсказками 55');
    //
    //         for (int cell = 0; cell < cells.length; cell++) {
    //           // добавляем индекс заполненного периода
    //           // если воскресенье - НЕ добавляем
    //           if (cells[cell]['cellId'][2] != 6) {
    //             weekOpenedPeriod.add(cells[cell]['cellId'][0]);
    //           }
    //
    //           // день получаем по cells[cell]['dayId']
    //           final day = week.dayBacklink.where((day) => day.id == cells[cell]['dayId']).first;
    //
    //           ///////////////////////////////
    //           // Статус дня
    //           ///////////////////////////////
    //           DateTime startAtDate = DateTime.parse(DateFormat('y-MM-dd').format(day.startAt!));
    //
    //           // День завершен
    //           if (day.completedAt != null) {
    //             // час старта дела по плану
    //             String startAtHour = DateFormat('H').format(day.startAt!);
    //             // час завершения дела актуальный
    //             String completedAtHour = DateFormat('H').format(day.completedAt!);
    //             // print('startAtHour: $startAtHour');
    //             // print('completedAtHour: $completedAtHour');
    //
    //             // TODO: продолжить тут
    //             // Если час выполнения не совпадает
    //             if (startAtHour != completedAtHour) {
    //               // print('Если час выполнения не совпадает 33');
    //               // print('day: ${day.startAt}');
    //               // print('day: ${day.completedAt}');
    //               // print('cell: ${cells[cell]}');
    //               for (Map hour in periodHoursIndexList) {
    //                 // час завершения дела актуальный
    //                 if (hour.keys.first == completedAtHour) {
    //                   // находим индекс дня ячейки
    //                   int gridIndex = cells[cell]['cellId'].last;
    //                   // Создаем новый список
    //                   List newHourCellId = List.from(hour.values.first);
    //
    //                   newHourCellId.add(gridIndex);
    //
    //                   // добавляем новую ячейку с новым индексом
    //                   cellsWeekData.addAll([
    //                     {
    //                       'day_id': day.id,
    //                       'cellId': newHourCellId,
    //                       'start_at': DateFormat('HH:mm').format(day.startAt!),
    //                       'completed_at': DateFormat('HH:mm').format(day.completedAt!),
    //                       'newCellId': true,
    //                     }
    //                   ]);
    //
    //                   // добавляем индекс заполненного периода
    //                   weekOpenedPeriod.add(newHourCellId[0]);
    //
    //                   // print('hourIndex: $hourIndex');
    //                 }
    //                 // час завершения дела НЕ актуальный
    //                 else if (hour.keys.first == startAtHour) {
    //                   // добавляем  ячейку
    //                   cellsWeekData.addAll([
    //                     {
    //                       'day_id': day.id,
    //                       'cellId': cells[cell]['cellId'],
    //                       'start_at': DateFormat('HH:mm').format(day.startAt!),
    //                       'completed_at': DateFormat('HH:mm').format(day.completedAt!),
    //                       'oldCellId': true,
    //                     }
    //                   ]);
    //                 }
    //               }
    //             }
    //             // Если час выполнения совпадает
    //             else if (startAtHour == completedAtHour) {
    //               // print('Если час выполнения совпадает');
    //               cellsWeekData.addAll([
    //                 {
    //                   'day_id': day.id,
    //                   'cellId': cells[cell]['cellId'],
    //                   'start_at': DateFormat('HH:mm').format(day.startAt!),
    //                   'completed_at': DateFormat('HH:mm').format(day.completedAt!),
    //                   'day_matches': true,
    //                 }
    //               ]);
    //             }
    //           }
    //           // День НЕ завершен
    //           else {
    //             cellsWeekData.addAll([
    //               {
    //                 'day_id': day.id,
    //                 'cellId': cells[cell]['cellId'],
    //                 'start_at': DateFormat('HH:mm').format(day.startAt!),
    //                 'completed_at': '',
    //               }
    //             ]);
    //           }
    //         }
    //
    //         weeksOnPage.addAll([
    //           {
    //             'pageIndex': i,
    //             'monday': weekMonday,
    //             'sunday': weekSunday,
    //             'cellsWeekData': cellsWeekData,
    //             'weekOpenedPeriod': weekOpenedPeriod.toSet().toList(),
    //             'isEditable': false,
    //             'weekId': week.id,
    //             'week': week,
    //           }
    //         ]);
    //       }
    //       // Дни НЕ созданы
    //       else {
    //         // print('Дни недели НЕ созданы 3');
    //
    //         weeksOnPage.addAll([
    //           {
    //             'pageIndex': i,
    //             'monday': weekMonday,
    //             'sunday': weekSunday,
    //             'cellsWeekData': [],
    //             'weekOpenedPeriod': [0, 1, 2],
    //             'isEditable': true,
    //             'weekId': week.id,
    //             'week': week,
    //           }
    //         ]);
    //       }
    //     }
    //   }
    // }
  }
  // После окончания курса
  else if (status == 'after') {
    // по умолчанию последняя неделя курса

    // формирование планера
    for (int i = 0; i < stream.weekBacklink.length; i++) {
      // Неделя
      Week week = stream.weekBacklink.elementAt(i);
      List cells = jsonDecode(week.cells!);

      DateTime weekMonday = firstDayOfStream.add(Duration(days: i * 7));
      DateTime weekSunday = firstDayOfStream.add(Duration(days: (i * 7) + 6));

      // print('weekMonday: $weekMonday');
      // print('weekSunday: $weekSunday');
      //////////////////////////////////////////
      // PageIndex последней недели
      //////////////////////////////////////////
      defaultPageIndex = weeks - 1;

      List cellsWeekData = [];
      List weekOpenedPeriod = [];

      for (int cell = 0; cell < cells.length; cell++) {
        // добавляем индекс заполненного периода
        // если воскресенье - НЕ добавляем
        if (cells[cell]['cellId'][2] != 6) {
          weekOpenedPeriod.add(cells[cell]['cellId'][0]);
        }

        // день получаем по cells[cell]['dayId']
        final day = week.dayBacklink.where((day) => day.id == cells[cell]['dayId']).first;

        ///////////////////////////////
        // Статус дня
        ///////////////////////////////

        // не пустая неделя
        if (day.startAt != null) {
          // День завершен
          if (day.completedAt != null) {
            // час старта дела по плану
            String startAtHour = DateFormat('H').format(day.startAt!);
            // час завершения дела актуальный
            String completedAtHour = DateFormat('H').format(day.completedAt!);
            // print('startAtHour: $startAtHour');
            // print('completedAtHour: $completedAtHour');

            // Если час выполнения не совпадает
            if (startAtHour != completedAtHour) {
              // print('Если час выполнения не совпадает 33');
              // print('day: ${day.startAt}');
              // print('day: ${day.completedAt}');
              // print('cell: ${cells[cell]}');
              for (Map hour in periodHoursIndexList) {
                // час завершения дела актуальный
                if (hour.keys.first == completedAtHour) {
                  // находим индекс дня ячейки
                  int gridIndex = cells[cell]['cellId'].last;
                  // Создаем новый список
                  List newHourCellId = List.from(hour.values.first);

                  newHourCellId.add(gridIndex);

                  // добавляем новую ячейку с новым индексом
                  cellsWeekData.addAll([
                    {
                      'day_id': day.id,
                      'cellId': newHourCellId,
                      'start_at': DateFormat('HH:mm').format(day.startAt!),
                      'completed_at': DateFormat('HH:mm').format(day.completedAt!),
                      'newCellId': true,
                    }
                  ]);

                  // добавляем индекс заполненного периода
                  weekOpenedPeriod.add(newHourCellId[0]);

                  // print('hourIndex: $hourIndex');
                }
                // час завершения дела НЕ актуальный
                else if (hour.keys.first == startAtHour) {
                  // добавляем  ячейку
                  cellsWeekData.addAll([
                    {
                      'day_id': day.id,
                      'cellId': cells[cell]['cellId'],
                      'start_at': DateFormat('HH:mm').format(day.startAt!),
                      'completed_at': DateFormat('HH:mm').format(day.completedAt!),
                      'oldCellId': true,
                    }
                  ]);
                }
              }
            }
            // Если час выполнения совпадает
            else if (startAtHour == completedAtHour) {
              // print('Если час выполнения совпадает');
              cellsWeekData.addAll([
                {
                  'day_id': day.id,
                  'cellId': cells[cell]['cellId'],
                  'start_at': DateFormat('HH:mm').format(day.startAt!),
                  'completed_at': DateFormat('HH:mm').format(day.completedAt!),
                  'day_matches': true,
                }
              ]);
            }
          }
          // День НЕ завершен
          else {
            cellsWeekData.addAll([
              {
                'day_id': day.id,
                'cellId': cells[cell]['cellId'],
                'start_at': DateFormat('HH:mm').format(day.startAt!),
                'completed_at': '',
              }
            ]);
          }
        }
        // пустая неделя
        else {
          // День завершен
          if (day.completedAt != null) {
            // час завершения дела актуальный
            String completedAtHour = DateFormat('H').format(day.completedAt!);

            for (Map hour in periodHoursIndexList) {
              // print('hour: $hour');
              // час завершения дела актуальный
              if (hour.keys.first == completedAtHour) {
                // находим индекс дня ячейки
                int gridIndex = cells[cell]['cellId'].last;
                // Создаем новый список
                List newHourCellId = List.from(hour.values.first);

                newHourCellId.add(gridIndex);

                // добавляем новую ячейку с новым индексом
                cellsWeekData.addAll([
                  {
                    'day_id': day.id,
                    'cellId': newHourCellId,
                    'start_at': '',
                    'completed_at': DateFormat('HH:mm').format(day.completedAt!),
                    'statusCell': 'completed',
                  }
                ]);

                // добавляем индекс заполненного периода
                weekOpenedPeriod.add(newHourCellId[0]);

                // print('hourIndex: $hourIndex');
              }
            }
          }
        }
      }

      weeksOnPage.addAll([
        {
          'pageIndex': i,
          'monday': weekMonday,
          'sunday': weekSunday,
          'cellsWeekData': cellsWeekData,
          'weekOpenedPeriod': weekOpenedPeriod.toSet().toList(),
          'isEditable': false,
          'weekId': week.id,
          'week': week,
        }
      ]);
    }
  }

  // print('weeksOnPage: ${weeksOnPage}');
  // print('allPages: ${allPages}');
  // print('defaultPageIndex: ${defaultPageIndex}');

  data['weeksOnPage'] = weeksOnPage;
  data['allPages'] = allPages;
  data['defaultPageIndex'] = defaultPageIndex;

  return data;
}
