import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/routes/app_router.dart';
import '../utils/get_main_diary_screen_data.dart';
import '../widgets/diaryCalendar.dart';

@RoutePage(name: 'DiaryEmptyRouter')
class DiaryEmptyRouterPage extends AutoRouter {}

@RoutePage()
class DiaryScreen extends StatelessWidget {
  const DiaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightBG,
      appBar: AppBar(
        backgroundColor: AppColor.lightBG,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Дневник',
          style: AppFont.scaffoldTitleDark,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.info_outline_rounded,
              color: AppColor.primary,
            ),
            color: Colors.black,
            onPressed: () {
              context.router.push(const DiaryRulesScreenRoute());
            },
          ),
        ],
      ),
      body: FutureBuilder(
          future: getMainDiaryData(DateTime.now()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // print('snapshot.data: ${snapshot.data}');

              return ListView(
                children: [
                  Text(
                    'Сегодня: ${DateFormat('dd MMMM, EEEE', 'ru_RU').format(DateTime.now())}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      // padding:
                      //     const EdgeInsets.only(top: 7, bottom: 7, left: 18, right: 18),
                      decoration: AppLayout.boxDecorationShadowBG,
                      child: Theme(
                        data: ThemeData().copyWith(
                          dividerColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          initiallyExpanded: true,
                          maintainState: true,
                          tilePadding: const EdgeInsets.only(top: 7, bottom: 7, left: 18, right: 18),
                          title: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Календарь',
                                    style: AppFont.scaffoldTitleDark,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Contents
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(
                                left: 5,
                                right: 5,
                              ),
                              child: DiaryCalendarBox(),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: AppLayout.boxDecorationShadowBG,
                      child: Theme(
                        data: ThemeData().copyWith(
                          dividerColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 18),
                          title: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Учет результатов',
                                    style: AppFont.scaffoldTitleDark,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Contents
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration:
                                        BoxDecoration(border: Border(top: BorderSide(width: 1, color: AppColor.grey1))),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 17),
                                decoration:
                                    BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: AppColor.grey1))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Фактическое время начала дела'),
                                    Text('16:20'),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 17),
                                decoration:
                                    BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: AppColor.grey1))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Объём выполнения'),
                                    Text('90%'),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 17),
                                decoration:
                                    BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: AppColor.grey1))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Результат дня',
                                      style: AppFont.formLabel,
                                    ),
                                    const SizedBox(height: 5),
                                    TextField(
                                      readOnly: true,
                                      style: TextStyle(fontSize: AppFont.small, color: Colors.red),
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: AppColor.grey1,
                                          hintText: '10 кругов',
                                          hintStyle: TextStyle(color: AppColor.accent),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                                          isDense: true,
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: AppLayout.smallRadius,
                                              borderSide: BorderSide(width: 1, color: AppColor.grey1))),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 17),
                                decoration:
                                    BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: AppColor.grey1))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Сила нежеланий'),
                                    Text('Средняя'),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 17),
                                decoration:
                                    BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: AppColor.grey1))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Иные помехи и трудности',
                                      style: AppFont.formLabel,
                                    ),
                                    const SizedBox(height: 5),
                                    TextField(
                                      readOnly: true,
                                      style: TextStyle(fontSize: AppFont.small, color: Colors.red),
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: AppColor.grey1,
                                          hintText: 'Много сахара',
                                          hintStyle: TextStyle(color: AppColor.accent),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                                          isDense: true,
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: AppLayout.smallRadius,
                                              borderSide: BorderSide(width: 1, color: AppColor.grey1))),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 17),
                                decoration:
                                    BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: AppColor.grey1))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Сила желаний'),
                                    Text('Большая'),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 17),
                                decoration:
                                    BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: AppColor.grey1))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Удалось порадоваться?'),
                                    SvgPicture.asset('assets/icons/342.svg'),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: AppLayout.boxDecorationShadowBG,
                      child: Theme(
                        data: ThemeData().copyWith(
                          dividerColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 18),
                          title: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Заметки',
                                    style: AppFont.scaffoldTitleDark,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Contents
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            top: BorderSide(width: 1, color: AppColor.grey1),
                                            bottom: BorderSide(width: 1, color: AppColor.grey1))),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '04.01.2023 / 13:24',
                                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: AppFont.smaller),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'С другой стороны сложившаяся структура организации обеспечивает широкому кругу (специалистов) участие в формировании существенных финансовых и административных условий. Разнообразный и богатый опыт начало повседневной работы по формированию н позиции',
                                          style: TextStyle(color: AppColor.blk),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Посмотреть все заметки',
                              style: TextStyle(
                                  color: AppColor.primary, fontSize: AppFont.small, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: AppLayout.boxDecorationShadowBGBorderNone,
                      child: TextFormField(
                        style: TextStyle(fontSize: AppFont.small, color: AppColor.grey3),
                        maxLines: 5,
                        autofocus: false,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColor.lightBGItem,
                            hintText: 'Написать заметку',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            isDense: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: AppLayout.primaryRadius,
                              borderSide: BorderSide(width: 1, color: AppColor.lightBGItem),
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: AppLayout.accentBTNStyle,
                      child: Text(
                        'Добавить заметку',
                        style: AppFont.regularSemibold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
