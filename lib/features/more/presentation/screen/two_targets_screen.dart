import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_theme.dart';

@RoutePage()
class TwoTargetScreen extends StatefulWidget {
  const TwoTargetScreen({super.key});

  @override
  State<TwoTargetScreen> createState() => _TwoTargetScreenState();
}

class _TwoTargetScreenState extends State<TwoTargetScreen> {
  final _formKey = GlobalKey<FormState>();

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
          'Две цели дела',
          style: AppFont.scaffoldTitleDark,
        ),
      ),
      body: ListView(
        children: [
          Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
                      decoration: AppLayout.boxDecorationShadowBG,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Дело',
                            style: AppFont.formLabel,
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            onChanged: (val) {
                              // context.read<DayResultBloc>().add(ResultOfTheDayChanged(val));
                            },
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Заполните обязательное поле!';
                              }
                              return null;
                            },
                            style: TextStyle(fontSize: AppFont.small),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColor.grey1,
                              hintText: 'Развивающее дело',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                              isDense: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: AppLayout.smallRadius,
                                borderSide: BorderSide(width: 1, color: AppColor.grey1),
                              ),
                            ),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Минимум для разового выполнения дела:',
                                  style: AppFont.formLabel,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            onChanged: (val) {
                              // context.read<DayResultBloc>().add(ResultOfTheDayChanged(val));
                            },
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Заполните обязательное поле!';
                              }
                              return null;
                            },
                            style: TextStyle(fontSize: AppFont.small),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColor.grey1,
                              hintText: 'Например, 10 отжиманий, 5 страниц, 2 км',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                              isDense: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: AppLayout.smallRadius,
                                borderSide: BorderSide(width: 1, color: AppColor.grey1),
                              ),
                            ),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Цель 1. «Внешняя»',
                                  style: AppFont.formLabel,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            onChanged: (val) {
                              // context.read<DayResultBloc>().add(ResultOfTheDayChanged(val));
                            },
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Заполните обязательное поле!';
                              }
                              return null;
                            },
                            style: TextStyle(fontSize: AppFont.small),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColor.grey1,
                              hintText: 'Укажите одну цель, основную',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                              isDense: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: AppLayout.smallRadius,
                                borderSide: BorderSide(width: 1, color: AppColor.grey1),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            onChanged: (val) {
                              // context.read<DayResultBloc>().add(ResultOfTheDayChanged(val));
                            },
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Заполните обязательное поле!';
                              }
                              return null;
                            },
                            style: TextStyle(fontSize: AppFont.small),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColor.grey1,
                              hintText: 'Количествоенное выражение, например, 5 кг',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                              isDense: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: AppLayout.smallRadius,
                                borderSide: BorderSide(width: 1, color: AppColor.grey1),
                              ),
                            ),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Цель 2. «Внутренняя»',
                                  style: AppFont.formLabel,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            onChanged: (val) {
                              // context.read<DayResultBloc>().add(ResultOfTheDayChanged(val));
                            },
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Заполните обязательное поле!';
                              }
                              return null;
                            },
                            style: TextStyle(fontSize: AppFont.small),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColor.grey1,
                              hintText: 'Укажите одно или максимум два качества',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                              isDense: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: AppLayout.smallRadius,
                                borderSide: BorderSide(width: 1, color: AppColor.grey1),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            onChanged: (val) {
                              // context.read<DayResultBloc>().add(ResultOfTheDayChanged(val));
                            },
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Заполните обязательное поле!';
                              }
                              return null;
                            },
                            style: TextStyle(fontSize: AppFont.small),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColor.grey1,
                              hintText: 'Признаки внутренних изменений',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                              isDense: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: AppLayout.smallRadius,
                                borderSide: BorderSide(width: 1, color: AppColor.grey1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              // // проверка удалось порадоваться
                              // Map rejoiceData = await getRejoiceBox();
                              // if (rejoiceData['required']) {
                              //   if (state.rejoice == null || state.rejoice!.isEmpty) {
                              //     setState(() {
                              //       isRejoice = true;
                              //     });
                              //   } else {
                              //     setState(() {
                              //       isRejoice = false;
                              //     });
                              //   }
                              // }
                              //
                              // // проверка желаний и нежеланий
                              // if (state.desires == null || state.desires!.isEmpty) {
                              //   setState(() {
                              //     isDesires = true;
                              //   });
                              // } else {
                              //   setState(() {
                              //     isDesires = false;
                              //   });
                              // }
                              //
                              // if (state.reluctance == null || state.reluctance!.isEmpty) {
                              //   setState(() {
                              //     isReluctance = true;
                              //   });
                              // } else {
                              //   setState(() {
                              //     isReluctance = false;
                              //   });
                              // }

                              if (_formKey.currentState!.validate()) {
                                // защита от дурака
                                // if (state.desires == null || state.desires!.isEmpty) {
                                //   setState(() {
                                //     isDesires = true;
                                //   });
                                //   return;
                                // } else {
                                //   setState(() {
                                //     isDesires = false;
                                //   });
                                // }
                                // if (state.reluctance == null || state.reluctance!.isEmpty) {
                                //   setState(() {
                                //     isReluctance = true;
                                //   });
                                //   return;
                                // } else {
                                //   setState(() {
                                //     isReluctance = false;
                                //   });
                                // }
                                // if (rejoiceData['required']) {
                                //   if (state.rejoice == null || state.rejoice!.isEmpty) {
                                //     setState(() {
                                //       isRejoice = true;
                                //     });
                                //     return;
                                //   } else {
                                //     setState(() {
                                //       isRejoice = false;
                                //     });
                                //   }
                                // }
                                //
                                // if (state.desires != null ||
                                //     state.desires!.isNotEmpty && state.reluctance != null ||
                                //     state.reluctance!.isNotEmpty) {
                                //   // удалось порадоваться
                                //   if (rejoiceData['required']) {
                                //     if (state.rejoice == null || state.rejoice!.isEmpty) {
                                //       return;
                                //     }
                                //   }
                                //
                                //   // актуальный день студента
                                //   DateTime actualStudentDay = getActualStudentDay();
                                //
                                //   if (context.mounted) {
                                //     CircularLoading(context).startLoading();
                                //   }
                                //
                                //   final isar = await isarService.db;
                                //   var user = await isarService.getUser();
                                //
                                //   String currDay = DateFormat('y-MM-dd').format(
                                //       DateTime(actualStudentDay.year, actualStudentDay.month, actualStudentDay.day));
                                //
                                //   final weekNumber = getWeekNumber(actualStudentDay);
                                //   Week? currWeekData =
                                //   await isar.weeks.filter().weekNumberEqualTo(weekNumber).findFirst();
                                //
                                //   late int dayId;
                                //
                                //   // если неделя не пустая
                                //   if (currWeekData!.dayBacklink.first.startAt != null) {
                                //     for (Day day in currWeekData.dayBacklink) {
                                //       if (currDay == DateFormat('y-MM-dd').format(day.startAt!)) {
                                //         dayId = day.id!;
                                //       }
                                //     }
                                //   }
                                //   // пустая неделя
                                //   else {
                                //     List days = await isar.days.filter().weekIdEqualTo(currWeekData.id).findAll();
                                //     int freeDayIndex = actualStudentDay.weekday - 1;
                                //     Day freeDay = days[freeDayIndex];
                                //     dayId = freeDay.id!;
                                //   }
                                //
                                //   Map dayResultData = {
                                //     "user_id": user.first.id,
                                //     "day_id": dayId,
                                //     "completed_at": state.completedAt,
                                //     "execution_scope": state.executionScope,
                                //     "result": state.result,
                                //     "desires": state.desires,
                                //     "reluctance": state.reluctance,
                                //     "interference": state.interference,
                                //     "rejoice": state.rejoice,
                                //     "timeSend": DateTime.now().toLocal().toString(),
                                //   };
                                //
                                //   // print('dayResultData: $dayResultData');
                                //
                                //   // create on server
                                //   var newDayResult = await _streamController.createDayResult(dayResultData);
                                //
                                //   // проверка на антиперемотку
                                //   if (newDayResult['status'] == false) {
                                //     if (context.mounted) {
                                //       CircularLoading(context).stopLoading();
                                //       ScaffoldMessenger.of(context).showSnackBar(
                                //         const SnackBar(
                                //           content: Text('Установите верное время'),
                                //           duration: Duration(seconds: 2),
                                //         ),
                                //       );
                                //       return;
                                //     }
                                //   }
                                //
                                //   // save on local
                                //   await streamLocalStorage.saveDayResult(newDayResult);
                                //   // print(newDayResult);
                                //
                                //   if (context.mounted) {
                                //     CircularLoading(context).stopLoading();
                                //     context.router.replace(const HomesEmptyRouter());
                                //   }
                                // }
                              }
                            },
                            style: AppLayout.accentBTNStyle,
                            child: Text(
                              'Сохранить',
                              style: AppFont.regularSemibold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              )),
        ],
      ),
    );
  }
}
