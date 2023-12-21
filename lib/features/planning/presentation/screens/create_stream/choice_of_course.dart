import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../bloc/active_course/active_stream_bloc.dart';
import '../../bloc/planner_bloc.dart';
import '../../widgets/choice_course_form/choice_course_form.dart';
import '../../../../../core/constants/app_theme.dart';
import '../../../../../core/routes/app_router.dart';
import '../../widgets/stepper_widget.dart';

@RoutePage()
class ChoiceOfCaseScreen extends StatelessWidget {
  const ChoiceOfCaseScreen({super.key});

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
          title: const Text('Выбрать дело'),
          leading: IconButton(
            onPressed: () {
              /// сброс даты старта курса
              context.read<PlannerBloc>().add(const StreamStartDateChanged(''));
              context.router.navigate(const StartDateSelectionScreenRoute());
            },
            icon: RotatedBox(quarterTurns: 2, child: SvgPicture.asset('assets/icons/arrow.svg')),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline_rounded),
              color: Colors.black,
              onPressed: () {
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
              ChoiceCourseFormWidget(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
