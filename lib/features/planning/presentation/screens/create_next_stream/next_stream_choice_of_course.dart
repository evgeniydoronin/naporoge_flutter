import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../domain/entities/stream_entity.dart';
import '../../bloc/choice_of_course/choice_of_course_bloc.dart';
import '../../stream_controller.dart';
import '../../../../../core/services/controllers/service_locator.dart';
import '../../../../../core/services/db_client/isar_service.dart';
import '../../../../../core/utils/circular_loading.dart';
import '../../../data/sources/local/stream_local_storage.dart';
import '../../bloc/planner_bloc.dart';
import '../../../../../core/constants/app_theme.dart';
import '../../../../../core/routes/app_router.dart';
import '../../../../../core/data/models/course_model.dart';
import '../../widgets/stepper_widget.dart';

@RoutePage()
class NextStreamChoiceOfCaseScreen extends StatelessWidget {
  const NextStreamChoiceOfCaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColor.lightBG,
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: AppColor.lightBG,
          title: Text(
            'Выбрать дело',
            style: AppFont.scaffoldTitleDark,
          ),
          leading: IconButton(
            onPressed: () {
              context.router.navigate(NextStreamStartDateSelectionScreenRoute(nextStreamWeeks: 3));
            },
            icon: RotatedBox(quarterTurns: 2, child: SvgPicture.asset('assets/icons/arrow.svg')),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline_rounded),
              color: Colors.black,
              onPressed: () {
                // _scaffoldKey.currentState!.openEndDrawer();
                context.router.push(const ExplanationsForTheStreamRoute());
              },
            ),
          ],
        ),
        body: const SingleChildScrollView(
          child: Column(
            children: [
              StepperIcons(step: 1),
              SizedBox(height: 20),
              CoursesBox(),
              SizedBox(height: 20),
              ButtonSaveNextStream(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class CoursesBox extends StatefulWidget {
  const CoursesBox({super.key});

  @override
  State<CoursesBox> createState() => _CoursesBoxState();
}

class _CoursesBoxState extends State<CoursesBox> {
  final _formKey = GlobalKey<FormState>();
  final List<Course> _courses = Course.generateDeal();

  // int? selected;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 25.0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _courses.length,
          itemBuilder: (context, index) => BlocConsumer<ChoiceOfCourseBloc, ChoiceOfCourseState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return CourseItem(index: index, selected: 2);
            },
          ),
        ),
      ),
    );
  }
}

class CourseItem extends StatefulWidget {
  final int index;
  final int? selected;

  const CourseItem({super.key, required this.index, this.selected});

  @override
  State<CourseItem> createState() => _CourseItemState();
}

class _CourseItemState extends State<CourseItem> {
  final List<Course> courses = Course.generateDeal();
  final shortTitleController = TextEditingController();
  late int index;
  int? selected;

  @override
  void initState() {
    index = widget.index;
    selected = widget.selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChoiceOfCourseBloc, ChoiceOfCourseState>(
      listener: (context, state) {},
      builder: (context, state) {
        // print('state.text: ${state.text}');
        // print('state.selectedIndex: ${state.selectedIndex}');
        return Container(
          decoration: AppLayout.boxDecorationShadowBG,
          margin: const EdgeInsets.only(bottom: 15),
          child: Column(
            children: <Widget>[
              Theme(
                data: ThemeData().copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  key: Key(widget.index.toString()),
                  initiallyExpanded: index == widget.selected,
                  // maintainState: false,
                  title: Text(
                    courses[widget.index].title,
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
                      courses[widget.index].iconUrl,
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
                      context
                          .read<ChoiceOfCourseBloc>()
                          .add(CourseItemChanged(text: shortTitleController.text, selectedIndex: index));
                      print('course: ${courses[index].title}');
                      print('shortTitleController: ${shortTitleController.text}');
                      // // деактивируем все курсы
                      // for (int i = 0; i < courses.length; i++) {
                      //   print(courses[i].isExpanded);
                      //   courses[i].isExpanded = false;
                      //   print(courses[i].isExpanded);
                      // }
                      // // активируем выбранный
                      // setState(() {
                      //   // деактивируем все курсы
                      //   for (int i = 0; i < courses.length; i++) {
                      //     print(courses[i].isExpanded);
                      //     courses[i].isExpanded = false;
                      //     print(courses[i].isExpanded);
                      //   }
                      //   // активируем выбранный
                      //   selected = index;
                      //   courses[index].isExpanded = newState;
                      // });
                    } else {
                      // setState(() {
                      //   selected = -1;
                      //   // _isActivated = false;
                      // });
                      // context.read<PlannerBloc>().add(StreamCourseTitleChanged(''));
                    }
                  }),
                  children: [
                    Column(
                      children: [
                        Text(
                          courses[widget.index].description,
                          style: const TextStyle(height: 1.5),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: shortTitleController,
                          onChanged: (title) {
                            print('title: $title');
                            print('course: ${courses[index].courseId}');
                            context
                                .read<ChoiceOfCourseBloc>()
                                .add(CourseItemChanged(text: shortTitleController.text, selectedIndex: index));
                            // // деактивируем все курсы
                            // for (int i = 0; i < _courses.length; i++) {
                            //   _courses[i].isExpanded = false;
                            // }
                            // context.read<PlannerBloc>().add(StreamCourseIdChanged(_courses[index].courseId));
                            // // print(title);
                            // context.read<PlannerBloc>().add(StreamCourseTitleChanged(title));
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
    );
  }
}

class ButtonSaveNextStream extends StatelessWidget {
  const ButtonSaveNextStream({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlannerBloc, PlannerState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: AppLayout.primaryRadius)),
            onPressed: context.watch<PlannerBloc>().state.courseTitle.isNotEmpty
                ? () async {
                    final isarService = IsarService();
                    final streamLocalStorage = StreamLocalStorage();
                    final _streamController = getIt<StreamController>();
                    // находим активный курс для дальнейшей его деактивации
                    NPStream _stream = await streamLocalStorage.getActiveStream();

                    if (context.mounted) {
                      CircularLoading(context).startLoading();
                    }
                    var user = await isarService.getUser();

                    // чтобы найти новое текущее дело должны соблюдаться условия
                    // 1. дело Активное и 2. дата старта меньше текущей
                    // у старого дела дата старта уже прошла!!

                    // СОЗДАНИЕ нового дела и
                    // замена статуса старого дела на неактивное
                    // TODO: ЕСЛИ дело закрыто досрочно, нужно ему добавить статус
                    // TODO: например CLOSED и не проверять его при создании нового дела
                    if (_stream.startAt!.isBefore(DateTime.now())) {
                      print('СОЗДАНИЕ нового дела');
                      Map streamData = {
                        "old_stream_id": _stream.id,
                        "user_id": user.first.id,
                        "start_at": state.startDate,
                        "weeks": state.nextStreamWeeks,
                        "is_active": true,
                        "course_id": state.courseId,
                        "title": state.courseTitle,
                        "description": '',
                        "cells": [],
                      };

                      print('streamData: $streamData');

                      // create on server
                      var newStream = await _streamController.createNextStream(streamData);

                      print('newStream: $newStream');

                      // create local
                      if (newStream['stream']['id'] != null) {
                        streamLocalStorage.createNextStream(newStream);
                      }
                    }
                    // ОБНОВЛЕНИЕ нового дела
                    else {
                      print('ОБНОВЛЕНИЕ нового дела');
                    }

                    if (context.mounted) {
                      CircularLoading(context).stopLoading();
                      context.router.push(const SelectDayPeriodRoute());
                    }
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
        );
      },
    );
  }
}

Future<Map> getCourseData() async {
  final streamLocalStorage = StreamLocalStorage();

  NPStream _stream = await streamLocalStorage.getActiveStream();
  // Данные нового курса, если он был уже создан
  if (_stream.startAt!.isAfter(DateTime.now())) {
    return {'stream': _stream, 'isStreamData': true};
  }
  // при создании нового дела
  // игнорируем данные от старого курса
  else {
    return {'stream': 'old', 'isStreamData': false};
  }
}
