import 'dart:convert';

import 'package:intl/intl.dart';

import '../../../../../core/utils/get_week_number.dart';
import '../../../domain/entities/stream_entity.dart';
import '../core.dart';

Map getWeekData(NPStream stream, String status) {
  Map data = {};

  // страниц планера
  int allPages = stream.weekBacklink.length;
  // формируем все недели с данными
  List weeksOnPage = [];
  int weeks = stream.weeks!;

  // TODO: до старта и после завершения курса индекс известен
  // индекс текущей недели
  int? currentWeekIndex;
  int? defaultPageIndex;

  // формируем созданные недели с данными
  for (int i = 0; i < stream.weekBacklink.length; i++) {
    Week week = stream.weekBacklink.elementAt(i);
    List _cells = jsonDecode(week.cells!);
    List cellsWeekData = [];
    List weekOpenedPeriod = [];

    //////////////////////////////////////////
    // PageIndex текущей недели
    //////////////////////////////////////////
    // До старта курса
    if (status == 'before') {
      currentWeekIndex = 0;
      defaultPageIndex = 0;
    }
    // После окончания курса
    else if (status == 'after') {
      currentWeekIndex = weeks - 1;
      defaultPageIndex = weeks - 1;
    }
    // Во время прохождения курса
    else if (status == 'process') {
      if (getWeekNumber(DateTime.now()) == week.weekNumber) {
        currentWeekIndex = i;
        defaultPageIndex = i;
      }
    }

    //////////////////////////////////////////
    // Формирование данных ячеек
    //////////////////////////////////////////
    for (int i = 0; i < _cells.length; i++) {
      int cellIndex = _cells[i]['cellId'][2];

      // добавляем индекс заполненного периода
      weekOpenedPeriod.add(_cells[i]['cellId'][0]);

      var _day =
      week.dayBacklink.indexed.where((element) => element.$1 == cellIndex);

      Day day = _day.first.$2;
      // DAY START AT
      DateTime startAtDate =
      DateTime.parse(DateFormat('y-MM-dd').format(day.startAt!));

      // До старта курса
      if (status == 'before') {
        cellsWeekData.addAll([
          {
            'day_id': day.id,
            'cellId': _cells[i]['cellId'],
            'start_at': DateFormat('HH:mm').format(day.startAt!),
            'completed_at': '',
          }
        ]);
      }
      // После окончания курса
      else if (status == 'after') {
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
                int gridIndex = _cells[i]['cellId'].last;
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
                    'cellId': _cells[i]['cellId'],
                    'start_at': DateFormat('HH:mm').format(day.startAt!),
                    'completed_at':
                    DateFormat('HH:mm').format(day.completedAt!),
                    'oldCellId': true,
                  }
                ]);
                // добавляем индекс заполненного периода
                weekOpenedPeriod.add(_cells[i]['cellId'][0]);
              }
            }
          }
          // Если час выполнения совпадает
          else if (startAtHour == completedAtHour) {
            cellsWeekData.addAll([
              {
                'day_id': day.id,
                'cellId': _cells[i]['cellId'],
                'start_at': DateFormat('HH:mm').format(day.startAt!),
                'completed_at': DateFormat('HH:mm').format(day.completedAt!),
                'day_matches': true,
              }
            ]);
            // добавляем индекс заполненного периода
            weekOpenedPeriod.add(_cells[i]['cellId'][0]);
          }
        }
        // День НЕ завершен
        else {
          cellsWeekData.addAll([
            {
              'day_id': day.id,
              'cellId': _cells[i]['cellId'],
              'start_at': DateFormat('HH:mm').format(day.startAt!),
              'completed_at': '',
            }
          ]);
        }
      }
      // Во время прохождения курса
      else if (status == 'process') {
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
                int gridIndex = _cells[i]['cellId'].last;
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
                    'cellId': _cells[i]['cellId'],
                    'start_at': DateFormat('HH:mm').format(day.startAt!),
                    'completed_at':
                    DateFormat('HH:mm').format(day.completedAt!),
                    'oldCellId': true,
                  }
                ]);
                // добавляем индекс заполненного периода
                weekOpenedPeriod.add(_cells[i]['cellId'][0]);
              }
            }
          }
          // Если час выполнения совпадает
          else if (startAtHour == completedAtHour) {
            cellsWeekData.addAll([
              {
                'day_id': day.id,
                'cellId': _cells[i]['cellId'],
                'start_at': DateFormat('HH:mm').format(day.startAt!),
                'completed_at': DateFormat('HH:mm').format(day.completedAt!),
                'day_matches': true,
              }
            ]);
            // добавляем индекс заполненного периода
            weekOpenedPeriod.add(_cells[i]['cellId'][0]);
          }
        }
        // День НЕ завершен
        else {
          cellsWeekData.addAll([
            {
              'day_id': day.id,
              'cellId': _cells[i]['cellId'],
              'start_at': DateFormat('HH:mm').format(day.startAt!),
              'completed_at': '',
            }
          ]);
        }
      }
    }

    //////////////////////////////////////////
    // Добавление недель с данными
    //////////////////////////////////////////
    if (status == 'before') {
      // если курс не страртовал
      // добавляем возможность редактирования
      weeksOnPage.addAll([
        {
          'pageIndex': i,
          'monday': week.dayBacklink.first.startAt,
          'sunday': week.dayBacklink.last.startAt,
          'cellsWeekData': cellsWeekData,
          'weekOpenedPeriod': weekOpenedPeriod.toSet().toList(),
          'isEditable': true,
        }
      ]);
    } else {
      weeksOnPage.addAll([
        {
          'pageIndex': i,
          'monday': week.dayBacklink.first.startAt,
          'sunday': week.dayBacklink.last.startAt,
          'cellsWeekData': cellsWeekData,
          'weekOpenedPeriod': weekOpenedPeriod.toSet().toList(),
        }
      ]);
    }
  }

  //////////////////////////////////////////
  // Формируем будущую редактируемую неделю
  //////////////////////////////////////////
  // Во время прохождения курса
  if (status == 'process') {
    if (stream.weekBacklink.length < weeks) {
      // индекс следующей недели
      int nextWeekIndex = currentWeekIndex! + 1;
      // добавляем новую страницу в планере
      allPages = stream.weekBacklink.length + 1;
      // проверить - если неделя не началась
      // последняя созданная неделя
      Week lastCreatedWeek = stream.weekBacklink
          .elementAt(weeksOnPage[currentWeekIndex]['pageIndex']);

      List _cells = jsonDecode(lastCreatedWeek.cells!);
      List cellsWeekData = [];
      List weekOpenedPeriod = [];

      // Формирование данных ячеек
      for (int i = 0; i < _cells.length; i++) {
        int cellIndex = _cells[i]['cellId'][2];

        // добавляем индекс заполненного периода
        weekOpenedPeriod.add(_cells[i]['cellId'][0]);

        var _day = lastCreatedWeek.dayBacklink.indexed
            .where((element) => element.$1 == cellIndex);

        Day day = _day.first.$2;
        // DAY START AT
        DateTime startAtDate =
        DateTime.parse(DateFormat('y-MM-dd').format(day.startAt!));

        cellsWeekData.addAll([
          {
            'day_id': 0,
            'cellId': _cells[i]['cellId'],
            'start_at': DateFormat('HH:mm').format(day.startAt!),
            'completed_at': '',
          }
        ]);
      }

      // Добавление будущей недели с данными
      weeksOnPage.addAll([
        {
          'pageIndex': nextWeekIndex,
          'monday': lastCreatedWeek.dayBacklink.first.startAt!
              .add(const Duration(days: 7)),
          'sunday': lastCreatedWeek.dayBacklink.last.startAt!
              .add(const Duration(days: 7)),
          'cellsWeekData': cellsWeekData,
          'weekOpenedPeriod': weekOpenedPeriod.toSet().toList(),
          'isEditable': true,
        }
      ]);
    }
  }

  data['weeksOnPage'] = weeksOnPage;
  data['allPages'] = allPages;
  data['defaultPageIndex'] = defaultPageIndex;

  return data;
}
