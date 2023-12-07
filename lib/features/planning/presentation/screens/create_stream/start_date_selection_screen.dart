import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
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
  bool _isActivated = false;

  @override
  Widget build(BuildContext context) {
    String buttonDate = 'Выбрать';
    return BlocConsumer<PlannerBloc, PlannerState>(
      listener: (context, state) {
        print('state.startDate: ${state.startDate}');
        _isActivated = true;
        String startDateString = state.startDate;
        DateTime startDate = DateTime.parse(startDateString);
        DateTime endDate = startDate.add(const Duration(days: 20));
        buttonDate = 'Выбрать ${DateFormat('dd.MM').format(startDate)} - ${DateFormat('dd.MM').format(endDate)}';
      },
      builder: (context, state) {
        NPStream? npStream = context.watch<ActiveStreamBloc>().state.activeNpStream;
        int studentsStreams = context.watch<ActiveStreamBloc>().state.studentsStreams;

        print('studentsStreams 33: $studentsStreams');

        return Scaffold(
          backgroundColor: AppColor.lightBG,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            elevation: 0,
            foregroundColor: Colors.black,
            backgroundColor: AppColor.lightBG,
            title: const Text('Выбор даты старта'),
            leading: studentsStreams <= 1
                ? IconButton(
                    onPressed: () {
                      // первое дело
                      if (!context.read<PlannerBloc>().state.isNextStreamCreate) {
                        print('object 11: ${context.read<PlannerBloc>().state.isNextStreamCreate}');
                        context.router.navigate(const WelcomeDescriptionScreenRoute());
                      }
                      // следующее дело не создано
                      // возврат на Итоги
                      else if (studentsStreams == 0) {
                        print('object 22: ${context.read<PlannerBloc>().state.isNextStreamCreate}');
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
                  margin: const EdgeInsets.all(20),
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: AppLayout.primaryRadius)),
                    onPressed: _isActivated
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
                        style: const TextStyle(fontSize: 18),
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
