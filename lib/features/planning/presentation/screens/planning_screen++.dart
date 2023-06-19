import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naporoge/features/planning/presentation/widgets/day_schedule_widget.dart';
import '../../../../core/constants/app_theme.dart';
import '../bloc/planner_builder_bloc.dart';

@RoutePage()
class PlanningScreen extends StatelessWidget {
  const PlanningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String courseTitle = '';
    return BlocConsumer<PlannerBuilderBloc, PlannerState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColor.lightBG,
          appBar: AppBar(
            backgroundColor: AppColor.lightBG,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Планирование1',
              style: AppFont.scaffoldTitleDark,
            ),
          ),
          body: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 15, bottom: 15, left: 18, right: 18),
                  decoration: AppLayout.boxDecorationShadowBG,
                  child: Text(
                    'Йога',
                    style: TextStyle(
                        color: Colors.black,
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
                    padding: EdgeInsets.only(bottom: 5),
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
                        onPressed: () {},
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
