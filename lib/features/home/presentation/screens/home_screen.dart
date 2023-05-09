import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/routes/app_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:video_player/video_player.dart';

@RoutePage(name: 'HomesEmptyRouter')
class HomesEmptyRouterPage extends AutoRouter {}

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightBG,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('2 июня, четверг'),
                Text('Начни новое дело!'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 25, left: 18, right: 45),
              decoration: BoxDecoration(
                  color: AppColor.lightBGItem,
                  border: AppLayout.primaryBorder,
                  borderRadius: AppLayout.primaryRadius,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      spreadRadius: 0,
                    )
                  ],
                  image: const DecorationImage(
                      alignment: Alignment.bottomRight,
                      image: AssetImage('assets/images/4.png'))),
              child: RichText(
                text: const TextSpan(
                  text: 'Пропущенное дело',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w800),
                  children: [
                    TextSpan(
                      text: ' можно выполнить в выходной день.',
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 18, right: 18),
              decoration: AppLayout.boxDecorationShadowBG,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(34)),
                    child: Column(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                              color: AppColor.primary,
                              borderRadius: BorderRadius.circular(34)),
                          child: const Center(
                            child: Text(
                              'ПН',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Container(
                          height: 24,
                          padding: EdgeInsets.only(bottom: 3),
                          decoration: BoxDecoration(
                              color: AppColor.primary,
                              borderRadius: AppLayout.primaryRadius),
                          child: SvgPicture.asset(
                            'assets/icons/checked_day.svg',
                            height: 24,
                            clipBehavior: Clip.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(34)),
                    child: Column(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                              color: AppColor.primary,
                              borderRadius: BorderRadius.circular(34)),
                          child: const Center(
                            child: Text(
                              'ВТ',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Container(
                          height: 24,
                          padding: EdgeInsets.only(bottom: 3),
                          decoration: BoxDecoration(
                              color: AppColor.primary,
                              borderRadius: BorderRadius.circular(34)),
                          child: SvgPicture.asset(
                            'assets/icons/checked_day.svg',
                            height: 24,
                            clipBehavior: Clip.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(34)),
                    child: Column(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                              color: AppColor.primary,
                              borderRadius: BorderRadius.circular(34)),
                          child: const Center(
                            child: Text(
                              'СР',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Container(
                          height: 24,
                          padding: EdgeInsets.only(bottom: 3),
                          decoration: BoxDecoration(
                              color: AppColor.primary,
                              borderRadius: BorderRadius.circular(34)),
                          child: SvgPicture.asset(
                            'assets/icons/checked_day.svg',
                            height: 24,
                            clipBehavior: Clip.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(34)),
                    child: Column(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                              color: AppColor.primary,
                              borderRadius: BorderRadius.circular(34)),
                          child: const Center(
                            child: Text(
                              'ЧТ',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Container(
                          height: 24,
                          padding: EdgeInsets.only(bottom: 3),
                          decoration: BoxDecoration(
                              color: AppColor.primary,
                              borderRadius: BorderRadius.circular(34)),
                          child: SvgPicture.asset(
                            'assets/icons/checked_day.svg',
                            height: 24,
                            clipBehavior: Clip.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColor.blk,
                        borderRadius: BorderRadius.circular(34)),
                    child: Column(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                              color: AppColor.blk,
                              borderRadius: BorderRadius.circular(34)),
                          child: const Center(
                            child: Text(
                              'ПТ',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Container(
                          height: 24,
                          padding: EdgeInsets.only(bottom: 3),
                          decoration: BoxDecoration(
                              color: AppColor.blk,
                              borderRadius: AppLayout.primaryRadius),
                          child: SvgPicture.asset(
                            'assets/icons/missed_day.svg',
                            height: 24,
                            clipBehavior: Clip.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColor.grey1,
                        borderRadius: BorderRadius.circular(34)),
                    child: Column(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                              color: AppColor.primary,
                              borderRadius: BorderRadius.circular(34)),
                          child: const Center(
                            child: Text(
                              'СБ',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Container(
                          height: 28,
                          width: 34,
                          decoration: BoxDecoration(
                              // color: AppColor.primary,
                              borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(34),
                            bottomRight: Radius.circular(34),
                          )),
                          child: const Center(
                            child: Text(
                              '-',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColor.grey1,
                        borderRadius: BorderRadius.circular(34)),
                    child: Column(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                              color: AppColor.primary,
                              borderRadius: BorderRadius.circular(34)),
                          child: const Center(
                            child: Text(
                              'ВС',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Container(
                          height: 28,
                          width: 34,
                          decoration: BoxDecoration(
                              // color: AppColor.primary,
                              borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(34),
                            bottomRight: Radius.circular(34),
                          )),
                          child: const Center(
                            child: Text(
                              '12:30',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 18, right: 45),
              decoration: AppLayout.boxDecorationShadowBG,
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    child: CircularPercentIndicator(
                      radius: 30,
                      percent: 0.35,
                      center: Text(
                        '35%',
                        style: TextStyle(
                            color: AppColor.accentBOW,
                            fontSize: AppFont.large,
                            fontWeight: FontWeight.w800),
                      ),
                      progressColor: AppColor.accentBOW,
                      backgroundColor: AppColor.grey1,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ты на первой неделе',
                          style: AppFont.largeExtraBold,
                        ),
                        Text(
                          '65% осталось до полного выполнения дела',
                          style: AppFont.smallNormal,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 4,
                  fit: FlexFit.tight,
                  child: ElevatedButton(
                    onPressed: () {
                      context.router.push(const TodoEmptyRouter());
                    },
                    style: AppLayout.primaryBTNStyle,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/todo_home_screen.svg'),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Перечень дел',
                            style: AppFont.regularSemibold,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Flexible(
                  flex: 3,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: AppLayout.primaryBTNStyle,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/rules_home_screen.svg'),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Правила',
                            style: AppFont.regularSemibold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          const VideoBox(),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {
                context.router.push(const DayResultsSaveScreenRoute());
              },
              style: AppLayout.accentBowBTNStyle,
              child: Text(
                'Внести результаты',
                style: AppFont.regularSemibold,
              ),
            ),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}

class VideoBox extends StatefulWidget {
  const VideoBox({Key? key}) : super(key: key);

  @override
  State<VideoBox> createState() => _VideoBoxState();
}

class _VideoBoxState extends State<VideoBox> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;
  bool isPlay = false;

  @override
  void initState() {
    videoPlayerController = VideoPlayerController.network(
        AppRemoteAssets().videoAssets() + '/1.mp4');

    videoPlayerController.initialize().then((_) {
      setState(() {});
    });

    chewieController = ChewieController(
      showOptions: false,
      videoPlayerController: videoPlayerController,
      aspectRatio: 16 / 9,
    );

    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PageController pageController =
        PageController(viewportFraction: 0.85);

    return SizedBox(
      height: 200,
      child: PageView(
        controller: pageController,
        onPageChanged: (index) {
          print(index);
        },
        padEnds: false,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: ClipRRect(
              borderRadius: AppLayout.primaryRadius,
              clipBehavior: Clip.hardEdge,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/placeholder.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset('assets/icons/lock_video.svg'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: ClipRRect(
              borderRadius: AppLayout.primaryRadius,
              clipBehavior: Clip.hardEdge,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/placeholder.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset('assets/icons/lock_video.svg'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: ClipRRect(
              borderRadius: AppLayout.primaryRadius,
              clipBehavior: Clip.hardEdge,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/placeholder.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset('assets/icons/lock_video.svg'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: ClipRRect(
              borderRadius: AppLayout.primaryRadius,
              clipBehavior: Clip.hardEdge,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/placeholder.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset('assets/icons/lock_video.svg'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
