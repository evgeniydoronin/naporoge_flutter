import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/controllers/service_locator.dart';
import '../../../../core/utils/circular_loading.dart';
import '../stream_controller.dart';
import '../widgets/week_planning_widget.dart';
import '../../../../core/constants/app_theme.dart';
import '../../data/sources/local/stream_local_storage.dart';
import '../../domain/entities/stream_entity.dart';
import '../bloc/planner_bloc.dart';

@RoutePage()
class PlanningScreen extends StatefulWidget {
  const PlanningScreen({Key? key}) : super(key: key);

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  final _streamController = getIt<StreamController>();
  final streamLocalStorage = StreamLocalStorage();

  late final Future _getStream;

  // late bool activeBtnPlanConfirm;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _getStream = getActiveStream();
    // activeBtnPlanConfirm = false;
    super.initState();
  }

  Future getActiveStream() async {
    final storage = StreamLocalStorage();
    return await storage.getActiveStream();
  }

  @override
  Widget build(BuildContext context) {
    print('Planning Screen');
    bool isPlanningConfirmBtn = context.watch<PlannerBloc>().state.isPlanningConfirmBtn;

    String _description = '';

    return BlocConsumer<PlannerBloc, PlannerState>(
      listener: (context, state) {},
      builder: (context, state) {
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

                // описание курса из БД по умолчанию
                TextEditingController descriptionEditingController =
                    TextEditingController(text: stream.description ?? '');

                // если были изменения описания курса - меняем данные
                descriptionEditingController.text = state.courseDescription.isEmpty
                    ? stream.description ?? ''
                    : context.read<PlannerBloc>().state.courseDescription;

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
                              padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
                              decoration: AppLayout.boxDecorationShadowBG,
                              child: Text(
                                stream.title!,
                                style: TextStyle(
                                    color: Colors.black, fontSize: AppFont.large, fontWeight: FontWeight.w500),
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
                                  // validator: (value) {
                                  //   if (value == null || value.trim().isEmpty) {
                                  //     return 'Заполните обязательное поле!';
                                  //   }
                                  //   return null;
                                  // },
                                  onChanged: (description) {
                                    _description = description;
                                  },
                                  onTapOutside: (val) {
                                    context.read<PlannerBloc>().add(StreamCourseDescriptionChanged(_description));
                                  },
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
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                                padding: const EdgeInsets.only(bottom: 5),
                                decoration: AppLayout.boxDecorationShadowBG,
                                child: WeekPlanningWidget(stream: stream)),
                          ),
                          const SizedBox(height: 25),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: isPlanningConfirmBtn
                                      ? ElevatedButton(
                                          onPressed: () async {
                                            // print(
                                            //     'state: ${state.finalCellIDs.length}');
                                            if (state.finalCellIDs.length < 7) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Нужно выбрать 6 дней'),
                                                ),
                                              );
                                              return;
                                            }
                                            // Validate returns true if the form is valid, or false otherwise.
                                            if (_formKey.currentState!.validate()) {
                                              // CircularLoading(context).startLoading();

                                              Map newWeekData = {};
                                              Map weekData = state.editableWeekData;
                                              List selectedCells = state.finalCellIDs;

                                              print('weekData:: ${state.editableWeekData}');
                                              print('selectedCells: $selectedCells');

                                              // /////////////////////////////
                                              // CREATE WEEK
                                              // /////////////////////////////
                                              if (state.editableWeekData['weekId'] == null) {
                                                print('CREATE WEEK');
                                                newWeekData['streamId'] = stream.id;
                                                newWeekData['cells'] = selectedCells;
                                                newWeekData['monday'] = state.editableWeekData['monday'].toString();
                                                newWeekData['weekOfYear'] = state.editableWeekData['weekOfYear'];

                                                var createWeek = await _streamController.createWeek(newWeekData);

                                                // update local
                                                if (createWeek['week'] != null) {
                                                  streamLocalStorage.createWeek(createWeek);

                                                  if (context.mounted) {
                                                    CircularLoading(context).stopLoading();
                                                  }
                                                }
                                                // print('createWeek: $createWeek');
                                              }
                                              // /////////////////////////////
                                              // UPDATE WEEK
                                              // /////////////////////////////
                                              else if (state.editableWeekData['weekId'] != null) {
                                                print('UPDATE WEEK: ${state.editableWeekData['weekId']}');
                                                // Неделя для обновления
                                                final weekForUpdate = stream.weekBacklink
                                                    .where((week) => week.id == weekData['weekId'])
                                                    .first;

                                                // Ячейки созданной недели
                                                List oldCells = jsonDecode(weekForUpdate.cells!);

                                                // print('oldCells: $oldCells');

                                                // Формируем новый список ячеек
                                                // с обновленными данными
                                                List newCells = [];

                                                for (Map oldCell in oldCells) {
                                                  for (Map selectedCell in selectedCells) {
                                                    if (oldCell['cellId'][2] == selectedCell['cellId'][2]) {
                                                      newCells.addAll([
                                                        {
                                                          'dayId': oldCell['dayId'],
                                                          'cellId': selectedCell['cellId'],
                                                          'startTime': selectedCell['startTime'],
                                                        }
                                                      ]);
                                                    }
                                                  }
                                                }

                                                newWeekData['week_id'] = weekForUpdate.id;
                                                // подтверждение сохранения от пользователя
                                                newWeekData['user_confirmed'] = true;
                                                newWeekData['cells'] = newCells;

                                                // print('newWeekData: $newWeekData');

                                                // update on server
                                                var updateWeek = await _streamController.updateWeek(newWeekData);

                                                // print('updateWeek: ${updateWeek['days']}');

                                                // update local
                                                if (updateWeek['week'] != null) {
                                                  var days = streamLocalStorage.updateWeek(updateWeek);

                                                  print('days after update: $days');
                                                  if (context.mounted) {
                                                    CircularLoading(context).stopLoading();
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
