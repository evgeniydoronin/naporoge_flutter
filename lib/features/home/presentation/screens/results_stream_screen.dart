import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:isar/isar.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/services/db_client/isar_service.dart';
import '../../../planning/domain/entities/stream_entity.dart';

@RoutePage()
class ResultsStreamScreen extends StatefulWidget {
  const ResultsStreamScreen({super.key});

  @override
  State<ResultsStreamScreen> createState() => _ResultsStreamScreenState();
}

Future<Map> getTotalResultsStream() async {
  Map total = {};

  final isarService = IsarService();
  final isar = await isarService.db;
  final stream = await isar.nPStreams.filter().isActiveEqualTo(true).findFirst();

  int weeks = stream!.weeks!;
  int days = 6 * weeks;

  // формируем завершенные дни
  List weekIds = stream.weekBacklink.map((week) => week.id).toList();

  ///////////////////////////////
  // Завершенные дни
  ///////////////////////////////
  List daysIdCompleted = [];
  for (int i = 0; i < weekIds.length; i++) {
    List daysInWeek = await isar.days.filter().weekIdEqualTo(weekIds[i]).completedAtIsNotNull().findAll();
    daysIdCompleted.addAll(daysInWeek);
  }

  ///////////////////////////////
  // Результат выполнения дня
  ///////////////////////////////
  List executionScope = [];
  if (daysIdCompleted.isNotEmpty) {
    for (int i = 0; i < daysIdCompleted.length; i++) {
      Day day = daysIdCompleted[i];
      final res = await isar.dayResults.filter().executionScopeGreaterThan(0).dayIdEqualTo(day.id).findFirst();

      if (res != null) {
        executionScope.add(res);
      }
    }
  }

  ///////////////////////////////
  // объем выполнения
  ///////////////////////////////
  List low = [];
  List middle = [];
  List high = [];

  for (Week week in stream.weekBacklink) {
    for (Day day in week.dayBacklink) {
      for (DayResult result in day.dayResultBacklink) {
        if (result.executionScope! <= 49) {
          low.add(1);
        } else if (result.executionScope! > 50 && result.executionScope! <= 80) {
          middle.add(1);
        } else if (result.executionScope! >= 81) {
          high.add(1);
        }
      }
    }
  }

  ///////////////////////////////
  // сообщение
  ///////////////////////////////
  TextSpan? message;
  List margePoint = [low.length, middle.length, high.length];
  int point = margePoint.reduce((a, b) => a > b ? a : b);
  int? maxPointIndex;

  for (int i = 0; i < margePoint.length; i++) {
    if (margePoint[i] == point) {
      maxPointIndex = i;
    }
  }
  // слабо
  if (maxPointIndex == 0) {
    message = const TextSpan(
      text: 'Слабо. \n',
      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      children: <TextSpan>[
        TextSpan(
            text:
                'Продолжайте тренировать волю. Делайте дело «во что бы то ни стало». Не забывайте радоваться успехам. Возникнут трудности – присоединяйтесь в чат',
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14)),
      ],
    );
  }
  // хорошо
  else if (maxPointIndex == 1) {
    message = const TextSpan(
      text: 'Хорошо. \n',
      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      children: <TextSpan>[
        TextSpan(
            text: 'Рекомендуем продолжать саморазвитие. У вас хорошие способности',
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14)),
      ],
    );
  }
  // отлично
  else if (maxPointIndex == 1) {
    message = const TextSpan(
      text: 'Отлично. \n',
      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      children: <TextSpan>[
        TextSpan(
            text: 'Поздравляем! Рекомендуем продолжать саморазвитие. Реальный шанс сильно продвинуться',
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14)),
      ],
    );
  }

  ///////////////////////////////
  // План не составлялся
  ///////////////////////////////
  List weekNotPlannedList = [];
  for (int i = 0; i < stream.weekBacklink.length; i++) {
    Week week = stream.weekBacklink.elementAt(i);

    if (week.dayBacklink.first.startAt == null) {
      weekNotPlannedList.add(1);
    }
  }

  // РЕЗУЛЬТАТЫ
  total['title'] = stream.title;
  total['weeks'] = weeks;
  total['days'] = days;
  total['message'] = message;
  total['low'] = low.length;
  total['middle'] = middle.length;
  total['high'] = high.length;
  total['executionScope'] = executionScope.length;
  total['weekNotPlanned'] = weekNotPlannedList.length;

  return total;
}

class _ResultsStreamScreenState extends State<ResultsStreamScreen> {
  late final Future totalResults;

  @override
  void initState() {
    totalResults = getTotalResultsStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightBG,
      appBar: AppBar(
        backgroundColor: AppColor.lightBG,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            context.router.pop();
          },
          icon: RotatedBox(quarterTurns: 2, child: SvgPicture.asset('assets/icons/arrow.svg')),
        ),
        title: Text(
          'Итоги работы',
          style: AppFont.scaffoldTitleDark,
        ),
      ),
      body: FutureBuilder(
        future: totalResults,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map streamResults = snapshot.data;

            return ListView(
              children: [
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
                    decoration: BoxDecoration(
                      color: AppColor.lightBGItem,
                      borderRadius: AppLayout.primaryRadius,
                    ),
                    child: Text(
                      streamResults['title'],
                      style: TextStyle(color: AppColor.accentBOW, fontSize: AppFont.large, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
                    decoration: AppLayout.boxDecorationShadowBG,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/1357.svg'),
                        const SizedBox(height: 15),
                        RichText(
                          text: TextSpan(
                            text: 'Выполнено ${streamResults['executionScope']}',
                            style:
                                TextStyle(fontWeight: FontWeight.w600, color: AppColor.deep, fontSize: AppFont.regular),
                            children: <TextSpan>[
                              TextSpan(
                                  text: ' из ${streamResults['days']} дней',
                                  style: const TextStyle(fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        RichText(
                          text: streamResults['message'],
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
                    decoration: AppLayout.boxDecorationShadowBG,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Объем выполнения дела (дней)',
                          style: AppFont.scaffoldTitleDark,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Отлично',
                              style: TextStyle(fontSize: AppFont.regular),
                            ),
                            Text(
                              '${streamResults['high']}',
                              style: TextStyle(fontSize: AppFont.regular),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Хорошо',
                              style: TextStyle(fontSize: AppFont.regular),
                            ),
                            Text(
                              '${streamResults['middle']}',
                              style: TextStyle(fontSize: AppFont.regular),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Слабо',
                              style: TextStyle(fontSize: AppFont.regular),
                            ),
                            Text(
                              '${streamResults['low']}',
                              style: TextStyle(fontSize: AppFont.regular),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'План не составлялся',
                              style: TextStyle(fontSize: AppFont.regular, color: AppColor.red),
                            ),
                            Text(
                              '${streamResults['weekNotPlanned']} из ${streamResults['weeks']}',
                              style: TextStyle(fontSize: AppFont.regular, color: AppColor.red),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: AppLayout.accentBTNStyle,
                                child: Text(
                                  'Смотреть статистику',
                                  style: AppFont.regularSemibold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Stack(
                    children: [
                      const Positioned(
                          bottom: 50, left: 80, child: Image(image: AssetImage('assets/images/flower.png'))),
                      Column(
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
                                    decoration: AppLayout.boxDecorationOpacityShadowBG,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Продлить Дело на 6 недель?',
                                          style: TextStyle(fontSize: AppFont.large, fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Закрепите полезные привычки',
                                          style: TextStyle(fontSize: AppFont.smaller, fontWeight: FontWeight.normal),
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () {},
                                                style: AppLayout.accentBTNStyle,
                                                child: Text(
                                                  'Продлить',
                                                  style: AppFont.regularSemibold,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
                                    decoration: AppLayout.boxDecorationOpacityShadowBG,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Выбрать новое дело',
                                          style: TextStyle(fontSize: AppFont.large, fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Вперед, к новым достижениям!',
                                          style: TextStyle(fontSize: AppFont.smaller, fontWeight: FontWeight.normal),
                                        ),
                                        const SizedBox(height: 20),
                                        const Spacer(),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () {},
                                                style: AppLayout.accentBTNStyle,
                                                child: Text(
                                                  'Выбрать',
                                                  style: AppFont.regularSemibold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
                                  decoration: AppLayout.boxDecorationShadowBG,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Для глубокого продвижения в тему развития рекомендуем книгу «Тренажер для Я» и другие ресурсы –  смотрите',
                                        style: TextStyle(color: AppColor.grey3, fontSize: AppFont.regular),
                                      ),
                                      Text(
                                        'Дополнительное',
                                        style: TextStyle(color: AppColor.accent, fontSize: AppFont.regular),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
