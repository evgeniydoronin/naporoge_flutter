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

  // индекс текущей недели
  int? currentWeekIndex;
  int? defaultPageIndex;

  // Первая неделя курса
  Week firstWeek = stream.weekBacklink.elementAt(0);
  List firstWeekCells = jsonDecode(firstWeek.cells!);

  // До старта курса
  if (status == 'before') {
    // индекс первой недели
    currentWeekIndex = 0;
    // планер открыт на первой неделе
    defaultPageIndex = 0;

    //////////////////////////////////////////
    // Формируем первую неделю с данными
    // Если первая неделя не пустая
    //////////////////////////////////////////
    if (firstWeekCells.isNotEmpty) {
      // Дни недели по порядку
      final allWeekDays = await firstWeek.dayBacklink
          .filter()
          .sortByStartAt()
          .thenByStartAt()
          .findAll();

      for (int createdWeek = 0;
          createdWeek < stream.weekBacklink.length;
          createdWeek++) {
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
          final day = week.dayBacklink
              .where((day) => day.id == cells[cell]['dayId'])
              .first;

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
    // формируем созданные недели с данными
    print('формируем: ${stream.weekBacklink.length}');
    for (int createdWeek = 0;
        createdWeek < stream.weekBacklink.length;
        createdWeek++) {
      Week week = stream.weekBacklink.elementAt(createdWeek);
      List cells = jsonDecode(week.cells!);

      List cellsWeekData = [];
      List weekOpenedPeriod = [];

      // Дни недели по порядку
      var allWeekDays = await week.dayBacklink
          .filter()
          .sortByStartAt()
          .thenByStartAt()
          .findAll();

      //////////////////////////////////////////
      // PageIndex текущей недели
      //////////////////////////////////////////
      if (getWeekNumber(DateTime.now()) == week.weekNumber) {
        currentWeekIndex = createdWeek;
        defaultPageIndex = createdWeek;
      }

      //////////////////////////////////////////
      // Формирование данных ячеек
      //////////////////////////////////////////

      // Дни первой недели созданы
      if (createdWeek == 0 && cells.isNotEmpty) {
        print('Дни первой недели созданы');

        // TODO: +++++++ start +++++++
        for (int i = 0; i < cells.length; i++) {
          int cellIndex = cells[i]['cellId'][2];

          // добавляем индекс заполненного периода
          weekOpenedPeriod.add(cells[i]['cellId'][0]);

          var _day = week.dayBacklink.indexed
              .where((element) => element.$1 == cellIndex);

          Day day = _day.first.$2;
          // DAY START AT
          DateTime startAtDate =
              DateTime.parse(DateFormat('y-MM-dd').format(day.startAt!));

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
              for (Map hour in periodHoursIndexList) {
                // час завершения дела актуальный
                if (hour.keys.first == completedAtHour) {
                  // находим индекс дня ячейки
                  int gridIndex = cells[i]['cellId'].last;
                  // Создаем новый список
                  List newHourCellId = List.from(hour.values.first);
                  newHourCellId.add(gridIndex);

                  // добавляем новую ячейку с новым индексом
                  cellsWeekData.addAll([
                    {
                      'day_id': day.id,
                      'cellId': newHourCellId,
                      'start_at': DateFormat('HH:mm').format(day.startAt!),
                      'completed_at':
                          DateFormat('HH:mm').format(day.completedAt!),
                      'newCellId': true,
                    }
                  ]);
                  // добавляем индекс заполненного периода
                  weekOpenedPeriod.add(gridIndex);

                  // print('hourIndex: $hourIndex');
                } else if (hour.keys.first == startAtHour) {
                  // добавляем  ячейку
                  cellsWeekData.addAll([
                    {
                      'day_id': day.id,
                      'cellId': cells[i]['cellId'],
                      'start_at': DateFormat('HH:mm').format(day.startAt!),
                      'completed_at':
                          DateFormat('HH:mm').format(day.completedAt!),
                      'oldCellId': true,
                    }
                  ]);
                  // добавляем индекс заполненного периода
                  weekOpenedPeriod.add(cells[i]['cellId'][0]);
                }
              }
            }
            // Если час выполнения совпадает
            else if (startAtHour == completedAtHour) {
              cellsWeekData.addAll([
                {
                  'day_id': day.id,
                  'cellId': cells[i]['cellId'],
                  'start_at': DateFormat('HH:mm').format(day.startAt!),
                  'completed_at': DateFormat('HH:mm').format(day.completedAt!),
                  'day_matches': true,
                }
              ]);
              // добавляем индекс заполненного периода
              weekOpenedPeriod.add(cells[i]['cellId'][0]);
            }
          }
          // День НЕ завершен
          else {
            cellsWeekData.addAll([
              {
                'day_id': day.id,
                'cellId': cells[i]['cellId'],
                'start_at': DateFormat('HH:mm').format(day.startAt!),
                'completed_at': '',
              }
            ]);
          }
        }
        // TODO: +++++++ end +++++++

        weeksOnPage.addAll([
          {
            'pageIndex': createdWeek,
            'monday': allWeekDays[0].startAt,
            'sunday': allWeekDays[6].startAt,
            'cellsWeekData': cellsWeekData,
            'weekOpenedPeriod': [2],
            'isEditable': false,
            'weekId': week.id,
          }
        ]);
      }
      // Дни первой недели НЕ созданы
      else if (createdWeek == 0 && cells.isEmpty) {
        print('Дни первой недели НЕ созданы');
      }
      // Дни недели созданы
      else if (createdWeek != 0 && cells.isNotEmpty) {
        print('Дни недели созданы');
      }
      // Дни недели НЕ созданы
      else if (createdWeek != 0 && cells.isEmpty) {
        print('Дни недели НЕ созданы');
      }

      // for (int i = 0; i < cells.length; i++) {
      //   int cellIndex = cells[i]['cellId'][2];
      //
      //   // добавляем индекс заполненного периода
      //   weekOpenedPeriod.add(cells[i]['cellId'][0]);
      //
      //   var _day = week.dayBacklink.indexed
      //       .where((element) => element.$1 == cellIndex);
      //
      //   Day day = _day.first.$2;
      //   // DAY START AT
      //   DateTime startAtDate =
      //       DateTime.parse(DateFormat('y-MM-dd').format(day.startAt!));
      //
      //   // До старта курса
      //   if (status == 'before') {
      //     cellsWeekData.addAll([
      //       {
      //         'day_id': day.id,
      //         'cellId': cells[i]['cellId'],
      //         'start_at': DateFormat('HH:mm').format(day.startAt!),
      //         'completed_at': '',
      //       }
      //     ]);
      //   }
      //   // После окончания курса
      //   else if (status == 'after') {
      //     // День завершен
      //     if (day.completedAt != null) {
      //       // час старта дела по плану
      //       String startAtHour = DateFormat('H').format(day.startAt!);
      //       // час завершения дела актуальный
      //       String completedAtHour = DateFormat('H').format(day.completedAt!);
      //       // print('startAtHour: $startAtHour');
      //       // print('completedAtHour: $completedAtHour');
      //
      //       // Если час выполнения не совпадает
      //       if (startAtHour != completedAtHour) {
      //         for (Map hour in periodHoursIndexList) {
      //           // час завершения дела актуальный
      //           if (hour.keys.first == completedAtHour) {
      //             // находим индекс дня ячейки
      //             int gridIndex = cells[i]['cellId'].last;
      //             // Создаем новый список
      //             List newHourCellId = List.from(hour.values.first);
      //             newHourCellId.add(gridIndex);
      //
      //             // добавляем новую ячейку с новым индексом
      //             cellsWeekData.addAll([
      //               {
      //                 'day_id': day.id,
      //                 'cellId': newHourCellId,
      //                 'start_at': DateFormat('HH:mm').format(day.startAt!),
      //                 'completed_at':
      //                     DateFormat('HH:mm').format(day.completedAt!),
      //                 'newCellId': true,
      //               }
      //             ]);
      //             // добавляем индекс заполненного периода
      //             weekOpenedPeriod.add(gridIndex);
      //
      //             // print('hourIndex: $hourIndex');
      //           } else if (hour.keys.first == startAtHour) {
      //             // добавляем  ячейку
      //             cellsWeekData.addAll([
      //               {
      //                 'day_id': day.id,
      //                 'cellId': cells[i]['cellId'],
      //                 'start_at': DateFormat('HH:mm').format(day.startAt!),
      //                 'completed_at':
      //                     DateFormat('HH:mm').format(day.completedAt!),
      //                 'oldCellId': true,
      //               }
      //             ]);
      //             // добавляем индекс заполненного периода
      //             weekOpenedPeriod.add(cells[i]['cellId'][0]);
      //           }
      //         }
      //       }
      //       // Если час выполнения совпадает
      //       else if (startAtHour == completedAtHour) {
      //         cellsWeekData.addAll([
      //           {
      //             'day_id': day.id,
      //             'cellId': cells[i]['cellId'],
      //             'start_at': DateFormat('HH:mm').format(day.startAt!),
      //             'completed_at': DateFormat('HH:mm').format(day.completedAt!),
      //             'day_matches': true,
      //           }
      //         ]);
      //         // добавляем индекс заполненного периода
      //         weekOpenedPeriod.add(cells[i]['cellId'][0]);
      //       }
      //     }
      //     // День НЕ завершен
      //     else {
      //       cellsWeekData.addAll([
      //         {
      //           'day_id': day.id,
      //           'cellId': cells[i]['cellId'],
      //           'start_at': DateFormat('HH:mm').format(day.startAt!),
      //           'completed_at': '',
      //         }
      //       ]);
      //     }
      //   }
      //   // Во время прохождения курса
      //   else if (status == 'process') {
      //     // День завершен
      //     if (day.completedAt != null) {
      //       // час старта дела по плану
      //       String startAtHour = DateFormat('H').format(day.startAt!);
      //       // час завершения дела актуальный
      //       String completedAtHour = DateFormat('H').format(day.completedAt!);
      //       // print('startAtHour: $startAtHour');
      //       // print('completedAtHour: $completedAtHour');
      //
      //       // Если час выполнения не совпадает
      //       if (startAtHour != completedAtHour) {
      //         for (Map hour in periodHoursIndexList) {
      //           // час завершения дела актуальный
      //           if (hour.keys.first == completedAtHour) {
      //             // находим индекс дня ячейки
      //             int gridIndex = cells[i]['cellId'].last;
      //             // Создаем новый список
      //             List newHourCellId = List.from(hour.values.first);
      //             newHourCellId.add(gridIndex);
      //
      //             // добавляем новую ячейку с новым индексом
      //             cellsWeekData.addAll([
      //               {
      //                 'day_id': day.id,
      //                 'cellId': newHourCellId,
      //                 'start_at': DateFormat('HH:mm').format(day.startAt!),
      //                 'completed_at':
      //                     DateFormat('HH:mm').format(day.completedAt!),
      //                 'newCellId': true,
      //               }
      //             ]);
      //             // добавляем индекс заполненного периода
      //             weekOpenedPeriod.add(gridIndex);
      //
      //             // print('hourIndex: $hourIndex');
      //           } else if (hour.keys.first == startAtHour) {
      //             // добавляем  ячейку
      //             cellsWeekData.addAll([
      //               {
      //                 'day_id': day.id,
      //                 'cellId': cells[i]['cellId'],
      //                 'start_at': DateFormat('HH:mm').format(day.startAt!),
      //                 'completed_at':
      //                     DateFormat('HH:mm').format(day.completedAt!),
      //                 'oldCellId': true,
      //               }
      //             ]);
      //             // добавляем индекс заполненного периода
      //             weekOpenedPeriod.add(cells[i]['cellId'][0]);
      //           }
      //         }
      //       }
      //       // Если час выполнения совпадает
      //       else if (startAtHour == completedAtHour) {
      //         cellsWeekData.addAll([
      //           {
      //             'day_id': day.id,
      //             'cellId': cells[i]['cellId'],
      //             'start_at': DateFormat('HH:mm').format(day.startAt!),
      //             'completed_at': DateFormat('HH:mm').format(day.completedAt!),
      //             'day_matches': true,
      //           }
      //         ]);
      //         // добавляем индекс заполненного периода
      //         weekOpenedPeriod.add(cells[i]['cellId'][0]);
      //       }
      //     }
      //     // День НЕ завершен
      //     else {
      //       cellsWeekData.addAll([
      //         {
      //           'day_id': day.id,
      //           'cellId': cells[i]['cellId'],
      //           'start_at': DateFormat('HH:mm').format(day.startAt!),
      //           'completed_at': '',
      //         }
      //       ]);
      //     }
      //   }
      // }

      // //////////////////////////////////////////
      // // Добавление недель с данными
      // //////////////////////////////////////////
      // // если курс не страртовал
      // // добавляем возможность редактирования
      // if (status == 'before') {
      //   weeksOnPage.addAll([
      //     {
      //       'pageIndex': i,
      //       'monday': allWeekDays[0].startAt,
      //       'sunday': allWeekDays[6].startAt,
      //       'cellsWeekData': cellsWeekData,
      //       'weekOpenedPeriod': [2],
      //       'isEditable': true,
      //       'weekId': week.id,
      //     }
      //   ]);
      // }
      // // без редактирования
      // else {
      //   weeksOnPage.addAll([
      //     {
      //       'pageIndex': i,
      //       'monday': allWeekDays[0].startAt,
      //       'sunday': allWeekDays[6].startAt,
      //       'cellsWeekData': cellsWeekData,
      //       'weekOpenedPeriod': weekOpenedPeriod.toSet().toList(),
      //       'weekId': week.id,
      //     }
      //   ]);
      // }
    }
    // Проверка на создание первой недели
  }

  // // Первая неделя курса создана
  // if (firstWeekCells.isNotEmpty) {
  //   print('firstWeekCells.isNotEmpty');
  //   // формируем созданные недели с данными
  //   for (int i = 0; i < stream.weekBacklink.length; i++) {
  //     Week week = stream.weekBacklink.elementAt(i);
  //     List _cells = jsonDecode(week.cells!);
  //
  //     List cellsWeekData = [];
  //     List weekOpenedPeriod = [];
  //
  //     // Дни недели
  //     var allWeekDays = await week.dayBacklink
  //         .filter()
  //         .sortByStartAt()
  //         .thenByStartAt()
  //         .findAll();
  //
  //     //////////////////////////////////////////
  //     // PageIndex текущей недели
  //     //////////////////////////////////////////
  //     // До старта курса
  //     if (status == 'before') {
  //       currentWeekIndex = 0;
  //       defaultPageIndex = 0;
  //     }
  //     // После окончания курса
  //     else if (status == 'after') {
  //       currentWeekIndex = weeks - 1;
  //       defaultPageIndex = weeks - 1;
  //     }
  //     // Во время прохождения курса
  //     else if (status == 'process') {
  //       if (getWeekNumber(DateTime.now()) == week.weekNumber) {
  //         currentWeekIndex = i;
  //         defaultPageIndex = i;
  //       }
  //     }
  //
  //     //////////////////////////////////////////
  //     // Формирование данных ячеек
  //     //////////////////////////////////////////
  //
  //     for (int i = 0; i < _cells.length; i++) {
  //       int cellIndex = _cells[i]['cellId'][2];
  //
  //       // добавляем индекс заполненного периода
  //       weekOpenedPeriod.add(_cells[i]['cellId'][0]);
  //
  //       var _day = week.dayBacklink.indexed
  //           .where((element) => element.$1 == cellIndex);
  //
  //       Day day = _day.first.$2;
  //       // DAY START AT
  //       DateTime startAtDate =
  //           DateTime.parse(DateFormat('y-MM-dd').format(day.startAt!));
  //
  //       // До старта курса
  //       if (status == 'before') {
  //         cellsWeekData.addAll([
  //           {
  //             'day_id': day.id,
  //             'cellId': _cells[i]['cellId'],
  //             'start_at': DateFormat('HH:mm').format(day.startAt!),
  //             'completed_at': '',
  //           }
  //         ]);
  //       }
  //       // После окончания курса
  //       else if (status == 'after') {
  //         // День завершен
  //         if (day.completedAt != null) {
  //           // час старта дела по плану
  //           String startAtHour = DateFormat('H').format(day.startAt!);
  //           // час завершения дела актуальный
  //           String completedAtHour = DateFormat('H').format(day.completedAt!);
  //           // print('startAtHour: $startAtHour');
  //           // print('completedAtHour: $completedAtHour');
  //
  //           // Если час выполнения не совпадает
  //           if (startAtHour != completedAtHour) {
  //             for (Map hour in periodHoursIndexList) {
  //               // час завершения дела актуальный
  //               if (hour.keys.first == completedAtHour) {
  //                 // находим индекс дня ячейки
  //                 int gridIndex = _cells[i]['cellId'].last;
  //                 // Создаем новый список
  //                 List newHourCellId = List.from(hour.values.first);
  //                 newHourCellId.add(gridIndex);
  //
  //                 // добавляем новую ячейку с новым индексом
  //                 cellsWeekData.addAll([
  //                   {
  //                     'day_id': day.id,
  //                     'cellId': newHourCellId,
  //                     'start_at': DateFormat('HH:mm').format(day.startAt!),
  //                     'completed_at':
  //                         DateFormat('HH:mm').format(day.completedAt!),
  //                     'newCellId': true,
  //                   }
  //                 ]);
  //                 // добавляем индекс заполненного периода
  //                 weekOpenedPeriod.add(gridIndex);
  //
  //                 // print('hourIndex: $hourIndex');
  //               } else if (hour.keys.first == startAtHour) {
  //                 // добавляем  ячейку
  //                 cellsWeekData.addAll([
  //                   {
  //                     'day_id': day.id,
  //                     'cellId': _cells[i]['cellId'],
  //                     'start_at': DateFormat('HH:mm').format(day.startAt!),
  //                     'completed_at':
  //                         DateFormat('HH:mm').format(day.completedAt!),
  //                     'oldCellId': true,
  //                   }
  //                 ]);
  //                 // добавляем индекс заполненного периода
  //                 weekOpenedPeriod.add(_cells[i]['cellId'][0]);
  //               }
  //             }
  //           }
  //           // Если час выполнения совпадает
  //           else if (startAtHour == completedAtHour) {
  //             cellsWeekData.addAll([
  //               {
  //                 'day_id': day.id,
  //                 'cellId': _cells[i]['cellId'],
  //                 'start_at': DateFormat('HH:mm').format(day.startAt!),
  //                 'completed_at': DateFormat('HH:mm').format(day.completedAt!),
  //                 'day_matches': true,
  //               }
  //             ]);
  //             // добавляем индекс заполненного периода
  //             weekOpenedPeriod.add(_cells[i]['cellId'][0]);
  //           }
  //         }
  //         // День НЕ завершен
  //         else {
  //           cellsWeekData.addAll([
  //             {
  //               'day_id': day.id,
  //               'cellId': _cells[i]['cellId'],
  //               'start_at': DateFormat('HH:mm').format(day.startAt!),
  //               'completed_at': '',
  //             }
  //           ]);
  //         }
  //       }
  //       // Во время прохождения курса
  //       else if (status == 'process') {
  //         // День завершен
  //         if (day.completedAt != null) {
  //           // час старта дела по плану
  //           String startAtHour = DateFormat('H').format(day.startAt!);
  //           // час завершения дела актуальный
  //           String completedAtHour = DateFormat('H').format(day.completedAt!);
  //           // print('startAtHour: $startAtHour');
  //           // print('completedAtHour: $completedAtHour');
  //
  //           // Если час выполнения не совпадает
  //           if (startAtHour != completedAtHour) {
  //             for (Map hour in periodHoursIndexList) {
  //               // час завершения дела актуальный
  //               if (hour.keys.first == completedAtHour) {
  //                 // находим индекс дня ячейки
  //                 int gridIndex = _cells[i]['cellId'].last;
  //                 // Создаем новый список
  //                 List newHourCellId = List.from(hour.values.first);
  //                 newHourCellId.add(gridIndex);
  //
  //                 // добавляем новую ячейку с новым индексом
  //                 cellsWeekData.addAll([
  //                   {
  //                     'day_id': day.id,
  //                     'cellId': newHourCellId,
  //                     'start_at': DateFormat('HH:mm').format(day.startAt!),
  //                     'completed_at':
  //                         DateFormat('HH:mm').format(day.completedAt!),
  //                     'newCellId': true,
  //                   }
  //                 ]);
  //                 // добавляем индекс заполненного периода
  //                 weekOpenedPeriod.add(gridIndex);
  //
  //                 // print('hourIndex: $hourIndex');
  //               } else if (hour.keys.first == startAtHour) {
  //                 // добавляем  ячейку
  //                 cellsWeekData.addAll([
  //                   {
  //                     'day_id': day.id,
  //                     'cellId': _cells[i]['cellId'],
  //                     'start_at': DateFormat('HH:mm').format(day.startAt!),
  //                     'completed_at':
  //                         DateFormat('HH:mm').format(day.completedAt!),
  //                     'oldCellId': true,
  //                   }
  //                 ]);
  //                 // добавляем индекс заполненного периода
  //                 weekOpenedPeriod.add(_cells[i]['cellId'][0]);
  //               }
  //             }
  //           }
  //           // Если час выполнения совпадает
  //           else if (startAtHour == completedAtHour) {
  //             cellsWeekData.addAll([
  //               {
  //                 'day_id': day.id,
  //                 'cellId': _cells[i]['cellId'],
  //                 'start_at': DateFormat('HH:mm').format(day.startAt!),
  //                 'completed_at': DateFormat('HH:mm').format(day.completedAt!),
  //                 'day_matches': true,
  //               }
  //             ]);
  //             // добавляем индекс заполненного периода
  //             weekOpenedPeriod.add(_cells[i]['cellId'][0]);
  //           }
  //         }
  //         // День НЕ завершен
  //         else {
  //           cellsWeekData.addAll([
  //             {
  //               'day_id': day.id,
  //               'cellId': _cells[i]['cellId'],
  //               'start_at': DateFormat('HH:mm').format(day.startAt!),
  //               'completed_at': '',
  //             }
  //           ]);
  //         }
  //       }
  //     }
  //
  //     //////////////////////////////////////////
  //     // Добавление недель с данными
  //     //////////////////////////////////////////
  //     // если курс не страртовал
  //     // добавляем возможность редактирования
  //     if (status == 'before') {
  //       weeksOnPage.addAll([
  //         {
  //           'pageIndex': i,
  //           'monday': allWeekDays[0].startAt,
  //           'sunday': allWeekDays[6].startAt,
  //           'cellsWeekData': cellsWeekData,
  //           'weekOpenedPeriod': [2],
  //           'isEditable': true,
  //           'weekId': week.id,
  //         }
  //       ]);
  //     }
  //     // без редактирования
  //     else {
  //       weeksOnPage.addAll([
  //         {
  //           'pageIndex': i,
  //           'monday': allWeekDays[0].startAt,
  //           'sunday': allWeekDays[6].startAt,
  //           'cellsWeekData': cellsWeekData,
  //           'weekOpenedPeriod': weekOpenedPeriod.toSet().toList(),
  //           'weekId': week.id,
  //         }
  //       ]);
  //     }
  //   }
  //
  //   //////////////////////////////////////////
  //   // Формируем будущую редактируемую неделю
  //   //////////////////////////////////////////
  //   // Во время прохождения курса
  //   if (status == 'process') {
  //     if (stream.weekBacklink.length < weeks) {
  //       // индекс следующей недели
  //       int nextWeekIndex = currentWeekIndex! + 1;
  //       // добавляем новую страницу в планере
  //       allPages = stream.weekBacklink.length + 1;
  //       // проверить - если неделя не началась
  //       // последняя созданная неделя
  //       Week lastCreatedWeek = stream.weekBacklink
  //           .elementAt(weeksOnPage[currentWeekIndex]['pageIndex']);
  //
  //       List _cells = jsonDecode(lastCreatedWeek.cells!);
  //       List cellsWeekData = [];
  //       List weekOpenedPeriod = [];
  //
  //       // Формирование данных ячеек
  //       for (int i = 0; i < _cells.length; i++) {
  //         int cellIndex = _cells[i]['cellId'][2];
  //
  //         // добавляем индекс заполненного периода
  //         weekOpenedPeriod.add(_cells[i]['cellId'][0]);
  //
  //         var _day = lastCreatedWeek.dayBacklink.indexed
  //             .where((element) => element.$1 == cellIndex);
  //
  //         Day day = _day.first.$2;
  //         // DAY START AT
  //         DateTime startAtDate =
  //             DateTime.parse(DateFormat('y-MM-dd').format(day.startAt!));
  //
  //         cellsWeekData.addAll([
  //           {
  //             'day_id': 0,
  //             'cellId': _cells[i]['cellId'],
  //             'start_at': DateFormat('HH:mm').format(day.startAt!),
  //             'completed_at': '',
  //           }
  //         ]);
  //       }
  //
  //       // Добавление будущей недели с данными
  //       weeksOnPage.addAll([
  //         {
  //           'pageIndex': nextWeekIndex,
  //           'monday': lastCreatedWeek.dayBacklink.first.startAt!
  //               .add(const Duration(days: 7)),
  //           'sunday': lastCreatedWeek.dayBacklink.last.startAt!
  //               .add(const Duration(days: 7)),
  //           'cellsWeekData': cellsWeekData,
  //           'weekOpenedPeriod': weekOpenedPeriod.toSet().toList(),
  //           'isEditable': true,
  //         }
  //       ]);
  //     }
  //   }
  // }
  // // Первая неделя курса не создана
  // else {
  //   currentWeekIndex = 0;
  //   defaultPageIndex = 0;
  //
  //   weeksOnPage.addAll([
  //     {
  //       'pageIndex': 0,
  //       'monday': stream.startAt,
  //       'sunday': stream.startAt!.add(const Duration(days: 6)),
  //       'cellsWeekData': [],
  //       'weekOpenedPeriod': [0, 1, 2], // открываем 3 периода по умолчанию
  //       'isEditable': true,
  //       'weekId': firstWeek.id,
  //     }
  //   ]);
  // }

  print('weeksOnPage: ${weeksOnPage[0]}');

  data['weeksOnPage'] = weeksOnPage;
  data['allPages'] = allPages;
  data['defaultPageIndex'] = defaultPageIndex;

  return data;
}
