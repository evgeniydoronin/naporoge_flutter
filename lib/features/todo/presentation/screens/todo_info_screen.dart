import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_theme.dart';

@RoutePage()
class TodoInfoScreen extends StatelessWidget {
  const TodoInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.accent,
        image: const DecorationImage(
          opacity: 0.3,
          image: AssetImage('assets/images/waves.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Пояснения'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
          child: ListView(
            children: const <Widget>[
              RuleItem(
                  title:
                      'У любого время от времени появляются мысли сделать то или иное ценное дело. Но в потоке привычных дел они зачастую просто забываются. И мы остаемся жить без этих ценных продвижений'),
              RuleItem(
                  title:
                      '«Перечень важных дел» поможет не забывать такие идеи. Вносите их в перечень, как только они приходят к вам'),
              RuleItem(
                  title:
                      'И время от времени просматривайте перечень. Уверяем, найдете там много интересного. И спокойно выберете, что можно начать делать в ближайшее время'),
              RuleItem(title: 'Это и внесете в свой очередной план саморазвития'),
              RuleItem(
                  title:
                      'Совет. Самые важные идеи (дела) вносите в раздел «Самое важное». Остальные – в раздел «Тоже нужно»'),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class RuleItem extends StatelessWidget {
  final String title;

  const RuleItem({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: AppLayout.primaryRadius,
        color: Colors.white,
      ),
      child: Text(
        title,
        style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal),
      ),
    );
  }
}
