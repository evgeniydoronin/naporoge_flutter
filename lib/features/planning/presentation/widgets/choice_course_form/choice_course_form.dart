import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isar/isar.dart';
import 'package:naporoge/features/planning/domain/entities/stream_entity.dart';

import '../../../../../core/constants/app_theme.dart';
import '../../../../../core/data/models/course_model.dart';
import '../../../../../core/routes/app_router.dart';
import '../../../../../core/services/controllers/service_locator.dart';
import '../../../../../core/services/db_client/isar_service.dart';
import '../../../../../core/utils/circular_loading.dart';
import '../../../data/sources/local/stream_local_storage.dart';
import '../../bloc/active_course/active_stream_bloc.dart';
import '../../bloc/choice_of_course/choice_of_course_bloc.dart';
import '../../bloc/planner_bloc.dart';
import '../../stream_controller.dart';

class ChoiceCourseFormWidget extends StatefulWidget {
  const ChoiceCourseFormWidget({super.key});

  @override
  State<ChoiceCourseFormWidget> createState() => _ChoiceCourseFormWidgetState();
}

class _ChoiceCourseFormWidgetState extends State<ChoiceCourseFormWidget> {
  final _streamController = getIt<StreamController>();
  final isarService = IsarService();
  final streamLocalStorage = StreamLocalStorage();
  final _formKey = GlobalKey<FormState>();
  final List _textEditingControllers = List<TextEditingController>.generate(5, (index) => TextEditingController());
  final List<Course> _courses = Course.generateDeal();

  @override
  Widget build(BuildContext context) {
    /// получаем активный стрим
    NPStream? npStream = context.read<ActiveStreamBloc>().state.npStream;

    return BlocConsumer<ChoiceOfCourseBloc, ChoiceOfCourseState>(
      listener: (context, state) {},
      builder: (context, state) {
        bool isActivated = state.text.isNotEmpty && state.selectedIndex != -1 ?? false;
        int selectedIndex = state.selectedIndex;

        return Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                ListView.builder(
                  key: Key(selectedIndex.toString()),
                  padding: const EdgeInsets.only(bottom: 25.0),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _courses.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: AppLayout.boxDecorationShadowBG,
                      margin: const EdgeInsets.only(bottom: 15),
                      child: Column(
                        children: <Widget>[
                          Theme(
                            data: ThemeData().copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              key: Key(index.toString()),
                              initiallyExpanded: index == selectedIndex,
                              title: Text(
                                _courses[index].title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              tilePadding: const EdgeInsets.all(5),
                              childrenPadding: const EdgeInsets.all(20),
                              leading: Container(
                                width: 50,
                                padding: const EdgeInsets.only(left: 15),
                                child: SvgPicture.asset(
                                  _courses[index].iconUrl,
                                ),
                              ),
                              trailing: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: SvgPicture.asset(
                                  'assets/icons/arrow_deal_down.svg',
                                ),
                              ),
                              onExpansionChanged: ((newState) async {
                                if (newState) {
                                  if (context.mounted) {
                                    context.read<ChoiceOfCourseBloc>().add(
                                          CourseItemChanged(
                                            selectedIndex: index,
                                            text: _textEditingControllers[index].text,
                                            courseId: _courses[index].courseId,
                                          ),
                                        );

                                    /// обновляем данные курса
                                    context.read<PlannerBloc>().add(StreamCourseIdChanged(_courses[index].courseId));
                                    context
                                        .read<PlannerBloc>()
                                        .add(StreamCourseTitleChanged(_textEditingControllers[index].text));

                                    // добавляем заголовок дела, если оно создано
                                    if (npStream != null) {
                                      if (_courses[index].courseId == npStream.courseId) {
                                        _textEditingControllers[index].text = npStream.title;

                                        context.read<ChoiceOfCourseBloc>().add(
                                              CourseItemChanged(
                                                selectedIndex: index,
                                                text: _textEditingControllers[index].text,
                                                courseId: _courses[index].courseId,
                                              ),
                                            );
                                      }
                                    }
                                  }
                                } else {
                                  context.read<ChoiceOfCourseBloc>().add(const CourseItemChanged(selectedIndex: -1));
                                }
                              }),
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      _courses[index].description,
                                      style: const TextStyle(height: 1.5),
                                    ),
                                    const SizedBox(height: 30),
                                    TextFormField(
                                      controller: _textEditingControllers[index],
                                      onChanged: (title) {
                                        context
                                            .read<PlannerBloc>()
                                            .add(StreamCourseIdChanged(_courses[index].courseId));
                                        context.read<PlannerBloc>().add(StreamCourseTitleChanged(title));

                                        /// активируем кнопку
                                        context.read<ChoiceOfCourseBloc>().add(CourseItemChanged(
                                            selectedIndex: index,
                                            text: _textEditingControllers[index].text,
                                            courseId: _courses[index].courseId));
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Краткое название дела',
                                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                                        labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                                        fillColor: AppColor.grey1,
                                        filled: true,
                                        errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Colors.redAccent),
                                            borderRadius: AppLayout.smallRadius),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Colors.transparent),
                                            borderRadius: AppLayout.smallRadius),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Colors.transparent),
                                            borderRadius: AppLayout.smallRadius),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: AppLayout.primaryRadius)),
                  onPressed: isActivated
                      ? () async {
                          // print('state 22: $state');
                          // print('state 33: ${context.read<PlannerBloc>().state}');
                          // Find all courses
                          var allStream = await streamLocalStorage.getAllStreams();

                          /// создаем первый курс курс
                          if (allStream.isEmpty) {
                            if (context.mounted) {
                              var plannerBlocState = context.read<PlannerBloc>().state;

                              /// create stream
                              await createStream(plannerBlocState);

                              /// add stream to state
                              final isar = await isarService.db;
                              final NPStream? stream = await isar.nPStreams.filter().isActiveEqualTo(true).findFirst();
                              if (context.mounted) {
                                if (stream != null) {
                                  context.read<ActiveStreamBloc>().add(ActiveStreamChanged(npStream: stream));
                                }
                              }
                            }
                          }

                          /// Если курсы созданы
                          else {
                            print('Если курс создан');
                            List allStreams = await streamLocalStorage.getAllStreams();
                            NPStream? activeStream = await streamLocalStorage.getActiveStream();

                            /// Когда дело прекращено Досрочно и нет активного курса
                            if (activeStream == null) {
                              if (context.mounted) {
                                var plannerBlocState = context.read<PlannerBloc>().state;

                                /// create stream
                                await createStream(plannerBlocState);
                              }
                            }

                            /// Обновление или создание дела
                            /// Когда у старого дела дата старта уже прошла
                            else {
                              /// Создание
                              if (activeStream.startAt!.isBefore(DateTime.now())) {
                                print('Создание нового дела, Когда у старого дела дата старта уже прошла');
                                if (context.mounted) {
                                  var plannerBlocState = context.read<PlannerBloc>().state;

                                  /// create stream
                                  await createStream(plannerBlocState);
                                }
                              }

                              /// Обновление
                              else if (activeStream.startAt!.isAfter(DateTime.now())) {
                                print('Обновление текущего дела');
                                if (context.mounted) {
                                  var plannerBlocState = context.read<PlannerBloc>().state;

                                  /// update stream
                                  await updateStream(plannerBlocState, activeStream);
                                }
                              }
                            }
                          }

                          // // Если курс создавался
                          // if (_stream != null) {
                          //   print('Если курс создавался Обновляем');
                          //   // Обновляем
                          //   final NPStream stream = _stream;
                          //
                          //   // print(state.courseTitle);
                          //   // print(state.startDate);
                          //   // print(state.courseId);
                          //
                          //   if (context.mounted) {
                          //     CircularLoading(context).startLoading();
                          //   }
                          //   // обновляем первую неделю курса
                          //   Map streamData = {
                          //     "stream_id": stream.id,
                          //     "start_at": state.startDate,
                          //     "title": state.courseTitle,
                          //     "course_id": state.courseId,
                          //   };
                          //
                          //   print('streamData: $streamData');
                          //
                          //   // update on server
                          //   var updatedStream = await _streamController.updateStream(streamData);
                          //
                          //   // print('newStream: $updatedStream');
                          //
                          //   // update local
                          //   if (updatedStream['stream']['id'] != null) {
                          //     print('newStream: $updatedStream');
                          //     streamLocalStorage.updateStream(updatedStream);
                          //     if (context.mounted) {
                          //       CircularLoading(context).stopLoading();
                          //       context.router.push(const SelectDayPeriodRoute());
                          //     }
                          //   }
                          // } else {
                          //   // Сохраняем
                          //   // Сохранение дела без подробного описания
                          //   // после сохранения переход на следующий шаг
                          //   if (context.mounted) {
                          //     CircularLoading(context).startLoading();
                          //     var user = await isarService.getUser();
                          //
                          //     Map streamData = {
                          //       "user_id": user.first.id,
                          //       "start_at": state.startDate,
                          //       "weeks": 3,
                          //       "is_active": true,
                          //       "course_id": state.courseId,
                          //       "title": state.courseTitle,
                          //       "description": '',
                          //       "cells": [],
                          //     };
                          //
                          //     // print('streamData: $streamData');
                          //
                          //     // create on server
                          //     var newStream = await _streamController.createStream(streamData);
                          //
                          //     // print('newStream: $newStream');
                          //
                          //     // create local
                          //     if (newStream['stream']['id'] != null) {
                          //       streamLocalStorage.createStream(newStream);
                          //       if (context.mounted) {
                          //         CircularLoading(context).stopLoading();
                          //         context.router.push(const SelectDayPeriodRoute());
                          //       }
                          //     }
                          //   }
                          // }
                        }
                      : null,
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Выбрать',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Create stream
  Future createStream(state) async {
    if (context.mounted) {
      CircularLoading(context).startLoading();
      var user = await isarService.getUser();

      Map streamData = {
        "user_id": user.first.id,
        "start_at": state.startDate,
        "weeks": state.courseWeeks,
        "is_active": true,
        "course_id": state.courseId,
        "title": state.courseTitle,
        "description": '',
        "cells": [],
      };

      // print('streamData: $streamData');

      // create on server
      var newStream = await _streamController.createStream(streamData);

      // print('newStream: $newStream');

      // create local
      if (newStream['stream']['id'] != null) {
        streamLocalStorage.createStream(newStream);
      }

      if (context.mounted) {
        CircularLoading(context).stopLoading();
        context.router.push(const SelectDayPeriodRoute());
      }
    }
  }

  /// Update stream
  Future updateStream(state, stream) async {
    if (context.mounted) {
      CircularLoading(context).startLoading();
      var user = await isarService.getUser();

      // обновляем первую неделю курса
      Map streamData = {
        "stream_id": stream.id,
        "start_at": state.startDate,
        "title": state.courseTitle,
        "course_id": state.courseId,
      };

      // update on server
      var updatedStream = await _streamController.updateStream(streamData);

      // update local
      if (updatedStream['stream']['id'] != null) {
        streamLocalStorage.updateStream(updatedStream);
      }

      if (context.mounted) {
        CircularLoading(context).stopLoading();
        context.router.push(const SelectDayPeriodRoute());
      }
    }
  }
}
