import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/save_day_result/day_result_bloc.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/routes/app_router.dart';
import '../../utils/get_home_status.dart';

class TotalButton extends StatelessWidget {
  const TotalButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getHomeStatus(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          Map button = snapshot.data['button'];
          ElevatedButton? bottomButton;

          if (button['status'] == 'goToTotalScreen') {
            bottomButton = ElevatedButton(
              onPressed: () async {
                context.router.push(const ResultsStreamScreenRoute());
              },
              style: AppLayout.accentBowBTNStyle,
              child: Text(
                'Итоги работы',
                style: AppFont.regularSemibold,
              ),
            );
          } else {
            bottomButton = ElevatedButton(
              onPressed: () async {
                context.router.navigate(const DayResultsSaveScreenRoute());
                // сброс данных стейта предыдущих значений
                context.read<DayResultBloc>().add(const DesiresChanged(''));
                context.read<DayResultBloc>().add(const ReluctanceChanged(''));
                context.read<DayResultBloc>().add(const RejoiceChanged(''));
                print('state345: ${context.read<DayResultBloc>().state.rejoice}');
                // context.read<DayResultBloc>().add()
              },
              style: AppLayout.accentBowBTNStyle,
              child: Text(
                'Внести результаты',
                style: AppFont.regularSemibold,
              ),
            );
          }
          return button['isActive']
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: bottomButton,
                )
              : const SizedBox();
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
