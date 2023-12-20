import 'package:auto_route/auto_route.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/routes/app_router.dart';
import 'package:video_player/video_player.dart';

@RoutePage()
class WelcomeDescriptionScreen extends StatefulWidget {
  const WelcomeDescriptionScreen({super.key});

  @override
  State<WelcomeDescriptionScreen> createState() => _WelcomeDescriptionScreenState();
}

class _WelcomeDescriptionScreenState extends State<WelcomeDescriptionScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;
  bool isPlay = false;

  @override
  void initState() {
    // videoPlayerController = VideoPlayerController.network('${AppRemoteAssets().videoAssets()}/1.mp4');
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse("${AppRemoteAssets().videoAssets()}/0.mp4"));

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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Как прокачать себя',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            color: Colors.black,
            onPressed: () {
              // _scaffoldKey.currentState!.openEndDrawer();
              context.router.push(const RuleOfAppScreenRoute());
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        decoration: const BoxDecoration(color: Colors.white),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
            const SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColor.accentBOW,
                borderRadius: AppLayout.primaryRadius,
              ),
              child: ClipRRect(
                borderRadius: AppLayout.primaryRadius,
                child: Stack(
                  children: [
                    Positioned(
                      top: -20,
                      right: -60,
                      child: Image.asset(
                        'assets/images/19.png',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 80),
                      child: Text(
                        'Посмотрите видео и получите первый ключ к навыку',
                        style: TextStyle(color: Colors.white, fontSize: AppFont.regular),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 260,
              decoration: BoxDecoration(
                borderRadius: AppLayout.primaryRadius,
                // color: Colors.yellowAccent,
              ),
              child: isPlay
                  ? Chewie(controller: chewieController)
                  : FittedBox(
                      fit: BoxFit.contain,
                      child: ClipRRect(
                        borderRadius: AppLayout.primaryRadius,
                        child: Stack(
                          children: [
                            Image.asset('assets/images/placeholder_0.png'),
                            Positioned(
                              top: 0,
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: Container(
                                color: Colors.black.withAlpha(150),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    chewieController = ChewieController(
                                      aspectRatio: 16 / 9,
                                      autoPlay: true,
                                      showOptions: false,
                                      videoPlayerController: VideoPlayerController.networkUrl(
                                          Uri.parse("${AppRemoteAssets().videoAssets()}/0.mp4")),
                                      deviceOrientationsAfterFullScreen: [
                                        DeviceOrientation.portraitUp,
                                      ],
                                    );
                                    isPlay = true;
                                  });
                                },
                                icon: SvgPicture.asset('assets/icons/play_arrow.svg'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            const SizedBox(
              height: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: '1. Выберите полезное дело, которое ',
                    style: TextStyle(color: Colors.black, fontSize: AppFont.regular),
                    children: const [
                      TextSpan(text: 'давно хочется сделать ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: ', но оно все откладывается'),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: '2. Три недели старайтесь делать его',
                    style: TextStyle(color: Colors.black, fontSize: AppFont.regular),
                  ),
                ),
                const SizedBox(height: 15),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: '3. Отмечайте появление желаний отложить дело и забросить курс',
                    style: TextStyle(color: Colors.black, fontSize: AppFont.regular),
                  ),
                ),
                const SizedBox(height: 15),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: '4. Смотрите видео и тренируйте способ правильно приступать к делу',
                    style: TextStyle(color: Colors.black, fontSize: AppFont.regular),
                  ),
                ),
                const SizedBox(height: 15),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: 'Воля станет сильнее, а отвлекающие привычки – слабее',
                    style: TextStyle(color: Colors.black, fontSize: AppFont.regular),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  chewieController.pause();
                });
                context.router.push(StartDateSelectionScreenRoute(isBackLeading: true, isShowWeeksSelect: false));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.accent,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: AppLayout.primaryRadius),
              ),
              child: const Text(
                'Продолжить',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
