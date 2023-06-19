import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/app_router.dart';
import '../bloc/planner_builder_bloc.dart';
import '../widgets/day_schedule_widget.dart';
import '../../../../core/constants/app_theme.dart';
import '../widgets/stepper_widget.dart';

@RoutePage()
class SelectDayPeriod extends StatelessWidget {
  const SelectDayPeriod({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String courseTitle = '';

    // final _formKey = GlobalKey<FormState>();
    // var state = context.watch<PlannerBloc>().state;
    //
    // print('context.read<PlannerBloc>()');
    // print(BlocProvider.of<PlannerBloc>(context));
    // print(BlocProvider.of<PlannerBloc>(context).state);
    // print('context.read<PlannerBloc>()');
    //
    // if (state is PlannerSelectDateRangeState) {
    //   startDate = state.date;
    //   print('select day period');
    //   print(startDate);
    //   print('select day period');
    // }
    // if (state is PlannerSelectCaseTitleState) {
    //   courseId = state.courseId;
    //   courseTitle = state.courseTitle;
    //
    //   // print('select day period');
    //   // print(courseId);
    //   // print(courseTitle);
    //   // print('select day period');
    // }

    return BlocConsumer<PlannerBuilderBloc, PlannerState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is PlannerDataState) {
          courseTitle = state.courseTitle;
        }
        return Scaffold(
          backgroundColor: AppColor.lightBG,
          appBar: AppBar(
            foregroundColor: Colors.black,
            backgroundColor: AppColor.lightBG,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Планирование',
              style: AppFont.scaffoldTitleDark,
            ),
          ),
          body: ListView(
            shrinkWrap: true,
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
                              top: 15, bottom: 15, left: 15, right: 80),
                          child: Text(
                            'Старт курса – с понедельника. Выберите, с какого начнете',
                            style: TextStyle(
                                color: Colors.white, fontSize: AppFont.regular),
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
                  padding: const EdgeInsets.only(
                      top: 15, bottom: 15, left: 18, right: 18),
                  decoration: AppLayout.boxDecorationShadowBG,
                  child: Text(
                    courseTitle,
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
                          return 'Заполните обязательное поле!';
                        }
                        return null;
                      },
                      onChanged: (val) {},
                      maxLines: 2,
                      maxLength: 200,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        hintText: 'Укажите объем выполнения и цель дела',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                        labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
                        fillColor: Colors.white,
                        filled: true,
                        errorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.redAccent),
                            borderRadius: AppLayout.primaryRadius),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                            borderRadius: AppLayout.primaryRadius),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
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
                    child: const DayScheduleWidget()),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.router.replace(const DashboardScreenRoute());
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
        );
      },
    );
  }
}
