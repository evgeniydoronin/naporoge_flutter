import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
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

          //
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
                context.router.push(const DayResultsSaveScreenRoute());
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
          return const Text('...');
        }
      },
    );
  }
}
