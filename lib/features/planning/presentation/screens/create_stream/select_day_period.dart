import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/get_week_number.dart';
import '../../../domain/entities/stream_entity.dart';
import '../../../../../core/routes/app_router.dart';
import '../../../../../core/services/controllers/service_locator.dart';
import '../../../../../core/services/db_client/isar_service.dart';
import '../../../../../core/utils/circular_loading.dart';
import '../../../data/sources/local/stream_local_storage.dart';
import '../../bloc/active_course/active_stream_bloc.dart';
import '../../bloc/choice_of_course/choice_of_course_bloc.dart';
import '../../bloc/planner_bloc.dart';
import '../../stream_controller.dart';
import '../../widgets/day_schedule_widget.dart';
import '../../../../../core/constants/app_theme.dart';
import '../../widgets/stepper_widget.dart';

@RoutePage()
class SelectDayPeriod extends StatefulWidget {
  const SelectDayPeriod({Key? key}) : super(key: key);

  @override
  State<SelectDayPeriod> createState() => _SelectDayPeriodState();
}

class _SelectDayPeriodState extends State<SelectDayPeriod> {
  // late final AppLifecycleListener _appLifecycleListener;
  final _streamController = getIt<StreamController>();
  late final Future _getStream;
  FocusNode courseDescriptionFocusNode = FocusNode();

  @override
  void initState() {
    _getStream = getActiveStream();
    // Initialize the AppLifecycleListener class and pass callbacks
    // _appLifecycleListener = AppLifecycleListener(
    //   onStateChange: _onStateChanged,
    // );
    super.initState();
  }

  @override
  void dispose() {
    courseDescriptionFocusNode.dispose();
    // Do not forget to dispose the listener
    // _appLifecycleListener.dispose();
    super.dispose();
  }

  //
  // // Listen to the app lifecycle state changes
  // void _onStateChanged(AppLifecycleState state) {
  //   switch (state) {
  //     case AppLifecycleState.detached:
  //       _onDetached();
  //     case AppLifecycleState.resumed:
  //       _onResumed();
  //     case AppLifecycleState.inactive:
  //       _onInactive();
  //     case AppLifecycleState.hidden:
  //       _onHidden();
  //     case AppLifecycleState.paused:
  //       _onPaused();
  //   }
  // }
  //
  // void _onDetached() => print('detached');
  //
  // void _onResumed() => context.router.replace(const SplashScreenRoute());
  //
  // void _onInactive() => context.router.replace(const SplashScreenRoute());
  //
  // void _onHidden() => print('hidden');
  //
  // void _onPaused() => print('paused');

  Future getActiveStream() async {
    final storage = StreamLocalStorage();
    return await storage.getActiveStream();
  }

  @override
  Widget build(BuildContext context) {
    String courseDescription = '';
    final isarService = IsarService();
    final streamLocalStorage = StreamLocalStorage();
    final _formKey = GlobalKey<FormState>();
    TextEditingController _courseDescription = TextEditingController();

    return BlocConsumer<PlannerBloc, PlannerState>(
      listener: (context, state) {},
      builder: (context, state) {
        context.read<PlannerBloc>().add(FinalCellForCreateStream(finalCellIDs: cells));

        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: AppColor.lightBG,
            appBar: AppBar(
              foregroundColor: Colors.black,
              backgroundColor: AppColor.lightBG,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  context.read<ActiveStreamBloc>().add(const GetActiveStream());

                  /// скрываем дела по умолчанию
                  context.read<ChoiceOfCourseBloc>().add(const CourseItemChanged(selectedIndex: -1));
                  context.router.navigate(const ChoiceOfCaseScreenRoute());
                },
                icon: RotatedBox(quarterTurns: 2, child: SvgPicture.asset('assets/icons/arrow.svg')),
              ),
              title: Text(
                'Планирование',
                style: AppFont.scaffoldTitleDark,
              ),
              actions: [
                IconButton(
                  padding: const EdgeInsets.only(right: 9),
                  icon: const Icon(Icons.info_outline_rounded),
                  color: AppColor.accent,
                  onPressed: () {
                    // _scaffoldKey.currentState!.openEndDrawer();
                    context.router.push(const ExplanationsForThePlanningRoute());
                  },
                ),
              ],
            ),
            body: FutureBuilder(
              future: _getStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  NPStream stream = snapshot.data;

                  // print('stream description: ${stream.description}');

                  // _courseDescription = TextEditingController(text: stream.description);

                  return ListView(
                    shrinkWrap: true,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const StepperIcons(step: 2),
                            const SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: AppLayout.contentPadding),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColor.accentBOW,
                                  borderRadius: AppLayout.primaryRadius,
                                ),
                                child: ClipRRect(
                                  borderRadius: AppLayout.primaryRadius,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: -20,
                                        right: -60,
                                        child: Image.asset(
                                          'assets/images/19.png',
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 80),
                                        child: Text(
                                          'Не забудьте определить объем выполнения и цель дела',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: AppFont.regular,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: AppLayout.contentPadding),
                              child: Container(
                                width: double.maxFinite,
                                padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
                                decoration: AppLayout.boxDecorationShadowBG,
                                child: Text(
                                  state.courseTitle.isNotEmpty ? state.courseTitle : stream.title!,
                                  style: TextStyle(
                                      color: AppColor.accentBOW, fontSize: AppFont.large, fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: AppLayout.contentPadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Моя задача:'),
                                  const SizedBox(height: 5),
                                  TextFormField(
                                    textCapitalization: TextCapitalization.sentences,
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        courseDescriptionFocusNode.requestFocus();
                                        return 'Заполните обязательное поле!';
                                      }
                                      return null;
                                    },
                                    onChanged: (description) {
                                      context.read<PlannerBloc>().add(StreamCourseDescriptionChanged(description));
                                    },
                                    focusNode: courseDescriptionFocusNode,
                                    maxLines: 2,
                                    maxLength: 200,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(10),
                                      hintText: 'Укажите объем выполнения и цель дела',
                                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                                      labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                                      fillColor: Colors.white,
                                      filled: true,
                                      errorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Colors.redAccent),
                                          borderRadius: AppLayout.primaryRadius),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Colors.transparent),
                                          borderRadius: AppLayout.primaryRadius),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Colors.transparent),
                                          borderRadius: AppLayout.primaryRadius),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: AppLayout.contentPadding),
                              child: Container(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  decoration: AppLayout.boxDecorationShadowBG,
                                  child: DayScheduleWidget(
                                    stream: stream,
                                  )),
                            ),
                            const SizedBox(height: 25),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: AppLayout.contentPadding),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          // выбраны НЕ все дни
                                          if (state.finalCellIDs.length < 7) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                  content: Text('Запланируйте 6 дней'),
                                                  duration: Duration(seconds: 2)));
                                            }
                                          }
                                          // выбраны все дни
                                          else {
                                            if (context.mounted) {
                                              CircularLoading(context).startLoading();
                                            }
                                            // обновляем первую неделю курса
                                            Map streamData = {
                                              "stream_id": stream.id,
                                              "description": state.courseDescription.isNotEmpty
                                                  ? state.courseDescription
                                                  : stream.description,
                                            };

                                            // print('weekData: ${jsonEncode(weekData)}');

                                            // update on server
                                            // update stream
                                            var updatedStream = await _streamController.updateStream(streamData);

                                            // create week
                                            int year = DateTime.now().year;
                                            int wNum = getWeekNumber(stream.startAt);

                                            // меняем номер недели на 1,
                                            // если на стыке года
                                            if (wNum == 1) {
                                              year++;
                                            }
                                            Map weekData = {
                                              "streamId": stream.id,
                                              "cells": state.finalCellIDs,
                                              "monday": stream.startAt.toString(),
                                              "weekOfYear": wNum,
                                              "year": year,
                                            };

                                            // print('weekData: $weekData');

                                            var createWeek = await _streamController.createWeek(weekData);
                                            // //
                                            // print('createWeek: $createWeek');
                                            // print('updatedStream: $updatedStream');

                                            // update local
                                            if (updatedStream['stream']['id'] != null) {
                                              // print('newStream: $updatedStream');

                                              streamLocalStorage.updateStream(updatedStream);

                                              streamLocalStorage.createWeek(createWeek);
                                              if (context.mounted) {
                                                CircularLoading(context).stopLoading();
                                                context.replaceRoute(const DashboardScreenRoute());
                                              }
                                            }
                                          }
                                        }
                                      },
                                      style: AppLayout.confirmBtnFullWidth,
                                      child: Text(
                                        'План мне подходит',
                                        style: AppFont.largeSemibold,
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
                  );
                }

                // while waiting for data to arrive, show a spinning indicator
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        );
      },
    );
  }
}
