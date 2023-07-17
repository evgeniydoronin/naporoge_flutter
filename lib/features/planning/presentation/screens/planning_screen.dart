import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/services/controllers/service_locator.dart';
import '../../../../core/services/db_client/isar_service.dart';
import '../../../../core/utils/circular_loading.dart';
import '../../../../core/utils/get_status_stream.dart';
import '../../../../core/utils/get_week_number.dart';
import '../../data/sources/local/stream_local_storage.dart';
import '../../domain/entities/stream_entity.dart';
import '../bloc/planner_bloc.dart';
import '../stream_controller.dart';
import '../widgets/day_schedule_stream_widget.dart';

@RoutePage()
class PlanningScreen extends StatefulWidget {
  const PlanningScreen({Key? key}) : super(key: key);

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  final _streamController = getIt<StreamController>();
  late final Future _getStream;
  late bool activeBtnPlanConfirm;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _getStream = getActiveStream();
    activeBtnPlanConfirm = false;
    super.initState();
  }

  Future getActiveStream() async {
    final storage = StreamLocalStorage();
    return await storage.getActiveStream();
  }

  @override
  Widget build(BuildContext context) {
    final isarService = IsarService();
    final streamLocalStorage = StreamLocalStorage();
    bool isActiveConfirmBtn = false;
    String _description = '';

    return BlocConsumer<PlannerBloc, PlannerState>(
      listener: (context, state) {},
      builder: (context, state) {
        context
            .watch<PlannerBloc>()
            .add(FinalCellForCreateStream(finalCellIDs: cells));

        return Scaffold(
          backgroundColor: AppColor.lightBG,
          appBar: AppBar(
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
                Map streamStatus = getStreamStatus(stream);

                // описание курса из БД по умолчанию
                TextEditingController descriptionEditingController =
                    TextEditingController(text: stream.description!);

                // если были изменения описания курса - меняем данные
                descriptionEditingController.text =
                    state.courseDescription.isEmpty
                        ? stream.description!
                        : context.read<PlannerBloc>().state.courseDescription;

                DateTime now = DateTime.now();
                // текущая неделя
                int weekNumber = getWeekNumber(DateTime.now());
                int daysBefore = stream.startAt!.difference(now).inDays;

                DateTime startStream = stream.startAt!;
                DateTime endStream = stream.startAt!.add(Duration(
                    days: (stream.weeks! * 7) - 1,
                    hours: 23,
                    minutes: 59,
                    seconds: 59));

                bool isBeforeStartStream = startStream.isAfter(now);
                bool isAfterEndStream = endStream.isBefore(now);

                // До старта курса
                if (isBeforeStartStream) {
                  isActiveConfirmBtn = true;
                }
                // После завершения курса
                else if (isAfterEndStream) {
                }
                // Во время прохождения курса
                else if (!isBeforeStartStream && !isAfterEndStream) {
                  isActiveConfirmBtn = true;
                }

                return ListView(
                  shrinkWrap: true,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              width: double.maxFinite,
                              padding: const EdgeInsets.only(
                                  top: 15, bottom: 15, left: 18, right: 18),
                              decoration: AppLayout.boxDecorationShadowBG,
                              child: Text(
                                stream.title!,
                                style: TextStyle(
                                    color: Colors.black,
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
                                  controller: descriptionEditingController,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Заполните обязательное поле!';
                                    }
                                    return null;
                                  },
                                  onChanged: (description) {
                                    _description = description;
                                  },
                                  onTapOutside: (val) {
                                    context.read<PlannerBloc>().add(
                                        StreamCourseDescriptionChanged(
                                            _description));
                                  },
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
                                padding: const EdgeInsets.only(bottom: 5),
                                decoration: AppLayout.boxDecorationShadowBG,
                                child: DayScheduleStreamWidget(stream: stream)),
                          ),
                          const SizedBox(height: 25),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: isActiveConfirmBtn
                                      ? ElevatedButton(
                                          onPressed: () async {
                                            if (cells.length < 7) {
                                              // If the form is valid, display a snackbar. In the real world,
                                              // you'd often call a server or save the information in a database.
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Нужно выбрать 6 дней'),
                                                ),
                                              );
                                              return;
                                            }
                                            // Validate returns true if the form is valid, or false otherwise.
                                            if (_formKey.currentState!
                                                .validate()) {
                                              // CircularLoading(context)
                                              //     .startLoading();

                                              print('state: $state');

                                              Map streamData = {};
                                              // Update week
                                              final int streamId = stream.id!;
                                              final Week firstWeek =
                                                  stream.weekBacklink.first;
                                              final int firstWeekId =
                                                  stream.weekBacklink.first.id!;

                                              // // До старта курса
                                              // if (isBeforeStartStream) {
                                              //   // обновляем первую неделю курса
                                              //   streamData = {
                                              //     "stream_id": streamId,
                                              //     "description": state
                                              //             .courseDescription
                                              //             .isNotEmpty
                                              //         ? state.courseDescription
                                              //         : stream.description,
                                              //     "week_id": firstWeekId,
                                              //     "cells": cells,
                                              //   };
                                              //
                                              //
                                              //   List newDaysData = [];
                                              //
                                              //   for (int i = 0;
                                              //       i < cells.length;
                                              //       i++) {
                                              //     int cellIndex =
                                              //         cells[i]['id'][2];
                                              //     var _day = firstWeek
                                              //         .dayBacklink.indexed
                                              //         .where((element) =>
                                              //             element.$1 ==
                                              //             cellIndex);
                                              //     Day day = _day.first.$2;
                                              //     // print(day.id);
                                              //     DateTime initialDate =
                                              //         DateTime.parse(DateFormat(
                                              //                 'y-MM-dd')
                                              //             .format(
                                              //                 day.startAt!));
                                              //
                                              //     String newCellTimeString = DateFormat(
                                              //             'y-MM-dd HH:mm')
                                              //         .format(DateTime(
                                              //             initialDate.year,
                                              //             initialDate.month,
                                              //             initialDate.day,
                                              //             int.parse((cells[i]
                                              //                     ['startTime'])
                                              //                 .split(':')[0]),
                                              //             int.parse((cells[i]
                                              //                     ['startTime'])
                                              //                 .split(':')[1])));
                                              //
                                              //     newDaysData.addAll([
                                              //       {
                                              //         'day_id': day.id,
                                              //         'start_at':
                                              //             newCellTimeString
                                              //       }
                                              //     ]);
                                              //   }
                                              //
                                              //   streamData['newDaysData'] =
                                              //       newDaysData;
                                              //
                                              //   // update on server
                                              //   var updateStream =
                                              //       await _streamController
                                              //           .updateStream(
                                              //               streamData);
                                              //
                                              //   // update local
                                              //   if (updateStream['stream']
                                              //           ['id'] !=
                                              //       null) {
                                              //     streamLocalStorage
                                              //         .updateStream(
                                              //             updateStream);
                                              //
                                              //     if (context.mounted) {
                                              //       CircularLoading(context)
                                              //           .stopLoading();
                                              //
                                              //       ScaffoldMessenger.of(
                                              //               context)
                                              //           .showSnackBar(
                                              //         const SnackBar(
                                              //           content: Text(
                                              //               'План успешно обновлен'),
                                              //         ),
                                              //       );
                                              //     }
                                              //   }
                                              //
                                              //   // print(
                                              //   //     'updateStream: $updateStream');
                                              // }
                                              // // После завершения курса
                                              // else if (isAfterEndStream) {
                                              //   // просмотр последней недели открыт по умолчанию
                                              //   // предыдущие можно пролистывать
                                              // }
                                              // // Во время прохождения курса
                                              // else if (!isBeforeStartStream &&
                                              //     !isAfterEndStream) {}
                                            }
                                          },
                                          style: AppLayout.accentBTNStyle,
                                          child: Text(
                                            'План мне подходит',
                                            style: AppFont.largeSemibold,
                                          ),
                                        )
                                      : const SizedBox(),
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
              return const Center(child: CircularProgressIndicator());
            },
          ),
        );
      },
    );
  }
}
