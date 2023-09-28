import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// SystemNavigator.pop();
Future showCloseAppDialog(context) async {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Закрыть приложение?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Нет')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                    SystemNavigator.pop();
                  },
                  child: const Text('Да')),
            ],
          ));
}
