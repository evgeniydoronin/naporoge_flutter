import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'TestEmptyRouter')
class TestEmptyRouterScreen extends AutoRouter {}

@RoutePage()
class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('++++++++++++++TestScreen++++++++++++++');
    print('++++++++++++++TestScreen++++++++++++++');
    print('++++++++++++++TestScreen++++++++++++++');
    print('++++++++++++++TestScreen++++++++++++++');
    print('++++++++++++++TestScreen++++++++++++++');
    print('++++++++++++++TestScreen++++++++++++++');
    print('++++++++++++++TestScreen++++++++++++++');
    print('++++++++++++++TestScreen++++++++++++++');
    print('++++++++++++++TestScreen++++++++++++++');
    print('++++++++++++++TestScreen++++++++++++++');
    print('++++++++++++++TestScreen++++++++++++++');
    print('++++++++++++++TestScreen++++++++++++++');
    print('++++++++++++++TestScreen++++++++++++++');
    print('++++++++++++++TestScreen++++++++++++++');
    print('++++++++++++++TestScreen++++++++++++++');
    return Scaffold(
        appBar: AppBar(
          title: Text('test screen'),
        ),
        backgroundColor: Colors.purpleAccent,
        body: Center(
          child: Text('TEST'),
        ));
  }
}
