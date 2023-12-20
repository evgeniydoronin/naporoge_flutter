import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../constants/app_theme.dart';

class CircularLoading {
  late BuildContext context;

  CircularLoading(this.context);

  // this is where you would do your fullscreen loading
  Future<void> startLoading() async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const SimpleDialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          // can change this to your prefered color
          children: <Widget>[
            Center(
              child: CircularProgressIndicator(),
            )
          ],
        );
      },
    );
  }

  Future<void> stopLoading() async {
    Navigator.of(context).pop();
  }

  Future<void> stopAutoRouterLoading() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (context.mounted) {
      context.router.pop();
    }
  }

  Future<void> showError(Object? error) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        backgroundColor: Colors.red,
        content: Text('handleError(error)'),
      ),
    );
  }

  Future<void> saveSuccess() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColor.deep,
        content: const Text('Успешно сохранено'),
      ),
    );
  }
}
