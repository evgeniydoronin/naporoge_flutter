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
          return button['isActive']
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: () async {
                      context.router.push(const DayResultsSaveScreenRoute());
                    },
                    style: AppLayout.accentBowBTNStyle,
                    child: Text(
                      'Внести результаты',
                      style: AppFont.regularSemibold,
                    ),
                  ),
                )
              : const SizedBox();
        } else {
          return const Text('...');
        }
      },
    );
  }
}
