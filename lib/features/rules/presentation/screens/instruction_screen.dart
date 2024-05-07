import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_theme.dart';

@RoutePage()
class InstructionAppScreen extends StatelessWidget {
  const InstructionAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightBG,
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: AppColor.lightBG,
        title: const Text(
          'Инструкция по применению',
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          onPressed: () {
            context.router.maybePop();
          },
          icon: RotatedBox(quarterTurns: 2, child: SvgPicture.asset('assets/icons/arrow.svg')),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          decoration: BoxDecoration(color: AppColor.lightBG),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Проект «На пороге» - объединение молодых людей, ведущих научно разработанное саморазвитие. Основной контингент участников – студенты. Начало проекта – 2014 год. Виды деятельности – интеллектуальные инновации, саморазвитие, помощь другим в налаживании саморазвития.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              const Text(
                'Ключевая идея Проекта – укрепление реальной самостоятельности, освоение эффективных способов развития себя и своей жизни.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              const Text(
                'Для этого разработан способ познания и развития своих качеств «Тренажер для «Я». Это наш авторский метод.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              RichText(
                text: const TextSpan(
                  text:
                      'Реализуемое нами саморазвитие – научно разработанный процесс, нацеленный на осознанное развитие нужных способностей. Это не привычное освоение тех или иных умений, а ',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'формирование способности «развивать любые способности».',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Развиваем себя и помогаем в этом другим. Присоединяйся.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }
}
