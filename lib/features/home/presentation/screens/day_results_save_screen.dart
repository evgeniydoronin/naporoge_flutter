import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:naporoge/features/home/presentation/bloc/home_screen/home_screen_bloc.dart';
import '../../../../core/utils/circular_loading.dart';
import '../../../../core/utils/get_status_stream.dart';
import '../../../planning/domain/entities/stream_entity.dart';
import '../../../../core/utils/get_week_number.dart';

import '../../../../core/constants/app_theme.dart';
import '../../../../core/services/controllers/service_locator.dart';
import '../../../../core/services/db_client/isar_service.dart';
import '../../../planning/data/sources/local/stream_local_storage.dart';
import '../../../planning/presentation/stream_controller.dart';
import '../bloc/save_day_result/day_result_bloc.dart';

@RoutePage()
class DayResultsSaveScreen extends StatefulWidget {
  const DayResultsSaveScreen({Key? key}) : super(key: key);

  @override
  State<DayResultsSaveScreen> createState() => _DayResultsSaveScreenState();
}

class _DayResultsSaveScreenState extends State<DayResultsSaveScreen> {
  final _streamController = getIt<StreamController>();

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
              icon: RotatedBox(
                  quarterTurns: 2,
                  child: SvgPicture.asset('assets/icons/arrow.svg')),
            ),
            title: Text(
              'Внесите результаты',
              style: AppFont.scaffoldTitleDark,
            ),
          ),
          body: ListView(
            children: [
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 15, bottom: 15, left: 18, right: 18),
                  decoration: AppLayout.boxDecorationShadowBG,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Время начала дела', style: AppFont.formLabel),
                      const SizedBox(height: 5),
                      GestureDetector(
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
                                        dateTimePickerTextStyle:
                                            TextStyle(fontSize: 26),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 230,
                                          child: CupertinoTimerPicker(
                                            mode: CupertinoTimerPickerMode.hm,
                                            minuteInterval: 5,
                                            initialTimerDuration: duration,
                                            // This is called when the user changes the timer's
                                            // duration.
                                            onTimerDurationChanged:
                                                (Duration newDuration) {
                                              // print(DateFormat('HH:mm').parse(
                                              //     newDuration.toString()));
                                              setState(
                                                  () => duration = newDuration);
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
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    child: const Text('Отменить'),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    child: const Text('Выбрать'),
                                    onPressed: () {
                                      DateTime now = DateTime.now();
                                      DateTime time = DateFormat('HH:mm')
                                          .parse(duration.toString());
                                      DateTime completedTime = DateTime(
                                          now.year,
                                          now.month,
                                          now.day,
                                          time.hour,
                                          time.minute);

                                      final formatter =
                                          DateFormat('yyyy-MM-dd HH:mm')
                                              .format(completedTime);

                                      context.read<DayResultBloc>().add(
                                          CompletedTimeChanged(
                                              formatter.toString()));

                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          width: double.maxFinite,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              color: AppColor.grey1,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(7))),
                          child: Text(
                            state.completedAt != null
                                ? DateFormat('HH:mm').format(DateTime.parse(
                                    state.completedAt.toString()))
                                : '',
                            style: TextStyle(
                                fontSize: AppFont.small,
                                color: Colors.black.withOpacity(0.7)),
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
                  padding: const EdgeInsets.only(
                      top: 15, bottom: 0, left: 18, right: 18),
                  decoration: AppLayout.boxDecorationShadowBG,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Объем выполнения', style: AppFont.formLabel),
                          Text(
                              state.executionScope != null
                                  ? state.executionScope.toString()
                                  : '0',
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
                  padding: const EdgeInsets.only(
                      top: 15, bottom: 15, left: 18, right: 18),
                  decoration: AppLayout.boxDecorationShadowBG,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Результат дня',
                        style: AppFont.formLabel,
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        onChanged: (val) {
                          context
                              .read<DayResultBloc>()
                              .add(ResultOfTheDayChanged(val));
                        },
                        style: TextStyle(fontSize: AppFont.small),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColor.grey1,
                          hintText: '10 кругов',
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 10),
                          isDense: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: AppLayout.smallRadius,
                            borderSide:
                                BorderSide(width: 1, color: AppColor.grey1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: WishBox(
                      title: 'Сила желаний',
                      category: 'desires',
                    )),
                    SizedBox(width: 20),
                    Flexible(
                        child: WishBox(
                      title: 'Сила нежеланий',
                      category: 'reluctance',
                    )),
                  ],
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
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 10),
                          isDense: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: AppLayout.smallRadius,
                            borderSide:
                                BorderSide(width: 1, color: AppColor.grey1),
                          ),
                        ),
                        onChanged: (val) {
                          context
                              .read<DayResultBloc>()
                              .add(InterferenceChanged(val));
                        },
                      ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Удалось порадоваться?',
                        style: AppFont.formLabel,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RotatedBox(
                            quarterTurns: 2,
                            child: IconButton(
                                onPressed: () {
                                  context
                                      .read<DayResultBloc>()
                                      .add(const RejoiceChanged('no'));
                                },
                                icon: SvgPicture.asset('assets/icons/342.svg')),
                          ),
                          IconButton(
                              onPressed: () {
                                context
                                    .read<DayResultBloc>()
                                    .add(const RejoiceChanged('yes'));
                              },
                              icon: SvgPicture.asset('assets/icons/342.svg')),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () async {
                    CircularLoading(context).startLoading();
                    final isar = await isarService.db;
                    var user = await isarService.getUser();

                    String currDay = DateFormat('y-MM-dd').format(DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day));

                    final weekNumber = getWeekNumber(DateTime.now());
                    final currWeekData = await isar.weeks
                        .filter()
                        .weekNumberEqualTo(weekNumber)
                        .findFirst();

                    late int dayId;

                    for (Day day in currWeekData!.dayBacklink) {
                      if (currDay ==
                          DateFormat('y-MM-dd').format(day.startAt!)) {
                        dayId = day.id!;
                      }
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
                    var newDayResult =
                        await _streamController.createDayResult(dayResultData);

                    await streamLocalStorage.saveDayResult(newDayResult);
                    // print(newDayResult);

                    final stream = await streamLocalStorage.getActiveStream();

                    if (context.mounted) {
                      context
                          .read<HomeScreenBloc>()
                          .add(StreamProgressChanged(getStreamStatus(stream)));

                      CircularLoading(context).stopLoading();
                      context.router.pop();
                    }
                    // context.router.push(const ResultsStreamScreenRoute());
                  },
                  // style: AppLayout.accentBowBTNStyle,
                  child: Text(
                    'Сохранить',
                    style: AppFont.regularSemibold,
                  ),
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
        );
      },
    );
  }
}

class SliderBox extends StatefulWidget {
  const SliderBox({Key? key}) : super(key: key);

  @override
  State<SliderBox> createState() => _SliderBoxState();
}

class _SliderBoxState extends State<SliderBox> {
  double _currentSliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackShape: CustomTrackShape(),
      ),
      child: Slider(
        value: _currentSliderValue,
        max: 100,
        onChanged: (double value) {
          context
              .read<DayResultBloc>()
              .add(ExecutionScopeChanged(value.toInt()));
          setState(() {
            _currentSliderValue = value;
          });
        },
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class WishBox extends StatefulWidget {
  final String title;
  final String category;

  const WishBox({Key? key, required this.title, required this.category})
      : super(key: key);

  @override
  State<WishBox> createState() => _WishBoxState();
}

class _WishBoxState extends State<WishBox> {
  List<Map> buttonStatus = [
    {'result': 'small', 'isActive': true},
    {'result': 'middle', 'isActive': false},
    {'result': 'large', 'isActive': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
      decoration: AppLayout.boxDecorationShadowBG,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            widget.title,
            style: AppFont.formLabel,
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...buttonStatus.map(
                (e) => GestureDetector(
                  onTap: () {
                    for (Map btn in buttonStatus) {
                      btn['isActive'] = false;
                    }
                    e['isActive'] = true;

                    if (widget.category == 'desires') {
                      context
                          .read<DayResultBloc>()
                          .add(DesiresChanged(e['result']));
                    } else if (widget.category == 'reluctance') {
                      context
                          .read<DayResultBloc>()
                          .add(ReluctanceChanged(e['result']));
                    }

                    setState(() {});
                  },
                  child: Container(
                    width: 33,
                    height: 33,
                    decoration: BoxDecoration(
                      color: e['isActive'] ? AppColor.accent : Colors.white,
                      border: e['isActive']
                          ? const Border()
                          : Border.all(color: AppColor.deep),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
