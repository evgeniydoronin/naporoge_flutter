import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import '../../../../../core/services/db_client/isar_service.dart';
import '../../../../../core/utils/select_next_stream_weeks.dart';
import '../../../domain/entities/stream_entity.dart';
import '../../../../../core/routes/app_router.dart';
import '../../../../../core/constants/app_theme.dart';
import '../../bloc/active_course/active_stream_bloc.dart';
import '../../bloc/choice_of_course/choice_of_course_bloc.dart';
import '../../bloc/planner_bloc.dart';
import '../../widgets/select_week_widget.dart';
import '../../widgets/stepper_widget.dart';

@RoutePage()
class StartDateSelectionScreen extends StatefulWidget {
  const StartDateSelectionScreen({super.key});

  @override
  State<StartDateSelectionScreen> createState() => _StartDateSelectionScreenState();
}

class _StartDateSelectionScreenState extends State<StartDateSelectionScreen> {
  final isarService = IsarService();
  bool isActivatedBtnFirstStep = false;
  bool isBackLeading = true;
  String buttonDate = 'Выбрать';

  @override
  void initState() {
    getScreenStart();
    super.initState();
  }

  // show selectWeeks dialog
  void getScreenStart() async {
    final isar = await isarService.db;
    final List streams = await isar.nPStreams.where().findAll();
    final NPStream? activeStream = await isar.nPStreams.filter().isActiveEqualTo(true).findFirst();
    final DateTime now = DateTime.now();

    print('streams: $streams');
    if (streams.isNotEmpty) {
      /// есть активный курс
      if (activeStream != null) {
        print('activeStream != null');

        /// и курс еще не стартовал
        if (now.isBefore(activeStream.startAt!)) {
          /// скрываем кнопку НАЗАД
          setState(() {
            isBackLeading = false;
          });
        } else {
          setState(() {
            isBackLeading = true;
          });
        }

        if (mounted) {
          await selectWeeks(context);
        }

        // /// первый курс
        // if (streams.length == 1) {
        //   setState(() {
        //     isBackLeading = false;
        //   });
        // }
        //
        // /// следующий курс
        // else if (DateTime.now().isBefore(activeStream.startAt!)) {
        //   setState(() {
        //     isBackLeading = false;
        //   });
        //   if (mounted) {
        //     await selectWeeks(context);
        //   }
        // }
      }

      /// курса нет
      else {
        print('activeStream == null');
        setState(() {
          isBackLeading = false;
        });
        if (mounted) {
          await selectWeeks(context);
        }
      }
      // /// первый неактивный курс
      // if (streams.length == 1 && activeStream != null) {
      //   print('первый неактивный курс');
      //   if (context.mounted) {
      //     // disable back button
      //     setState(() {
      //       isBackLeading = false;
      //     });
      //   }
      // }
      ///
      // if (streams.length == 1) {
      //   /// и деактивирован
      //   if (!streams[0].isActive) {
      //     print('первый курс есть и деактивирован');
      //     if (context.mounted) {
      //       setState(() {
      //         // disable back button
      //         isBackLeading = false;
      //       });
      //       await selectWeeks(context);
      //     }
      //   }
      // }
      //
      // /// другие курсы
      // else {
      //   if (context.mounted) {
      //     setState(() {
      //       // disable back button
      //       isBackLeading = true;
      //     });
      //     // await selectWeeks(context);
      //   }
      // }
    }

    /// первый курс не создан
    else if (streams.isEmpty) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    int weeks = context.watch<PlannerBloc>().state.courseWeeks;
    if (weeks == 0) {
      context.read<PlannerBloc>().add(const StreamCourseWeeksChanged(3, false));
    }

    return BlocConsumer<PlannerBloc, PlannerState>(
      listener: (context, state) {
        if (state.startDate.isNotEmpty) {
          String startDateString = state.startDate;
          int nextWeeksCount = weeks;
          DateTime startDate = DateTime.parse(startDateString);
          DateTime endDate = startDate.add(Duration(days: nextWeeksCount * 7 - 1));
          buttonDate = 'Выбрать ${DateFormat('dd.MM').format(startDate)} - ${DateFormat('dd.MM').format(endDate)}';
          isActivatedBtnFirstStep = true;
        }
      },
      builder: (context, state) {
        int studentsStreams = context.watch<ActiveStreamBloc>().state.studentsStreams;

        return Scaffold(
          backgroundColor: AppColor.lightBG,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            elevation: 0,
            foregroundColor: Colors.black,
            backgroundColor: AppColor.lightBG,
            title: const Text('Выбор даты старта'),
            leading: isBackLeading
                ? IconButton(
                    onPressed: () async {
                      // final isar = await isarService.db;
                      // final List streams = await isar.nPStreams.where().findAll();

                      // первое дело
                      if (!context.read<PlannerBloc>().state.isNextStreamCreate) {
                        context.router.navigate(const WelcomeDescriptionScreenRoute());
                      }
                      // следующее дело не создано
                      // возврат на Итоги
                      else if (studentsStreams == 0) {
                        context.router.navigate(const ResultsStreamScreenRoute());
                      }
                    },
                    icon: RotatedBox(quarterTurns: 2, child: SvgPicture.asset('assets/icons/arrow.svg')),
                  )
                : const SizedBox(),
          ),
          body: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
              shadowColor: Colors.transparent,
            ),
            child: ListView(
              children: [
                const StepperIcons(step: 0),
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
                              'Старт курса – с понедельника. Выберите, с какого начнете',
                              style: TextStyle(color: Colors.white, fontSize: AppFont.regular),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: AppLayout.contentPadding, vertical: AppLayout.contentPadding),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppLayout.primaryRadius,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 0,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: const SelectWeekWidget(),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppLayout.contentPadding),
                  child: ElevatedButton(
                    style: AppLayout.confirmBtnFullWidth,
                    onPressed: isActivatedBtnFirstStep
                        ? () {
                            // закрываем все дела по умолчанию
                            context.read<ChoiceOfCourseBloc>().add(const CourseItemChanged(selectedIndex: -1));
                            context.router.push(const ChoiceOfCaseScreenRoute());
                          }
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        buttonDate,
                        // style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}
