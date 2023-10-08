import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_theme.dart';

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
                'Мы развиваем себя сами и помогаем в этом другим. Присоединяйся.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 35),
              const Text(
                'Стратегическая задача «На пороге»',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 15),
              const Text(
                'Почему решили создать объединение?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 15),
              RichText(
                text: const TextSpan(
                  text:
                      'Опыт молодежных групп саморазвития показал, что современным молодым людям самим начинать познавать и менять себя ',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(text: 'чрезмерно', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: ' трудно. Без помощи извне, как правило, не получается. Отвлекают привычные желания.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Для того, чтобы развить волю и другие важные способности, в первую очередь требуются собственные регулярные усилия, то есть, воля. А ее как раз и нужно развить.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              const Text(
                'Замкнутый круг начала саморазвития!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              const Text(
                '''Причем, ситуация становится все более проблемной. 
                                
Роль сферы развлечений в жизни людей растет стремительно. Как следствие, роль сферы образования и других культурных институтов становится слабее.

Школьникам и студентам все труднее противостоять этому и приступать к важным для своего будущего делам.

В обществе нет саморазвития как ценной социальной нормы. Молодой человек не видит вокруг себя примеров увлеченного познания и развития себя. Нет «действующих образцов». Куда идти, чем пользоваться?

Ни в школах, ни в вузах этому не учат. Учителей и родителей самих этому не учили. 
''',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 15),
              const Text(
                'Это – еще один замкнутый круг начала саморазвития.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              const Text(
                'Мы смогли преодолеть эти трудности, потому что объединили силы и сформировали первую студенческую группу саморазвития. И в помощь всем создали Проект «На пороге».',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 15),
              RichText(
                text: const TextSpan(
                  text:
                      'Одних только наших сил для снятия замкнутых кругов мало. Полагаем, что в современной культуре жизни требуется выделять ',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(text: 'специальный этап – переход', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text:
                          ' молодых людей от сложившегося способа жизни (в котором еще во многом сильны привычные желания и стереотипы) к настоящей взрослости. Тогда в школах и вузах учащиеся могли бы получать понятную информацию о том, что это такое – сознательное самоуправление, и как крепить эту способность.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Саморазвитие стало бы необходимостью и ценной нормой. А возможность реально проверить свои сознательные силы и укрепить их предоставляли бы группы научно обоснованного саморазвития.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 15),
              const Text(
                ' Включайся в решение этой задачи.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: _launchNpRV,
                child: Text(
                  'развитиеволи.рф',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: AppColor.primary),
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: _launchNpRU,
                child: Text(
                  'naporoge.ru',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: AppColor.primary),
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: _launchNpRF,
                child: Text(
                  'напороге.рф',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: AppColor.primary),
                ),
              ),
              const SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }
}
