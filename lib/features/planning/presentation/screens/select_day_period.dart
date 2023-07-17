import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/stream_entity.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/services/controllers/service_locator.dart';
import '../../../../core/services/db_client/isar_service.dart';
import '../../../../core/utils/circular_loading.dart';
import '../../data/sources/local/stream_local_storage.dart';
import '../bloc/planner_bloc.dart';
import '../stream_controller.dart';
import '../widgets/day_schedule_widget.dart';
import '../../../../core/constants/app_theme.dart';
import '../widgets/stepper_widget.dart';

@RoutePage()
class SelectDayPeriod extends StatefulWidget {
  final bool isBackArrow;

  const SelectDayPeriod({Key? key, required this.isBackArrow})
      : super(key: key);

  @override
  State<SelectDayPeriod> createState() => _SelectDayPeriodState();
}

class _SelectDayPeriodState extends State<SelectDayPeriod> {
  final _streamController = getIt<StreamController>();
  late final Future _getStream;
  FocusNode courseDescriptionFocusNode = FocusNode();

  @override
  void initState() {
    _getStream = getActiveStream();
    super.initState();
  }

  @override
  void dispose() {
    courseDescriptionFocusNode.dispose();
    super.dispose();
  }

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

    return BlocConsumer<PlannerBloc, PlannerState>(
      listener: (context, state) {},
      builder: (context, state) {
        // print(state);
        context
            .read<PlannerBloc>()
            .add(FinalCellForCreateStream(finalCellIDs: cells));

        return Scaffold(
          backgroundColor: AppColor.lightBG,
          appBar: AppBar(
            automaticallyImplyLeading: widget.isBackArrow,
            foregroundColor: Colors.black,
            backgroundColor: AppColor.lightBG,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Планирование',
              style: AppFont.scaffoldTitleDark,
            ),
          ),
          body: FutureBuilder(
            future: _getStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                NPStream stream = snapshot.data;

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
                            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                      padding: const EdgeInsets.only(
                                          top: 15,
                                          bottom: 15,
                                          left: 15,
                                          right: 80),
                                      child: Text(
                                        'Старт курса – с понедельника. Выберите, с какого начнете',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: AppFont.regular),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              width: double.maxFinite,
                              padding: const EdgeInsets.only(
                                  top: 15, bottom: 15, left: 18, right: 18),
                              decoration: AppLayout.boxDecorationShadowBG,
                              child: Text(
                                state.courseTitle.isNotEmpty
                                    ? state.courseTitle
                                    : stream.title!,
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Моя задача:'),
                                const SizedBox(height: 5),
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      courseDescriptionFocusNode.requestFocus();
                                      return 'Заполните обязательное поле!';
                                    }
                                    return null;
                                  },
                                  onChanged: (description) {
                                    context.read<PlannerBloc>().add(
                                        StreamCourseDescriptionChanged(
                                            description));
                                  },
                                  focusNode: courseDescriptionFocusNode,
                                  maxLines: 2,
                                  maxLength: 200,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(10),
                                    hintText:
                                        'Укажите объем выполнения и цель дела',
                                    hintStyle: const TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                    labelStyle: const TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                    fillColor: Colors.white,
                                    filled: true,
                                    errorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.redAccent),
                                        borderRadius: AppLayout.primaryRadius),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.transparent),
                                        borderRadius: AppLayout.primaryRadius),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.transparent),
                                        borderRadius: AppLayout.primaryRadius),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                                padding: const EdgeInsets.only(bottom: 15),
                                decoration: AppLayout.boxDecorationShadowBG,
                                child: DayScheduleWidget(
                                  stream: stream,
                                )),
                          ),
                          const SizedBox(height: 25),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      // final storage = StreamLocalStorage();
                                      // NPStream stream =
                                      // await storage.getActiveStream();
                                      //  TODO: до старта курса пользователя перекидывать
                                      //  на экран 3-го шага создания дела

                                      if (_formKey.currentState!.validate()) {
                                        if (state.finalCellIDs.length < 7) {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'Нужно выбрать 6 дней!'),
                                                    duration:
                                                        Duration(seconds: 2)));
                                          }
                                        } else {
                                          if (context.mounted) {
                                            CircularLoading(context)
                                                .startLoading();
                                          }
                                          // обновляем первую неделю курса
                                          Map streamData = {
                                            "stream_id": stream.id,
                                            "description": state
                                                    .courseDescription
                                                    .isNotEmpty
                                                ? state.courseDescription
                                                : stream.description,
                                            "week_id":
                                                stream.weekBacklink.first.id,
                                            "cells": state.finalCellIDs,
                                          };

                                          // print('streamData: $streamData');

                                          // update on server
                                          var updatedStream =
                                              await _streamController
                                                  .updateStream(streamData);

                                          print('newStream: $updatedStream');

                                          // update local
                                          if (updatedStream['stream']['id'] !=
                                              null) {
                                            print('newStream: $updatedStream');
                                            streamLocalStorage
                                                .updateStream(updatedStream);
                                            if (context.mounted) {
                                              CircularLoading(context)
                                                  .stopLoading();
                                              context.router.replace(
                                                  const DashboardScreenRoute());
                                            }
                                          }
                                        }
                                      }
                                    },
                                    style: AppLayout.accentBTNStyle,
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
        );
      },
    );
  }
}
