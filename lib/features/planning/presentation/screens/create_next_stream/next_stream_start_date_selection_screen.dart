import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../../core/routes/app_router.dart';

import '../../../../../core/constants/app_theme.dart';
import '../../bloc/planner_bloc.dart';
import '../../widgets/next_select_week_widget.dart';
import '../../widgets/stepper_widget.dart';

@RoutePage()
class NextStreamStartDateSelectionScreen extends StatefulWidget {
  final int nextStreamWeeks;

  const NextStreamStartDateSelectionScreen({super.key, required this.nextStreamWeeks});

  @override
  State<NextStreamStartDateSelectionScreen> createState() => _StartDateSelectionScreenState();
}

class _StartDateSelectionScreenState extends State<NextStreamStartDateSelectionScreen> {
  bool _isActivated = false;

  @override
  Widget build(BuildContext context) {
    int nextStreamWeeks = widget.nextStreamWeeks;

    // print('nextStreamWeeks: $nextStreamWeeks');
    // print('endDate: ${nextStreamWeeks * 7 - 1}');

    String buttonDate = 'Выбрать';
    return BlocConsumer<PlannerBloc, PlannerState>(
      listener: (context, state) {
        print(state.startDate);
        _isActivated = true;
        String startDateString = state.startDate;
        DateTime startDate = DateTime.parse(startDateString);
        DateTime endDate = startDate.add(Duration(days: nextStreamWeeks * 7 - 1));
        buttonDate = 'Выбрать ${DateFormat('dd.MM').format(startDate)} - ${DateFormat('dd.MM').format(endDate)}';
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColor.lightBG,
          appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              elevation: 0,
              foregroundColor: Colors.black,
              backgroundColor: AppColor.lightBG,
              title: Text(
                'Выбор даты старта',
                style: AppFont.scaffoldTitleDark,
              )),
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
                  child: NextSelectWeekWidget(
                    nextStreamWeeks: nextStreamWeeks,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: AppLayout.primaryRadius)),
                    onPressed: _isActivated
                        ? () {
                            context.router.push(const NextStreamChoiceOfCaseScreenRoute());
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
