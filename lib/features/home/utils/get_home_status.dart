import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import '../../planning/domain/entities/stream_entity.dart';
import '../../../core/services/db_client/isar_service.dart';
import '../../../core/utils/get_stream_status.dart';
import '../../../core/utils/get_week_number.dart';

Future getHomeStatus() async {
  final isarService = IsarService();
  final isar = await isarService.db;
  final stream = await isar.nPStreams.filter().isActiveEqualTo(true).findFirst();
  DateTime startStreamAt = stream!.startAt!;
  int weeks = stream.weeks!;

  DateTime now = DateTime.now();

  // статус курса (before, after, process)
  Map streamStatus = await getStreamStatus();

  // Проверка в предпоследний и последний день курса
  // для вывода Итогов
  bool isLastWeekOnStream = false;

  // сообщение в шапке
  Map topMessage = {'text': 'Внесите результаты дня'};
  // статус кнопки сохранения
  Map button = {
    'isActive': false, // по умолчанию
  };

  // текущая неделя
  int currentWeekNumber = getWeekNumber(DateTime.now());

  // print('currentWeekNumber: $currentWeekNumber');

  // До старта курса
  if (streamStatus['status'] == 'before') {
    topMessage['text'] = '';
  }
  // После завершения курса
  else if (streamStatus['status'] == 'after') {
    // print('Home status - После завершения курса');
    // streamStatus['status'] = "after";
    topMessage['text'] = 'Итоги';
    button['isActive'] = true;
    button['status'] = 'goToTotalScreen';
  }
  // Во время прохождения курса
  else if (streamStatus['status'] == 'process') {
    // недели НЕ пустые
    if (stream.weekBacklink.isNotEmpty) {
      for (int i = 0; i < stream.weekBacklink.length; i++) {
        int currentWeekNumber = getWeekNumber(now);
        // текущая неделя может быть не последней
        final curWeek = stream.weekBacklink
            .where((week) => week.weekNumber == currentWeekNumber)
            .first;

        if (i + 1 == weeks) {
          final lastWeek = stream.weekBacklink.elementAt(i);
          if (curWeek.weekNumber == lastWeek.weekNumber) {
            // текущая неделя последняя
            isLastWeekOnStream = true;
          }
        }
      }

      Week week = stream.weekBacklink
          .where((week) => week.weekNumber == currentWeekNumber)
          .first;
      List days = await isar.days.filter().weekIdEqualTo(week.id).findAll();
      Day? monday = await isar.days.filter().weekIdEqualTo(week.id).findFirst();
      // пустая неделя
      bool weekIsEmpty = true;
      if (monday?.startAt != null) {
        weekIsEmpty = false;
      }

      // текущая неделя последняя
      if (isLastWeekOnStream) {
        print('текущая неделя последняя');
        // пустая неделя
        if (weekIsEmpty) {
          print('пустая последняя неделя');
          // суббота или воскресенье
          if (now.weekday == 6 || now.weekday == 7) {
            // завершенные дни текущей недели
            List daysWeekCompleted = await isar.days.filter().weekIdEqualTo(week.id).completedAtIsNotNull().findAll();

            // вывод итогов
            int needForTotal = weeks * 6;

            // Результат выполнения текущей недели
            List currentWeekExecutionScope = [];
            if (daysWeekCompleted.isNotEmpty) {
              for (int i = 0; i < daysWeekCompleted.length; i++) {
                Day day = daysWeekCompleted[i];
                final res =
                await isar.dayResults.filter().executionScopeGreaterThan(0).dayIdEqualTo(day.id).findFirst();

                if (res != null) {
                  currentWeekExecutionScope.add(res);
                }
              }
            }

            List weekIds = stream.weekBacklink.map((week) => week.id).toList();

            // Завершенные дни
            List daysIdCompleted = [];
            for (int i = 0; i < weekIds.length; i++) {
              List daysInWeek = await isar.days.filter().weekIdEqualTo(weekIds[i]).completedAtIsNotNull().findAll();
              daysIdCompleted.addAll(daysInWeek);
            }

            // Результат выполнения дня
            List executionScope = [];
            if (daysIdCompleted.isNotEmpty) {
              for (int i = 0; i < daysIdCompleted.length; i++) {
                Day day = daysIdCompleted[i];
                final res =
                await isar.dayResults.filter().executionScopeGreaterThan(0).dayIdEqualTo(day.id).findFirst();

                if (res != null) {
                  executionScope.add(res);
                }
              }
            }

            for (Day day in days) {
              // DateTime dayCompletedAt = DateTime.parse(DateFormat('y-MM-dd').format(day.completedAt!));

              if (now.weekday == 7) {
                // воскресенье выполнено
                if (days[6].completedAt != null) {
                  topMessage['text'] = 'Итоги';
                  button['isActive'] = true;
                  button['status'] = 'goToTotalScreen';
                }
                // воскресенье НЕ выполнено
                else {
                  button['isActive'] = true;
                }
              } else if (now.weekday == 6) {
                // суботта выполнена
                if (days[5].completedAt != null) {
                  if (executionScope.length >= needForTotal || currentWeekExecutionScope.length >= 6) {
                    topMessage['text'] = 'Итоги';
                    button['isActive'] = true;
                    button['status'] = 'goToTotalScreen';
                  } else {
                    topMessage['text'] = 'Результаты сохранены';
                  }
                }
                // суботта НЕ выполнена
                else {
                  button['isActive'] = true;
                }
              }
            }
          }
          // проверки в будни
          else {
            int freeDayIndex = now.weekday - 1;
            Day freeDay = days[freeDayIndex];
            // проверяем выполненные дни
            if (freeDay.completedAt != null) {
              topMessage['text'] = 'Результаты сохранены';
            } else if (freeDay.completedAt == null) {
              button['isActive'] = true;
            }
          }
        }
        // НЕ пустая неделя
        else {
          print('НЕ пустая последняя неделя');
          // суббота или воскресенье
          if (now.weekday == 6 || now.weekday == 7) {
            // завершенные дни текущей недели
            List daysWeekCompleted = await isar.days.filter().weekIdEqualTo(week.id).completedAtIsNotNull().findAll();

            // вывод итогов
            int needForTotal = weeks * 6;

            // Результат выполнения текущей недели
            List currentWeekExecutionScope = [];
            if (daysWeekCompleted.isNotEmpty) {
              for (int i = 0; i < daysWeekCompleted.length; i++) {
                Day day = daysWeekCompleted[i];
                final res =
                await isar.dayResults.filter().executionScopeGreaterThan(0).dayIdEqualTo(day.id).findFirst();

                if (res != null) {
                  currentWeekExecutionScope.add(res);
                }
              }
            }

            List weekIds = stream.weekBacklink.map((week) => week.id).toList();

            // Завершенные дни
            List daysIdCompleted = [];
            for (int i = 0; i < weekIds.length; i++) {
              List daysInWeek = await isar.days.filter().weekIdEqualTo(weekIds[i]).completedAtIsNotNull().findAll();
              daysIdCompleted.addAll(daysInWeek);
            }

            // Результат выполнения дня
            List executionScope = [];
            if (daysIdCompleted.isNotEmpty) {
              for (int i = 0; i < daysIdCompleted.length; i++) {
                Day day = daysIdCompleted[i];
                final res =
                await isar.dayResults.filter().executionScopeGreaterThan(0).dayIdEqualTo(day.id).findFirst();

                if (res != null) {
                  executionScope.add(res);
                }
              }
            }

            for (Day day in days) {
              DateTime dayStartAt = DateTime.parse(DateFormat('y-MM-dd').format(day.startAt!));

              // текущий день
              if (dayStartAt.isAtSameMomentAs(DateTime.parse(DateFormat('y-MM-dd').format(now)))) {
                print('текущий день');
                // проверяем выполненные дни
                if (day.completedAt != null) {
                  if (now.weekday == 7) {
                    topMessage['text'] = 'Итоги';
                    button['isActive'] = true;
                    button['status'] = 'goToTotalScreen';
                  } else {
                    if (executionScope.length >= needForTotal || currentWeekExecutionScope.length >= 6) {
                      topMessage['text'] = 'Итоги';
                      button['isActive'] = true;
                      button['status'] = 'goToTotalScreen';
                    } else {
                      topMessage['text'] = 'Результаты сохранены';
                    }
                  }
                }
                // день не выполнен
                else {
                  if (executionScope.length >= needForTotal || currentWeekExecutionScope.length >= 6) {
                    topMessage['text'] = 'Итоги';
                    button['isActive'] = true;
                    button['status'] = 'goToTotalScreen';
                  } else {
                    button['isActive'] = true;
                  }
                }
              }
            }
          }
          // будни
          else {
            // проверки в будни
            for (Day day in days) {
              DateTime dayStartAt = DateTime.parse(DateFormat('y-MM-dd').format(day.startAt!));

              // текущий день
              if (dayStartAt.isAtSameMomentAs(DateTime.parse(DateFormat('y-MM-dd').format(now)))) {
                // проверяем выполненные дни
                if (day.completedAt != null) {
                  topMessage['text'] = 'Результаты сохранены';
                } else {
                  button['isActive'] = true;
                }
              }

              // если пустая неделя
              // else {
              //   int freeDayIndex = now.weekday - 1;
              //   Day freeDay = days[freeDayIndex];
              //   // проверяем выполненные дни
              //   if (freeDay.completedAt != null) {
              //     topMessage['text'] = 'Результаты сохранены';
              //   } else if (freeDay.completedAt == null) {
              //     button['isActive'] = true;
              //   }
              // }
            }
          }
        }
      }
      // текущая неделя не последняя
      else {
        print('текущая неделя НЕ последняя');
        // пустая неделя
        if (weekIsEmpty) {
          print('пустая неделя');
          // проверки в воскресенье
          if (now.weekday == 7) {
            // завершенные дни текущей недели
            List daysCompleted = await isar.days.filter().weekIdEqualTo(week.id).completedAtIsNotNull().findAll();
            // завершенные дни текущей недели не пустые
            if (daysCompleted.isNotEmpty) {
              // текущее воскресенье
              final sunday = await isar.days.get(days[6].id);

              // воскресенье не сохранялось
              if (sunday!.completedAt == null) {
                List executionScope = [];
                // проверяем объем выполнения дней текущей неделм
                for (Day dayCompleted in daysCompleted) {
                  int i =
                  await isar.dayResults.filter().dayIdEqualTo(dayCompleted.id).executionScopeGreaterThan(0).count();
                  // значение выполненного объема больше 0
                  if (i != 0) {
                    executionScope.add(i);
                  }
                }

                // количество выполненных дней
                if (executionScope.length < 6) {
                  // активируем кнопку сохранения
                  button['isActive'] = true;
                } else {
                  topMessage['text'] = 'Выходной';
                }
              }
              // воскресенье сохранялось
              else {
                topMessage['text'] = 'Результаты сохранены';
              }
            }
          }
          // проверки в будни + суббота
          else {
            int freeDayIndex = now.weekday - 1;
            Day freeDay = days[freeDayIndex];
            // проверяем выполненные дни
            if (freeDay.completedAt != null) {
              topMessage['text'] = 'Результаты сохранены';
            } else if (freeDay.completedAt == null) {
              button['isActive'] = true;
            }
          }
        }
        // НЕ пустая неделя
        else {
          // проверки в воскресенье
          if (now.weekday == 7) {
            // завершенные дни
            List daysCompleted = await isar.days.filter().weekIdEqualTo(week.id).completedAtIsNotNull().findAll();
            // завершенные дни текущей недели не пустые
            if (daysCompleted.isNotEmpty) {
              // текущее воскресенье
              final sunday = await isar.days.get(days[6].id);

              // воскресенье не сохранялось
              if (sunday!.completedAt == null) {
                List executionScope = [];
                // проверяем объем выполнения дня
                for (Day dayCompleted in daysCompleted) {
                  int i =
                  await isar.dayResults.filter().dayIdEqualTo(dayCompleted.id).executionScopeGreaterThan(0).count();
                  // значение выполненного объема больше 0
                  if (i != 0) {
                    executionScope.add(i);
                  }
                }

                // количество выполненных дней
                if (executionScope.length < 6) {
                  // активируем кнопку сохранения
                  button['isActive'] = true;
                } else {
                  topMessage['text'] = 'Выходной';
                }
              }
              // воскресенье сохранялось
              else {
                topMessage['text'] = 'Результаты сохранены';
              }
            } else {
              button['isActive'] = true;
            }
          }
          // проверки в будни + суббота
          else {
            for (Day day in days) {
              // если НЕ пустая неделя
              if (day.startAt != null) {
                DateTime dayStartAt = DateTime.parse(DateFormat('y-MM-dd').format(day.startAt!));

                // текущий день
                if (dayStartAt.isAtSameMomentAs(DateTime.parse(DateFormat('y-MM-dd').format(now)))) {
                  // проверяем выполненные дни
                  if (day.completedAt != null) {
                    topMessage['text'] = 'Результаты сохранены';
                  } else {
                    button['isActive'] = true;
                  }
                }
              }
              // если пустая неделя
              else {
                int freeDayIndex = now.weekday - 1;
                Day freeDay = days[freeDayIndex];
                // проверяем выполненные дни
                if (freeDay.completedAt != null) {
                  topMessage['text'] = 'Результаты сохранены';
                } else if (freeDay.completedAt == null) {
                  button['isActive'] = true;
                }
              }
            }
          }
        }
      }
    }
    // первая неделя пустая
    else {
      topMessage['text'] = 'План не создан';
    }
  }

  return {'button': button, 'topMessage': topMessage};
}
