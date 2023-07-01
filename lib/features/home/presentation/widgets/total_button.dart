import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/get_status_stream.dart';
import '../../../planning/domain/entities/stream_entity.dart';

import '../../../../core/constants/app_theme.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/utils/get_week_number.dart';
import '../bloc/home_screen/home_screen_bloc.dart';

class TotalButton extends StatefulWidget {
  const TotalButton({super.key, required this.stream});

  final NPStream stream;

  @override
  State<TotalButton> createState() => _TotalButtonState();
}

class _TotalButtonState extends State<TotalButton> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeScreenBloc, HomeScreenState>(
      listener: (context, state) {},
      listenWhen: (previous, current) =>
          previous.streamProgress != current.streamProgress,
      builder: (context, state) {
        Map button = {};
        if (state.streamProgress != null) {
          // {status: opened, dayID: 718, title: 04:05, weekDay: Monday}
          button = state.streamProgress!['buttons'];
          // print('weekStatusPoint: $weekStatusPoint');
          // print('weekStatusPoint.length: ${weekStatusPoint.length}');
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: (button['status'] == 'active')
              ? ElevatedButton(
                  onPressed: () {
                    if (button['page'] == 'DayResultsSaveScreenRoute') {
                      context.router.push(const DayResultsSaveScreenRoute());
                    } else if (button['page'] == 'ResultsStreamScreenRoute') {
                      context.router.push(ResultsStreamScreenRoute());
                    }
                  },
                  style: AppLayout.accentBowBTNStyle,
                  child: Text(
                    state.streamProgress!['buttons']['total'],
                    style: AppFont.regularSemibold,
                  ),
                )
              : null,
        );
      },
    );
  }
}
