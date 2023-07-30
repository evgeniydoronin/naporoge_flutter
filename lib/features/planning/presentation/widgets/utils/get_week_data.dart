import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:isar/isar.dart';

import '../../../../../core/utils/get_week_number.dart';
import '../../../domain/entities/stream_entity.dart';
import '../core.dart';

Future getWeekData(NPStream stream, String status) async {
  Map data = {};

  // страниц планера
  int allPages = stream.weekBacklink.length;
  // формируем все недели с данными
  List weeksOnPage = [];
  // количество недель на курсе
  int weeks = stream.weeks!;

  // индекс недели по умолчанию
  int defaultPageIndex = 0;
  // индекс страницы для создания
  int? nextPageIndex;

  // Первая неделя курса
  Week firstWeek = stream.weekBacklink.elementAt(0);
  List firstWeekCells = jsonDecode(firstWeek.cells!);

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
  // После окончания курса
  else if (status == 'after') {
  }
  // Во время прохождения курса
  else if (status == 'process') {
    print('на курсе недель: ${weeks}');
    print('создано недель: ${stream.weekBacklink.length}');

    // по умолчанию нельзя создать следующую неделю
    bool isNextWeek = false;

    // если на курсе не создана следующая неделя
    if (stream.weekBacklink.length < weeks) {
      isNextWeek = true;
      nextPageIndex = stream.weekBacklink.length;
    }

    for (int i = 0; i < stream.weekBacklink.length; i++) {
      // Неделя
      Week week = stream.weekBacklink.elementAt(i);
      List cells = jsonDecode(week.cells!);

      //////////////////////////////////////////
      // PageIndex текущей недели
      //////////////////////////////////////////
      if (getWeekNumber(DateTime.now()) == week.weekNumber) {
        defaultPageIndex = i;
      } else if (getWeekNumber(DateTime.now()) < week.weekNumber!) {
        nextPageIndex = i;
      }

      List cellsWeekData = [];

      // Дни недели по порядку
      var allWeekDays = await week.dayBacklink.filter().sortByStartAt().thenByStartAt().findAll();

      // print('nextPageIndex i : $nextPageIndex $i');
      // print('defaultPageIndex i : $defaultPageIndex $i');

      // flutter: nextPageIndex i : 2 0
      // flutter: defaultPageIndex i : 0 0

      // flutter: nextPageIndex i : 1 1
      // flutter: defaultPageIndex i : 0 1

      // Если требуется добавить новую неделю
      if (nextPageIndex != null) {
        // Созданные недели
        if (i < nextPageIndex) {
          print('Созданные недели');

          List weekOpenedPeriod = [];

          // Дни созданы
          if (cells.isNotEmpty) {
            print('Дни недели созданы');

            // print('cells: $cells');

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
              DateTime startAtDate = DateTime.parse(DateFormat('y-MM-dd').format(day.startAt!));

              // День завершен
              if (day.completedAt != null) {
                // час старта дела по плану
                String startAtHour = DateFormat('H').format(day.startAt!);
                // час завершения дела актуальный
                String completedAtHour = DateFormat('H').format(day.completedAt!);
                print('startAtHour: $startAtHour');
                print('completedAtHour: $completedAtHour');

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
                    } else if (hour.keys.first == startAtHour) {
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
                  print('Если час выполнения совпадает');
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

            // print('weekOpenedPeriod: $weekOpenedPeriod');

            weeksOnPage.addAll([
              {
                'pageIndex': i,
                'monday': allWeekDays[0].startAt,
                'sunday': allWeekDays[6].startAt,
                'cellsWeekData': cellsWeekData,
                'weekOpenedPeriod': weekOpenedPeriod.toSet().toList(),
                'isEditable': false,
                'weekId': week.id,
              }
            ]);
          }
          // Дни НЕ созданы
          // TODO: создать функционал
          else {
            print('Дни недели НЕ созданы 1');

            weeksOnPage.addAll([
              {
                'pageIndex': i,
                'monday': allWeekDays[0].startAt,
                'sunday': allWeekDays[6].startAt,
                'cellsWeekData': [],
                'weekOpenedPeriod': [0, 1, 2],
                'isEditable': true,
                'weekId': week.id,
              }
            ]);
          }
        }
        // Созданная БУДУЩАЯ неделя
        else {
          print('Созданная БУДУЩАЯ неделя');
          // Дни созданы
          if (cells.isNotEmpty) {
            print('Дни БУДУЩЕЙ недели созданы');
            List weekOpenedPeriodFutureWeek = [];

            for (int cell = 0; cell < cells.length; cell++) {
              // добавляем индекс заполненного периода
              // если воскресенье - НЕ добавляем
              if (cells[cell]['cellId'][2] != 6) {
                weekOpenedPeriodFutureWeek.add(cells[cell]['cellId'][0]);
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

            weeksOnPage.addAll([
              {
                'pageIndex': i,
                'monday': allWeekDays[0].startAt,
                'sunday': allWeekDays[6].startAt,
                'cellsWeekData': cellsWeekData,
                'weekOpenedPeriod': weekOpenedPeriodFutureWeek.toSet().toList(),
                'isEditable': true,
                'weekId': week.id,
              }
            ]);
          }
          // Дни НЕ созданы
          // TODO: создать функционал
          else {
            print('Дни недели НЕ созданы 2');

            weeksOnPage.addAll([
              {
                'pageIndex': i,
                'monday': allWeekDays[0].startAt,
                'sunday': allWeekDays[6].startAt,
                'cellsWeekData': [],
                'weekOpenedPeriod': [0, 1, 2],
                'isEditable': true,
                'weekId': week.id,
              }
            ]);
          }
        }

        ///////////////////////////////////////////////
        // Будущая неделя
        ///////////////////////////////////////////////
        if (isNextWeek) {
          if (defaultPageIndex + 1 == nextPageIndex) {
            Week? nextWeek = stream.weekBacklink.elementAtOrNull(nextPageIndex);
            // Неделя создана
            if (nextWeek == null) {
              print('Будущая Неделя НЕ создана');
              // Добавляем cледующую неделю
              allPages = stream.weekBacklink.length + 1;
              weeksOnPage.add({
                'pageIndex': nextPageIndex,
                'monday': allWeekDays.first.startAt!.add(const Duration(days: 7)),
                'sunday': allWeekDays.last.startAt!.add(const Duration(days: 7)),
                'cellsWeekData': [],
                'weekOpenedPeriod': [0, 1, 2],
                'isEditable': true,
                'weekId': null, // если неделя не создана - week.id НЕТ
                'weekOfYear': week.weekNumber! + 1,
              });
            }
          }
        }
      }
      // Если НЕ требуется новая неделя
      else {
        List weekOpenedPeriod = [];
        // Дни созданы
        if (cells.isNotEmpty) {
          print('Дни текущей недели созданы');

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
            DateTime startAtDate = DateTime.parse(DateFormat('y-MM-dd').format(day.startAt!));

            // День завершен
            if (day.completedAt != null) {
              // час старта дела по плану
              String startAtHour = DateFormat('H').format(day.startAt!);
              // час завершения дела актуальный
              String completedAtHour = DateFormat('H').format(day.completedAt!);
              print('startAtHour: $startAtHour');
              print('completedAtHour: $completedAtHour');

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
                  } else if (hour.keys.first == startAtHour) {
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
                print('Если час выполнения совпадает');
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

          weeksOnPage.addAll([
            {
              'pageIndex': i,
              'monday': allWeekDays[0].startAt,
              'sunday': allWeekDays[6].startAt,
              'cellsWeekData': cellsWeekData,
              'weekOpenedPeriod': weekOpenedPeriod.toSet().toList(),
              'isEditable': false,
              'weekId': week.id,
            }
          ]);
        }
        // Дни НЕ созданы
        // TODO: создать функционал
        else {
          print('Дни недели НЕ созданы 3');

          weeksOnPage.addAll([
            {
              'pageIndex': i,
              'monday': allWeekDays[0].startAt,
              'sunday': allWeekDays[6].startAt,
              'cellsWeekData': [],
              'weekOpenedPeriod': [0, 1, 2],
              'isEditable': true,
              'weekId': week.id,
            }
          ]);
        }
      }
    }
  }

  // print('weeksOnPage: ${weeksOnPage}');
  // print('allPages: ${allPages}');

  data['weeksOnPage'] = weeksOnPage;
  data['allPages'] = allPages;
  data['defaultPageIndex'] = defaultPageIndex;

  return data;
}
