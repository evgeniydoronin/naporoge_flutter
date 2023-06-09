import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:isar/isar.dart';

import '../../../../core/constants/app_theme.dart';
import '../../../../core/services/db_client/isar_service.dart';
import '../../../planning/data/sources/local/stream_local_storage.dart';
import '../../../planning/domain/entities/stream_entity.dart';

@RoutePage()
class ResultsStreamScreen extends StatefulWidget {
  const ResultsStreamScreen({super.key});

  @override
  State<ResultsStreamScreen> createState() => _ResultsStreamScreenState();
}

class _ResultsStreamScreenState extends State<ResultsStreamScreen> {
  late final Future _getStream;

  @override
  void initState() {
    _getStream = getActiveStream();
    super.initState();
  }

  Future getActiveStream() async {
    final storage = StreamLocalStorage();
    return await storage.getActiveStream();
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
          icon: RotatedBox(
              quarterTurns: 2,
              child: SvgPicture.asset('assets/icons/arrow.svg')),
        ),
        title: Text(
          'Итоги работы',
          style: AppFont.scaffoldTitleDark,
        ),
      ),
      body: FutureBuilder(
        future: _getStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            NPStream stream = snapshot.data;
            int weeks = stream.weeks!;
            int days = 6 * weeks;

            List completedDaysList = [];

            // формируем завершенные дни
            completedDaysList.addAll(stream.weekBacklink.map((week) =>
                week.dayBacklink.where((day) => day.completedAt != null)));
            int completedDays = (completedDaysList[0].toList()).length;

            List low = [];
            List middle = [];
            List high = [];

            for (Week week in stream.weekBacklink) {
              for (Day day in week.dayBacklink) {
                for (DayResult result in day.dayResultBacklink) {
                  if (result.executionScope! <= 37) {
                    low.add([1]);
                  } else if (result.executionScope! > 38 &&
                      result.executionScope! < 70) {
                    middle.add([1]);
                  } else if (result.executionScope! > 70) {
                    high.add([1]);
                  }
                }
              }
            }

            print(low);
            print(middle);
            print(high);

            return ListView(
              children: [
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 18, right: 18),
                    decoration: BoxDecoration(
                      color: AppColor.lightBGItem,
                      borderRadius: AppLayout.primaryRadius,
                    ),
                    child: Text(
                      stream.title!,
                      style: TextStyle(
                          color: AppColor.accentBOW,
                          fontSize: AppFont.large,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 18, right: 18),
                    decoration: AppLayout.boxDecorationShadowBG,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/1357.svg'),
                        const SizedBox(height: 15),
                        RichText(
                          text: TextSpan(
                            text: 'Выполнено $completedDays',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColor.deep,
                                fontSize: AppFont.regular),
                            children: <TextSpan>[
                              TextSpan(
                                  text: ' из $days дней',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('Отлично. Поздравляем!'),
                        const Text('Продолжайте саморазвитие!'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 18, right: 18),
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
                              '${high.length}',
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
                              '${middle.length}',
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
                              '${low.length}',
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
                              style: TextStyle(
                                  fontSize: AppFont.regular,
                                  color: AppColor.red),
                            ),
                            Text(
                              '2 из 3',
                              style: TextStyle(
                                  fontSize: AppFont.regular,
                                  color: AppColor.red),
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
                          bottom: 50,
                          left: 80,
                          child: Image(
                              image: AssetImage('assets/images/flower.png'))),
                      Column(
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 15,
                                        bottom: 15,
                                        left: 18,
                                        right: 18),
                                    decoration:
                                        AppLayout.boxDecorationOpacityShadowBG,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Продлить Дело на 6 недель?',
                                          style: TextStyle(
                                              fontSize: AppFont.large,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Закрепите полезные привычки',
                                          style: TextStyle(
                                              fontSize: AppFont.smaller,
                                              fontWeight: FontWeight.normal),
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
                                                  style:
                                                      AppFont.regularSemibold,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                    padding: const EdgeInsets.only(
                                        top: 15,
                                        bottom: 15,
                                        left: 18,
                                        right: 18),
                                    decoration:
                                        AppLayout.boxDecorationOpacityShadowBG,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Выбрать новое дело',
                                          style: TextStyle(
                                              fontSize: AppFont.large,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Вперед, к новым достижениям!',
                                          style: TextStyle(
                                              fontSize: AppFont.smaller,
                                              fontWeight: FontWeight.normal),
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
                                                  style:
                                                      AppFont.regularSemibold,
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
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 15, left: 18, right: 18),
                                  decoration: AppLayout.boxDecorationShadowBG,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Для глубокого продвижения в тему развития рекомендуем книгу «Тренажер для Я» и другие ресурсы –  смотрите',
                                        style: TextStyle(
                                            color: AppColor.grey3,
                                            fontSize: AppFont.regular),
                                      ),
                                      Text(
                                        'Дополнительное',
                                        style: TextStyle(
                                            color: AppColor.accent,
                                            fontSize: AppFont.regular),
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
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
