import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_theme.dart';

@RoutePage()
class ExplanationsForThePlanning extends StatelessWidget {
  const ExplanationsForThePlanning({super.key});

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
            children: [
              const RuleItem(
                  title:
                      '1. Укажите время начала дела точно. Если это трудно, укажите час, в котором начнете. Например, 7:00'),
              const RuleItem(
                  title:
                      '2. Четко определите объем дела – продолжительность или другой показатель. Например, количество отжиманий. Укажите цель Дела, для чего оно нужно'),
              const RuleItem(
                  title:
                      '3. Напоминаем, что минимальная продолжительность уже задана в описании дел. Это – минимум 15 минут физических нагрузок. И не менее 8 минут для подведения итогов дня'),
              const RuleItem(title: '4. ВАЖНО! Редактировать план можно только до начала очередной недели'),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: AppLayout.primaryRadius,
                  color: Colors.white,
                ),
                child: const Column(
                  children: [
                    Text(
                      '5. ВАЖНО! Отмечать результаты выполнения дела НАДО в тот день, когда оно выполнялось. Если такой отметки не будет, дело отмечается как невыполненно.',
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Это – правило работы курса. Ни заранее, ни «задним числом» внести такую отметку в программу нельзя',
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(color: Colors.white, borderRadius: AppLayout.primaryRadius),
                child: Column(
                  children: [
                    const Text(
                      'Значения цветовых меток в плане',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: AppColor.grey1,
                          ),
                          child: const Text(
                            '05:30',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'или',
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '05:30',
                          style: TextStyle(color: AppColor.accent),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          '- запланированно',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: AppColor.accent,
                          ),
                          child: const Text(
                            '05:30',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          '- выполнено вовремя',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: AppColor.accent.withOpacity(0.5),
                          ),
                          child: const Text(
                            '05:30',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          '- выполнено не вовремя',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: AppColor.red,
                          ),
                          child: const Text(
                            '05:30',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          '- не выполнено',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: AppLayout.primaryRadius,
                          ),
                          child: Text(
                            '05:30',
                            style: TextStyle(color: AppColor.red),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          '- выполнено вне плана',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
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
