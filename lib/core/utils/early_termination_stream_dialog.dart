import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../routes/app_router.dart';

Future earlyTerminationStreamDialog(context) async {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Досрочное завершение'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Отмена')),
              TextButton(
                  onPressed: () {
                    context.router.push(StartDateSelectionScreenRoute(isBackLeading: false, isShowWeeksSelect: true));
                  },
                  child: const Text('Завершить дело')),
            ],
          ));
}
