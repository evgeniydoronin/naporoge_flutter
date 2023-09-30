import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_theme.dart';

@RoutePage()
class ExplanationsForTheStream extends StatelessWidget {
  const ExplanationsForTheStream({super.key});

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
          title: const Text('Правила работы'),
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
            children: const [
              RuleItem(title: 'Важно выбрать дело, которое вам действительно нужно и хочется'),
              RuleItem(title: 'Лучше всего подходят дела, которые давно решали начать, но они пока откладываются'),
              RuleItem(
                  title:
                      'Самое важное – суметь выполнять дело все 6 плановых дней. Поэтому нужно определить объем дела так, чтобы оно точно могло быть выполнено в течение дня и смогло принести пользу'),
              RuleItem(
                  title:
                      'По этой причине сразу даем посильный всем минимум выполнения дела – 15 минут. Исключение для сложного, но явно полезного дела «Подведение итогов дня» - 8 минут. Ориентировочная норма качественной работы – 30 минут'),
              RuleItem(
                  title:
                      'Конкретный объем дела выбирайте сами, исходя из вашей ситуации и желания укрепить себя. Этот объем надо будет указать при составлении плана в поле «Моя задача»'),
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
