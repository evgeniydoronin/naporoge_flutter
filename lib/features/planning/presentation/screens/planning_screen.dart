import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../widgets/stream_description_form_widget.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/services/controllers/service_locator.dart';
import '../../../../core/utils/circular_loading.dart';
import '../../../../core/utils/get_week_number.dart';
import '../../../../core/utils/show_closeApp_dialog.dart';
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
  final _formKey = GlobalKey<FormState>();

  bool isActiveAfterSave = true;

  Future getActiveStream() async {
    final storage = StreamLocalStorage();
    return await storage.getActiveStream();
  }

  @override
  Widget build(BuildContext context) {
    // print('Planning Screen');
    bool isPlanningConfirmBtn = context.watch<PlannerBloc>().state.isPlanningConfirmBtn;

    String _description = '';

    return WillPopScope(
      onWillPop: () async {
        final closeApp = await showCloseAppDialog(context);
        return closeApp ?? false;
      },
      child: BlocConsumer<PlannerBloc, PlannerState>(
        listener: (context, state) {},
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              backgroundColor: AppColor.lightBG,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppColor.lightBG,
                elevation: 0,
                centerTitle: true,
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
                future: getActiveStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    NPStream stream = snapshot.data;

                    return ListView(
                      shrinkWrap: true,
                      children: [
                        const SizedBox(height: 15),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppLayout.contentPadding),
                          child: Container(
                            width: double.maxFinite,
                            padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
                            decoration: AppLayout.boxDecorationShadowBG,
                            child: Text(
                              stream.title!,
                              style:
                                  TextStyle(color: Colors.black, fontSize: AppFont.large, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const StreamDescriptionForm(),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: AppLayout.contentPadding),
                                child: Container(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    decoration: AppLayout.boxDecorationShadowBG,
                                    child: WeekPlanningWidget(stream: stream)),
                              ),
                              const SizedBox(height: 25),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: AppLayout.contentPadding),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: isPlanningConfirmBtn && isActiveAfterSave
                                          ? ElevatedButton(
                                              onPressed: () async {
                                                // print(
                                                //     'state: ${state.finalCellIDs.length}');
                                                if (state.finalCellIDs.length < 7) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      content: Text('Запланируйте 6 дней'),
                                                    ),
                                                  );
                                                  return;
                                                }
                                                // Validate returns true if the form is valid, or false otherwise.
                                                if (_formKey.currentState!.validate()) {
                                                  CircularLoading(context).startLoading();

                                                  Map newWeekData = {};
                                                  Map weekData = state.editableWeekData;
                                                  List selectedCells = state.finalCellIDs;

                                                  // print('weekData:: ${state.editableWeekData}');
                                                  // print('selectedCells: $selectedCells');

                                                  /////////////////////////////
                                                  // CREATE WEEK
                                                  // /////////////////////////////
                                                  if (state.editableWeekData['weekId'] == null) {
                                                    print('CREATE WEEK');
                                                    // скрываем кнопку от повторного создания недели
                                                    setState(() {
                                                      isActiveAfterSave = false;
                                                    });
                                                    newWeekData['streamId'] = stream.id;
                                                    newWeekData['cells'] = selectedCells;
                                                    newWeekData['monday'] = state.editableWeekData['monday'].toString();
                                                    newWeekData['weekOfYear'] =
                                                        getWeekNumber(state.editableWeekData['monday']);
                                                    newWeekData['year'] =
                                                        DateFormat('y').format(state.editableWeekData['monday']);

                                                    var createWeek = await _streamController.createWeek(newWeekData);

                                                    print('createWeek: $createWeek');

                                                    // update local
                                                    if (createWeek['week'] != null) {
                                                      streamLocalStorage.createWeek(createWeek);
                                                    }
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

                                                      // print('days after update: $days');
                                                    }
                                                  }

                                                  if (context.mounted) {
                                                    CircularLoading(context).stopLoading();
                                                    CircularLoading(context).saveSuccess();
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
            ),
          );
        },
      ),
    );
  }
}
