import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_theme.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/utils/early_termination_stream_dialog.dart';
import '../../../../core/utils/show_closeApp_dialog.dart';

final Uri _knizhka = Uri.parse('http://naporoge.ru/knizhka');
final Uri _vk = Uri.parse('https://vk.com/razvitievoly');
final Uri _tg = Uri.parse('https://t.me/np42vn');
final Uri _web = Uri.parse('https://www.xn--80aealihac0a3ao2a.xn--p1ai');

Future<void> _launchKnizhka() async {
  if (!await launchUrl(_knizhka)) {
    throw Exception('Could not launch $_knizhka');
  }
}

Future<void> _launchVk() async {
  if (!await launchUrl(_vk)) {
    throw Exception('Could not launch $_vk');
  }
}

Future<void> _launchTg() async {
  if (!await launchUrl(_tg)) {
    throw Exception('Could not launch $_tg');
  }
}

Future<void> _launchWeb() async {
  if (!await launchUrl(_web)) {
    throw Exception('Could not launch $_web');
  }
}

@RoutePage()
class MoreScreen extends StatelessWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final closeApp = await showCloseAppDialog(context);
        return closeApp ?? false;
      },
      child: Scaffold(
        backgroundColor: AppColor.lightBG,
        appBar: AppBar(
          backgroundColor: AppColor.lightBG,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Дополнительно',
            style: AppFont.scaffoldTitleDark,
          ),
        ),
        body: ListView(
          children: [
            Stack(
              children: [
                const Positioned(top: -35, left: -120, child: Image(image: AssetImage('assets/images/12.png'))),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
                  child: Column(
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: _launchKnizhka,
                                child: Container(
                                  padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
                                  decoration: BoxDecoration(
                                    color: AppColor.lightBGItem.withOpacity(0.9),
                                    borderRadius: AppLayout.primaryRadius,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 5,
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset('assets/icons/book.svg'),
                                      const SizedBox(height: 15),
                                      Text(
                                        'Книга “Тренажер для Я”',
                                        style: TextStyle(fontSize: AppFont.regular, fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  context.router.push(const ExperienceOfOthersScreenRoute());
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
                                  decoration: BoxDecoration(
                                    color: AppColor.lightBGItem.withOpacity(0.9),
                                    borderRadius: AppLayout.primaryRadius,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 5,
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset('assets/icons/experience.svg'),
                                      const SizedBox(height: 15),
                                      Text(
                                        'Опыт',
                                        style: TextStyle(fontSize: AppFont.regular, fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        'других',
                                        style: TextStyle(fontSize: AppFont.regular, fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () => context.router.push(const TheoriesScreenRoute()),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
                                decoration: AppLayout.boxDecorationShadowBG,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Теория к курсу и формы документов',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(color: AppColor.accent, shape: BoxShape.circle),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          'assets/icons/arrow.svg',
                                          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: () {
                  context.router.push(const TwoTargetScreenRoute());
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
                        decoration: AppLayout.boxDecorationShadowBG,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                'Две цели дела',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(color: AppColor.accent, shape: BoxShape.circle),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/icons/arrow.svg',
                                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
                        decoration: AppLayout.boxDecorationShadowBG,
                        child: GestureDetector(
                          onTap: () {
                            context.router.push(const OurMissionScreenRoute());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                child: Text(
                                  'Наша миссия',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(color: AppColor.accent, shape: BoxShape.circle),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/icons/arrow.svg',
                                    colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // const SizedBox(height: 15),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: InkWell(
            //     onTap: () {},
            //     child: Row(
            //       children: [
            //         Expanded(
            //           child: Container(
            //             padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
            //             decoration: AppLayout.boxDecorationShadowBG,
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 const Expanded(
            //                   child: Text(
            //                     'Архив дел',
            //                     style: TextStyle(fontSize: 16),
            //                   ),
            //                 ),
            //                 Container(
            //                   width: 25,
            //                   height: 25,
            //                   decoration: BoxDecoration(color: AppColor.accent, shape: BoxShape.circle),
            //                   child: Center(
            //                     child: SvgPicture.asset(
            //                       'assets/icons/arrow.svg',
            //                       colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            const SizedBox(height: 15),
            Stack(
              children: [
                // const Positioned(top: -55, right: -180, child: Image(image: AssetImage('assets/images/13.png'))),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
                                decoration: AppLayout.boxDecorationShadowBG,
                                child: GestureDetector(
                                  onTap: () {
                                    context.router.push(const RuleOfAppScreenRoute());
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Expanded(
                                        child: Text(
                                          'Правила работы',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Container(
                                        width: 25,
                                        height: 25,
                                        decoration: BoxDecoration(color: AppColor.accent, shape: BoxShape.circle),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            'assets/icons/arrow.svg',
                                            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      InkWell(
                        onTap: () {},
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
                                decoration: BoxDecoration(
                                  color: AppColor.lightBGItem,
                                  borderRadius: AppLayout.primaryRadius,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 5,
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: InkWell(
                                    onTap: () {
                                      earlyTerminationStreamDialog(context);
                                    },
                                    child: Text(
                                      'Досрочное завершение дела ',
                                      style: TextStyle(fontSize: AppFont.large, color: AppColor.accentBOW),
                                      textAlign: TextAlign.center,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 45),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: ElevatedButton(
                      //         onPressed: () {
                      //           context.router.push(SplashScreenRoute());
                      //         },
                      //         style: AppLayout.accentBTNStyle,
                      //         child: Text(
                      //           'Выйти',
                      //           style: AppFont.regularSemibold,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: 15),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Присоединяйтесь к проекту, следите за новостями, общайтесь с единомышленниками',
                style: TextStyle(
                  fontSize: AppFont.small,
                  color: AppColor.grey3,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: _launchVk,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.lightBGItem,
                      border: Border.all(
                        width: 1,
                        color: Colors.black.withOpacity(0.08),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/vk-fill.svg',
                      colorFilter: ColorFilter.mode(AppColor.accent, BlendMode.srcIn),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _launchTg,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.lightBGItem,
                      border: Border.all(
                        width: 1,
                        color: Colors.black.withOpacity(0.08),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/telegram.svg',
                      colorFilter: ColorFilter.mode(AppColor.accent, BlendMode.srcIn),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _launchWeb,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.lightBGItem,
                      border: Border.all(
                        width: 1,
                        color: Colors.black.withOpacity(0.08),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/web.svg',
                      colorFilter: ColorFilter.mode(AppColor.accent, BlendMode.srcIn),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: Text(
            //     'Напишите нам',
            //     style: TextStyle(color: AppColor.accent, fontSize: AppFont.small),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            // const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.router.push(const PersonalDataScreenRoute());
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/user.svg'),
                        const SizedBox(width: 20),
                        const Text('Пользовательское соглашение'),
                        const Spacer(),
                        SvgPicture.asset('assets/icons/arrow.svg'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      context.router.push(const PrivacyPolicyScreenRoute());
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/personal_data.svg'),
                        const SizedBox(width: 20),
                        const Text('Персональные данные'),
                        const Spacer(),
                        SvgPicture.asset('assets/icons/arrow.svg'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
}
