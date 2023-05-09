import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../core/constants/app_theme.dart';

@RoutePage()
class PlanningScreen extends StatelessWidget {
  const PlanningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightBG,
      appBar: AppBar(
        backgroundColor: AppColor.lightBG,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Календарь',
          style: AppFont.scaffoldTitleDark,
        ),
      ),
      body: Center(
        child: Text('Planner'),
      ),
    );
  }
}
