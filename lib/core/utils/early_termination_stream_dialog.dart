import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'circular_loading.dart';
import 'early_termination.dart';
import '../constants/app_theme.dart';
import '../routes/app_router.dart';

Future earlyTerminationStreamDialog(context) async {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: AppLayout.primaryRadius),
            title: const Text('Досрочное завершение'),
            content: const Text(
                'Если завершить дело сейчас, то вернуться к нему будет невозможно. Вы уверены, что хотите завершить?'),
            actionsPadding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        CircularLoading(context).startLoading();

                        // прекращение текущего дела
                        await earlyTermination();

                        // процесс создания дела
                        if (context.mounted) {
                          CircularLoading(context).stopLoading();
                          context.router.replace(const StartDateSelectionScreenRoute());
                        }
                      },
                      style: AppLayout.accentBTNStyle,
                      child: const Text(
                        'Завершить дело',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                        'Отмена',
                        style: TextStyle(color: AppColor.grey3),
                      )),
                ],
              ),
            ],
          ));
}
