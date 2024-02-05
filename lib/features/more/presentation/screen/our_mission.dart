import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _npRV = Uri.parse('http://xn--80aealihac0a3ao2a.xn--p1ai');
final Uri _npRU = Uri.parse('http://naporoge.ru');
final Uri _npRF = Uri.parse('https://xn--80agg3agafj.xn--p1ai');

Future<void> _launchNpRV() async {
  if (!await launchUrl(_npRV)) {
    throw Exception('Could not launch $_npRV');
  }
}

Future<void> _launchNpRU() async {
  if (!await launchUrl(_npRU)) {
    throw Exception('Could not launch $_npRU');
  }
}

Future<void> _launchNpRF() async {
  if (!await launchUrl(_npRF)) {
    throw Exception('Could not launch $_npRF');
  }
}

@RoutePage()
class OurMissionScreen extends StatelessWidget {
  const OurMissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: const Text(
          'Наша миссия',
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          onPressed: () {
            context.router.pop();
          },
          icon: RotatedBox(quarterTurns: 2, child: SvgPicture.asset('assets/icons/arrow.svg')),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          decoration: const BoxDecoration(color: Colors.white),
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
                  style: TextStyle(fontSize: 16, color: Colors.black),
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
