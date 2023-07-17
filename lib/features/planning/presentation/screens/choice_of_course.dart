import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../domain/entities/stream_entity.dart';
import '../stream_controller.dart';
import '../../../../core/services/controllers/service_locator.dart';
import '../../../../core/services/db_client/isar_service.dart';
import '../../../../core/utils/circular_loading.dart';
import '../../data/sources/local/stream_local_storage.dart';
import '../bloc/planner_bloc.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/data/models/course_model.dart';
import '../widgets/stepper_widget.dart';

@RoutePage()
class ChoiceOfCaseScreen extends StatefulWidget {
  const ChoiceOfCaseScreen({super.key});

  @override
  State<ChoiceOfCaseScreen> createState() => _ChoiceOfCaseScreenState();
}

class _ChoiceOfCaseScreenState extends State<ChoiceOfCaseScreen> {
  int? selected;
  bool _isActivated = false;
  final List<Course> _courses = Course.generateDeal();

  final _streamController = getIt<StreamController>();

  final Map<String, TextEditingController> _shortTitleController = {};

  String courseId = '';
  String courseTitle = '';

  @override
  void initState() {
    super.initState();

    for (var cases in _courses) {
      _shortTitleController[cases.title] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var cases in _courses) {
      _shortTitleController[cases.title]?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isarService = IsarService();
    final streamLocalStorage = StreamLocalStorage();

    final _formKey = GlobalKey<FormState>();

    return BlocConsumer<PlannerBloc, PlannerState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (context.read<PlannerBloc>().state.courseTitle.isNotEmpty) {
          _isActivated = true;
        } else {
          _isActivated = false;
        }
        return Scaffold(
          backgroundColor: AppColor.lightBG,
          appBar: AppBar(
              // automaticallyImplyLeading: false,
              centerTitle: true,
              elevation: 0,
              foregroundColor: Colors.black,
              backgroundColor: AppColor.lightBG,
              title: const Text('Выбрать дело')),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const StepperIcons(step: 1),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                      key: Key(selected.toString()),
                      //attention

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
                                data: ThemeData()
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  key: Key(index.toString()),
                                  initiallyExpanded: index == selected,
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
                                  onExpansionChanged: ((newState) {
                                    if (newState) {
                                      setState(() {
                                        // деактивируем все курсы
                                        for (int i = 0;
                                            i < _courses.length;
                                            i++) {
                                          _courses[i].isExpanded = false;
                                        }
                                        // setState(() {
                                        //   _isActivated = false;
                                        // });
                                        // print('_isActivated: $_isActivated');
                                        // активируем выбранный
                                        selected = index;
                                        _courses[index].isExpanded = newState;
                                        // _isActivated = false;
                                      });
                                    } else {
                                      setState(() {
                                        selected = -1;
                                        _isActivated = false;
                                      });
                                      context
                                          .read<PlannerBloc>()
                                          .add(StreamCourseTitleChanged(''));
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
                                          controller: _shortTitleController[
                                              _courses[index].courseId],
                                          onChanged: (title) {
                                            context.read<PlannerBloc>().add(
                                                StreamCourseIdChanged(
                                                    _courses[index].courseId));
                                            // print(title);
                                            context.read<PlannerBloc>().add(
                                                StreamCourseTitleChanged(
                                                    title));
                                          },
                                          decoration: InputDecoration(
                                            hintText: 'Краткое название дела',
                                            hintStyle: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
                                            labelStyle: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
                                            fillColor: AppColor.grey1,
                                            filled: true,
                                            errorBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.redAccent),
                                                borderRadius:
                                                    AppLayout.smallRadius),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.transparent),
                                                borderRadius:
                                                    AppLayout.smallRadius),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.transparent),
                                                borderRadius:
                                                    AppLayout.smallRadius),
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
                  ),
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: AppLayout.primaryRadius)),
                    onPressed: _isActivated
                        ? () async {
                            var _stream =
                                await streamLocalStorage.getActiveStream();
                            // Если курс создавался
                            if (_stream != null) {
                              // Обновляем
                              final NPStream stream = _stream;

                              // print(state.courseTitle);
                              // print(state.startDate);
                              // print(state.courseId);

                              if (context.mounted) {
                                CircularLoading(context).startLoading();
                              }
                              // обновляем первую неделю курса
                              Map streamData = {
                                "stream_id": stream.id,
                                "start_at": state.startDate,
                                "title": state.courseTitle,
                                "course_id": state.courseId,
                                "week_id": stream.weekBacklink.first.id,
                                "cells": [],
                              };

                              print('streamData: $streamData');

                              // update on server
                              var updatedStream = await _streamController
                                  .updateStream(streamData);

                              // print('newStream: $updatedStream');

                              // update local
                              if (updatedStream['stream']['id'] != null) {
                                print('newStream: $updatedStream');
                                streamLocalStorage.updateStream(updatedStream);
                                if (context.mounted) {
                                  CircularLoading(context).stopLoading();
                                  context.router.push(
                                      SelectDayPeriodRoute(isBackArrow: true));
                                }
                              }
                            } else {
                              // Сохраняем
                              // Сохранение дела без подробного описания
                              // после сохранения переход на следующий шаг
                              if (context.mounted) {
                                CircularLoading(context).startLoading();
                                var user = await isarService.getUser();

                                Map streamData = {
                                  "user_id": user.first.id,
                                  "start_at": state.startDate,
                                  "weeks": 3,
                                  "is_active": true,
                                  "course_id": state.courseId,
                                  "title": state.courseTitle,
                                  "description": '',
                                  "cells": [],
                                };

                                // print('streamData: $streamData');

                                // create on server
                                var newStream = await _streamController
                                    .createStream(streamData);

                                // print('newStream: $newStream');

                                // create local
                                if (newStream['stream']['id'] != null) {
                                  streamLocalStorage.saveStream(newStream);
                                  if (context.mounted) {
                                    CircularLoading(context).stopLoading();
                                    // context.router
                                    //     .replace(const DashboardScreenRoute());
                                    context.router.push(SelectDayPeriodRoute(
                                        isBackArrow: true));
                                  }
                                }
                              }
                            }
                          }
                        : null,
                    child: const Padding(
                      padding: const EdgeInsets.all(15.0),
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
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }
}
