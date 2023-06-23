import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/app_router.dart';
import '../bloc/planner_bloc.dart';
import '../widgets/day_schedule_widget.dart';
import '../../../../core/constants/app_theme.dart';
import '../widgets/stepper_widget.dart';

@RoutePage()
class SelectDayPeriod extends StatefulWidget {
  const SelectDayPeriod({Key? key}) : super(key: key);

  @override
  State<SelectDayPeriod> createState() => _SelectDayPeriodState();
}

class _SelectDayPeriodState extends State<SelectDayPeriod> {
  @override
  Widget build(BuildContext context) {
    String courseDescription = '';

    return BlocConsumer<PlannerBloc, PlannerState>(
      listener: (context, state) {},
      builder: (context, state) {
        print(state);
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
                    state.courseTitle,
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
                      onChanged: (description) {
                        context
                            .read<PlannerBloc>()
                            .add(StreamCourseDescriptionChanged(description));
                      },
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
