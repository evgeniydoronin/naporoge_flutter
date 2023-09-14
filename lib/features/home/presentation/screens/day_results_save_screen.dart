import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import '../widgets/day_results_save/rejoice_box.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/utils/circular_loading.dart';
import '../../../planning/domain/entities/stream_entity.dart';
import '../../../../core/utils/get_week_number.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/services/controllers/service_locator.dart';
import '../../../../core/services/db_client/isar_service.dart';
import '../../../planning/data/sources/local/stream_local_storage.dart';
import '../../../planning/presentation/stream_controller.dart';
import '../bloc/save_day_result/day_result_bloc.dart';
import '../widgets/day_results_save/slider_box.dart';
import '../widgets/day_results_save/wish_box.dart';

@RoutePage()
class DayResultsSaveScreen extends StatefulWidget {
  const DayResultsSaveScreen({Key? key}) : super(key: key);

  @override
  State<DayResultsSaveScreen> createState() => _DayResultsSaveScreenState();
}

class _DayResultsSaveScreenState extends State<DayResultsSaveScreen> {
  final _streamController = getIt<StreamController>();
  final _formKey = GlobalKey<FormState>();
  final List<bool> _selections = List.generate(2, (_) => false);

  bool isDesires = false;
  bool isReluctance = false;

  @override
  Widget build(BuildContext context) {
    final isarService = IsarService();
    final streamLocalStorage = StreamLocalStorage();

    Duration duration = const Duration(hours: 0, minutes: 00);

    return BlocConsumer<DayResultBloc, DayResultState>(
      listener: (context, state) {},
      builder: (context, state) {
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
              'Внесите результаты',
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
                            Text('Время начала дела', style: AppFont.formLabel),
                            const SizedBox(height: 5),
                            Column(
                              children: [
                                TextFormField(
                                  readOnly: true,
                                  onTap: () async {
                                    showDialog<void>(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext ctx) {
                                        return AlertDialog(
                                          title: const Text('Выбрать время'),
                                          content: SizedBox(
                                            height: 150,
                                            child: CupertinoTheme(
                                              data: const CupertinoThemeData(
                                                textTheme: CupertinoTextThemeData(
                                                  dateTimePickerTextStyle: TextStyle(fontSize: 26),
                                                ),
                                              ),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 230,
                                                    child: CupertinoTimerPicker(
                                                      initialTimerDuration: duration,
                                                      mode: CupertinoTimerPickerMode.hm,
                                                      minuteInterval: 5,
                                                      onTimerDurationChanged: (Duration newDuration) {
                                                        Duration minMinutes = const Duration(hours: 3, minutes: 00);
                                                        Duration maxMinutes = const Duration(hours: 3, minutes: 59);
                                                        if (newDuration <= maxMinutes && newDuration >= minMinutes) {
                                                          setState(() => duration =
                                                              const Duration(hours: 4, minutes: 00, seconds: 00));
                                                        } else {
                                                          setState(() => duration = newDuration);
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.zero,
                                          insetPadding: EdgeInsets.zero,
                                          actions: <Widget>[
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                textStyle: Theme.of(context).textTheme.labelLarge,
                                              ),
                                              child: const Text('Отменить'),
                                              onPressed: () async {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                textStyle: Theme.of(context).textTheme.labelLarge,
                                              ),
                                              child: const Text('Выбрать'),
                                              onPressed: () {
                                                DateTime now = DateTime.now();
                                                DateTime time = DateFormat('HH:mm').parse(duration.toString());
                                                DateTime completedTime =
                                                    DateTime(now.year, now.month, now.day, time.hour, time.minute);

                                                final formatter = DateFormat('yyyy-MM-dd HH:mm').format(completedTime);

                                                context
                                                    .read<DayResultBloc>()
                                                    .add(CompletedTimeChanged(formatter.toString()));

                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Заполните обязательное поле!';
                                    }
                                    return null;
                                  },
                                  controller: TextEditingController(
                                      text: state.completedAt != null
                                          ? DateFormat('HH:mm').format(DateTime.parse(state.completedAt.toString()))
                                          : null),
                                  style: TextStyle(fontSize: AppFont.small),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColor.grey1,
                                    hintText: state.completedAt != null
                                        ? DateFormat('HH:mm').format(DateTime.parse(state.completedAt.toString()))
                                        : 'Выбрать время начала дня',
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
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.only(top: 15, bottom: 0, left: 18, right: 18),
                        decoration: AppLayout.boxDecorationShadowBG,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Объем выполнения', style: AppFont.formLabel),
                                Text(state.executionScope != null ? state.executionScope.toString() : '0',
                                    style: AppFont.formLabel),
                              ],
                            ),
                            const SizedBox(height: 5),
                            const SliderBox(),
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
                            Text(
                              'Результат дня',
                              style: AppFont.formLabel,
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              onChanged: (val) {
                                context.read<DayResultBloc>().add(ResultOfTheDayChanged(val));
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
                                hintText: '10 кругов',
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: WishBox(
                              title: 'Сила желаний',
                              category: 'desires',
                              status: isDesires,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Flexible(
                            child: WishBox(
                              title: 'Сила нежеланий',
                              category: 'reluctance',
                              status: isReluctance,
                            ),
                          ),
                        ],
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
                            Text(
                              'Иные помехи и трудности',
                              style: AppFont.formLabel,
                            ),
                            const SizedBox(height: 5),
                            TextField(
                              style: TextStyle(fontSize: AppFont.small),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColor.grey1,
                                hintText: 'Запишите все, что мешало выполнять дело',
                                contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                                isDense: true,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: AppLayout.smallRadius,
                                  borderSide: BorderSide(width: 1, color: AppColor.grey1),
                                ),
                              ),
                              onChanged: (val) {
                                context.read<DayResultBloc>().add(InterferenceChanged(val));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const RejoiceBox(),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                // проверка желаний и нежеланий
                                if (state.desires == null) {
                                  setState(() {
                                    isDesires = true;
                                  });
                                }
                                if (state.reluctance == null) {
                                  setState(() {
                                    isReluctance = true;
                                  });
                                }

                                if (_formKey.currentState!.validate()) {
                                  // защита от дурака
                                  if (state.desires == null) {
                                    setState(() {
                                      isDesires = true;
                                    });
                                  } else {
                                    setState(() {
                                      isDesires = false;
                                    });
                                  }
                                  print('state.desires: ${state.desires}');
                                  if (state.reluctance == null) {
                                    setState(() {
                                      isReluctance = true;
                                    });
                                  } else {
                                    setState(() {
                                      isReluctance = false;
                                    });
                                  }

                                  if (state.desires != null && state.reluctance != null) {
                                    DateTime now = DateTime.now();
                                    CircularLoading(context).startLoading();
                                    final isar = await isarService.db;
                                    var user = await isarService.getUser();

                                    String currDay = DateFormat('y-MM-dd').format(
                                        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));

                                    final weekNumber = getWeekNumber(DateTime.now());
                                    Week? currWeekData =
                                        await isar.weeks.filter().weekNumberEqualTo(weekNumber).findFirst();

                                    late int dayId;

                                    // если неделя не пустая
                                    if (currWeekData!.dayBacklink.first.startAt != null) {
                                      for (Day day in currWeekData.dayBacklink) {
                                        if (currDay == DateFormat('y-MM-dd').format(day.startAt!)) {
                                          dayId = day.id!;
                                        }
                                      }
                                    }
                                    // пустая неделя
                                    else {
                                      List days = await isar.days.filter().weekIdEqualTo(currWeekData.id).findAll();
                                      int freeDayIndex = now.weekday - 1;
                                      Day freeDay = days[freeDayIndex];
                                      dayId = freeDay.id!;
                                    }

                                    Map dayResultData = {
                                      "user_id": user.first.id,
                                      "day_id": dayId,
                                      "completed_at": state.completedAt,
                                      "execution_scope": state.executionScope,
                                      "result": state.result,
                                      "desires": state.desires,
                                      "reluctance": state.reluctance,
                                      "interference": state.interference,
                                      "rejoice": state.rejoice,
                                    };

                                    // print('dayResultData: $dayResultData');
                                    // create on server
                                    var newDayResult = await _streamController.createDayResult(dayResultData);

                                    // save on local
                                    await streamLocalStorage.saveDayResult(newDayResult);
                                    print(newDayResult);

                                    final stream = await streamLocalStorage.getActiveStream();

                                    if (context.mounted) {
                                      // context.read<HomeScreenBloc>().add(StreamProgressChanged(getStreamStatus(stream)));
                                      CircularLoading(context).stopLoading();
                                      context.router.replace(const HomesEmptyRouter());
                                    }
                                  }
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
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
