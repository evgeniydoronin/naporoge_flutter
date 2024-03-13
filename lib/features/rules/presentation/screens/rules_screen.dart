import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_theme.dart';

@RoutePage()
class RuleOfAppScreen extends StatelessWidget {
  const RuleOfAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      appBar: AppBar(
        title: const Text('Правила работы'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColor.primary,
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
            Text(
              'Приложение разработано так, чтобы пользователь всегда получал две пользы: качественно выполнял новое важное дело и развивал свои способности.',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              'Соблюдайте «Правила работы» и вы постоянно будете продвигаться!',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            RuleItem(
                title: 'Подберите дело правильно!',
                description:
                    'Дело должно быть явно полезным и непривычным («новым»). Хорошо подойдет дело, которое давно желается, но все откладывается и откладывается',
                icon: 'assets/icons/1228.png'),
            RuleItem(
                title: 'Выполняйте условия работы',
                description: '''Для получения  результата необходимы:
• постановка задачи;
• планирование;
• учет результатов''',
                icon: 'assets/icons/1382.png'),
            RuleItem(
                title: 'Длительность выполнения',
                description:
                    'Обычно, она задается самим делом. Если длительность сразу определить трудно, выделите на 1-й этап 2 – 4 недели, подведите итоги и определите длительность 2-го этапа. И т.д.',
                icon: 'assets/icons/1454.png'),
            RuleItem(
                title: 'Постановка задачи',
                description:
                    'Определите свою задачу – объем дневного выполнения и цель дела. Объем – продолжительность или другой показатель для разового (дневного) выполнения (например, количество отжиманий, тем для изучения). Ориентировочная норма – 30 минут в день. Цель - то главное, для чего вам нужно это дело.',
                icon: 'assets/icons/1978.png'),
            RuleItem(
                title: 'Планирование',
                description: '''Заранее составьте план на предстоящую неделю.
Определите время начала выполнения дела (например, час, в котором хотите приступить к делу) для каждого из 6 дней''',
                icon: 'assets/icons/985.png'),
            RuleItem(
                title: 'Воскресенья!',
                description:
                    'В приложении дело выполняется 6 дней в неделю. Воскресенье остается в виде резерва – для того, чтобы можно было выполнить дело, не сделанное в свой плановый день, осмыслить ход работы',
                icon: 'assets/icons/1357.png'),
            RuleItem(
                title: 'Учёт результатов выполнения дела',
                description: '''Отмечайте так, как ощущаете:
• объем выполнения дела;
• силу нежеланий выполнять дело;
• силу желаний приступить к делу;
• отмечайте сразу (чтобы не забылись) и другие полезные факты''',
                icon: 'assets/icons/632.png'),
            RuleItem(
                title: 'Ведите записи в дневнике!',
                description: '''Фиксируйте:
• что сбивало, мешало выполнять план и даже побуждало забросить дело;
• настроения и мысли, которые поддерживали и воодушевляли;
• важные идеи по улучшению организации дел и жизни в целом.

Дневник – полезная опция!
Фиксация мешающих факторов ослабляет их силу.
Фиксация ценных идей помогает запомнить их.
Опыт показывает - если не фиксировать факты, многое забывается''',
                icon: 'assets/icons/1040.png'),
          ],
        ),
      ),
    );
  }
}

class RuleItem extends StatelessWidget {
  final String title;
  final String description;
  final String icon;

  const RuleItem({Key? key, required this.title, required this.description, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: AppLayout.primaryRadius,
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            height: 85,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(borderRadius: AppLayout.primaryRadius, color: AppColor.accentBOW),
            // color: Colors.yellow,
            child: Row(
              children: [
                Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w500),
                    )),
                Image.asset(icon)
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(borderRadius: AppLayout.primaryRadius, color: Colors.white),
            child: Text(description),
          ),
        ],
      ),
    );
  }
}
