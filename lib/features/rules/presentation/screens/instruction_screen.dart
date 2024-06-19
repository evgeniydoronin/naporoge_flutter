import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_theme.dart';

final Uri _npRV = Uri.parse('https://xn--80aealihac0a3ao2a.xn--p1ai/base');

Future<void> _launchNpRV() async {
  if (!await launchUrl(_npRV)) {
    throw Exception('Could not launch $_npRV');
  }
}

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
                'Главное – в чем помогает',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              RichText(
                text: TextSpan(
                  text: '1. Приложение – личный постоянно доступный инструмент ',
                  style: TextStyle(fontSize: 16, color: AppColor.blk),
                  children: const <TextSpan>[
                    TextSpan(text: 'развития себя', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: ' (умений, личностных качеств) ', style: TextStyle(fontWeight: FontWeight.normal)),
                    TextSpan(text: ' и четкого выполнения сложных дел.', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                '2. Стартовый курс нацелен на развитие воли, ибо воля требуется для продвижения любых качеств. Осмыслите этот факт и постарайтесь как можно лучше пройти Стартовый курс «Развитие воли».',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              const Text(
                '3. Каждое новое качество, дело осваивается в рамках отдельных циклов развития, которые пользователь сам создает в приложении. Количество циклов не ограничено.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              RichText(
                text: TextSpan(
                  text: '4. Приложение спроектировано так, что при его',
                  style: TextStyle(fontSize: 16, color: AppColor.blk),
                  children: const <TextSpan>[
                    TextSpan(text: ' правильном', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: ' применении пользователь', style: TextStyle(fontWeight: FontWeight.normal)),
                    TextSpan(
                        text: ' всегда одновременно реализует две цели:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: ' продвигает нужное личностное качество и четко реализует ценное дело.',
                        style: TextStyle(fontWeight: FontWeight.normal)),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                '5. Приложение является цифровым механизмом психологически спроектированного процесса освоения «нового». Осваивать новое всегда непросто. ибо это то, что еще неизвестно, непривычно, требует усилий, чтобы не отложить дело и суметь продвинуться, поэтому приложение помогает вам в работе.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              const Text(
                '6. Чтобы помочь пользователю освоить навыки развития себя, в него включен специальный образовательно-развивающий блок.\nИ приложение представляет собой два блока продвижения:\n- обучающий-развивающий «Стартовый» 3х недельный курс «Развитие воли»; \n- основной блок развития себя и четкого выполнения сложных дел. Это ваш личный  помощник, который будет активен всегда, если он вам нужен (если им не пользуются в течение трех лет, аккаунт удаляется автоматически).',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              const Text(
                'Образовательно-развивающий блок «Стартовый 3х недельный»',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              const Text(
                'Для успеха в стартовом курсе лучше всего подобрать полезное дело, которое давно хотите, но оно все откладывается и откладывается!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              const Text(
                '1. Стартовый курс «Развитие воли» имеет ряд особенностей. Они связаны с тем, чтобы помочь пользователю:\n- понять причины мешающих желаний, нежеланий и иных отвлечений;\n- найти  способ четко приступать к делам даже когда делать это не хочется;\n- ощутить, что это такое – «моя воля», и прибавить ей сил;\n- получить радующий успех в выполнении дела, которое давно желается, но пока все откладывается и откладывается;\n- научиться знать приложение и уметь с его помощью начинать новые циклы развития своих качеств и выполнения важных дел.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              RichText(
                text: TextSpan(
                  text: '2. Для этого в приложении имеется пошаговый алгоритм',
                  style: TextStyle(fontSize: 16, color: AppColor.blk),
                  children: const <TextSpan>[
                    TextSpan(text: ' правильной', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text:
                          ' подготовки к старту курса, даются правила работы, помогающая теория, видео (развивающие и организационные) и ряд других опций, составляющих механизм управления своим развитием.',
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                '3. Развивающие видео:  «Ключ к развитию», «Что делать, когда не хочу делать дело?», «Почему откладываются дела?» и «Верное завершение дел». Первое дается сразу. Остальные приходят в нужные моменты развивающей работы (два – в конце 1й недели, последнее – в конце 2-й недели работы). В видео дается ценная предельно практичная информация! Это слова тех, кто смотрел видео!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              const Text(
                '4. По завершении 3х недель можно увидеть результаты работы, графики, оценку и совет на будущее.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              const Text(
                '5. Для тех, кто после завершения 3х недель хотел бы продолжить дело, имеется опция продлить на неделю. В окне «Итоги»  будет две кнопки «Продлить» и «Выбрать новое дело». Продлить дело можно только до начала очередного понедельника. Если это не сделать, опция на новой неделе исчезает.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              RichText(
                text: TextSpan(
                  text:
                      '6. Учет результатов каждого выполнения дела имеет большое развивающее значение. Он помогает четко сознавать ход развития, фиксировать мешающие факторы и прояснять их. Именно учет является двигателем продвижения. Внесение информации «для галочки» будет вам слабой помощью.',
                  style: TextStyle(fontSize: 16, color: AppColor.blk),
                  children: const <TextSpan>[
                    TextSpan(text: ' Настоящий учет –', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text:
                          ' это фиксация результатов и их осмысление. Результаты дают возможность понять, что пока не удается, и определить «задачу на завтра» - что именно нужно стараться делать лучше.',
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                '7. Вносить результаты можно только в день выполнения дела. Ни заранее, ни «задним числом» сделать это нельзя. Данное условие - для развития воли и организованности.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              const Text(
                '8. Результаты осмыслений хода работы, «задачи на завтра», ценные идеи и иное важное удобно вносить в «Дневник». Эта опция дана потому, что «Дневник» отлично помогает продвигать себя.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              const Text(
                '9. Стартовый курс нельзя остановить или досрочно завершить. Это сделано для укрепления серьезного отношения к делу. Вы начинаете ценное дело - продумывайте все заранее и лишь после этого стартуйте.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              const Text(
                '*Новые дела, которые можно будет начинать после стартового курса, включают опцию досрочного завершения дел.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              const Text(
                '10. Если пропустили большую часть курса, заново стартовый уже не начать. Нужно будет ждать завершения 3х недель и начинать в режиме «Новое дело». Все видео будут доступны сразу.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              const Text(
                '11. Это реально вам поможет!\n- Для успеха нужно действовать правильно. Изучите «Правила работы».\n- Для того, чтобы узнать, что в вас самих вам же мешает делать нужные дела, смотрите видео!\n- Помните, это развивающее приложение! Оно не для того, чтобы расслабиться или отключиться от дел. Оно для того, чтобы вы смогли продвинуться на новый уровень возможностей.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              const Text(
                'Основной блок развития себя и четкого выполнения важных дел',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              const Text(
                '1. После завершения стартового курса приложение переходит в базовый режим развивающей помощи. Пользователь сам определяет длительность новых циклов работы (от 1 до 9 недель), даты их начала, ставит цели развития и ведет процесс продвижения. При необходимости работа продлевается как «Новое дело». В архиве дел фиксируются результаты предшествующих циклов работы.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              const Text(
                '2. В данном режиме работы дела можно досрочно завершать.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              const Text(
                '3. Приложение – не планер или органайзер. Это – инструмент развития, с помощью которого можно успешно продвигать навыки планирования, тайм-менеджмента и любые другие.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              const Text(
                '4. Для наработки умения ставить цели дел, найдите в «Дополнительном» форму «Две цели дела» (простую форму увидите сразу, полную смотрите в разделе Теория).',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              const Text(
                '5. С помощью приложения удобно освоить все главные приемы саморазвития. Продвигайте их как «Новые дела». Нужно освоить «Верное завершение» – прекрасное дело. Надо освоить умение усиливать желание приступать к делам? Ставьте это делом для очередного цикла развития. И продвигайтесь!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              const Text(
                '6. Умение размышлять – ценное и трудное. Попробуйте продвинуть его. Найдите подходящее дело – то, которое без размышлений сделать невозможно, и начинайте. Для наработки размышлений хорошо подходит дело «Итоги дня». Полезно продумать план жизни на 5 – 10 лет вперед, бизнес-план или иное серьезное дело.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              const Text(
                '7. Приложение отлично поможет освоить непривычное физупражнение или отдельные, особенно трудные для вас, его элементы.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              RichText(
                text: TextSpan(
                  text: '8. Самый надежный и качественный способ продвижения – иметь в работе',
                  style: TextStyle(fontSize: 16, color: AppColor.blk),
                  children: const <TextSpan>[
                    TextSpan(text: ' только одно', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text:
                          ' развивающее дело.\nЕсли взять сразу два или более таких дела, это будет дробить внимание и множить упущения. Начнут появляться самооправдания типа «это не успел, зато то сделал».',
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                '9.  Что делать, когда появляется много ценных идей развития? Как их не упустить? Для удобной организации саморазвития есть «Перечень дел» (кнопка на главном экране). Все ценные мысли о делах развития себя и жизни вносите в него. И они не забудутся.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              const Text(
                '10.  Циклы развития всегда начинаются с понедельников. Саморазвитие легче встраивать в привычный недельный режим, сложившийся в обществе. Развитие себя удобно планировать и осмысливать недельными «шагами». И даже если хочется начать дело быстрее, лучше не торопиться. Четко все продумать и с нужным настроем стартовать с понедельника.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: _launchNpRV,
                child: Text(
                  'Смотреть более подробную инструкцию на сайте',
                  style: TextStyle(color: AppColor.accent, fontSize: 16),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
