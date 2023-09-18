import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/constants/app_theme.dart';
import '../../utils/get_home_videos.dart';

class VideoBox extends StatefulWidget {
  const VideoBox({Key? key}) : super(key: key);

  @override
  State<VideoBox> createState() => _VideoBoxState();
}

class _VideoBoxState extends State<VideoBox> {
  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(viewportFraction: 0.85);

    return FutureBuilder(
        future: getHomeVideos(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List previewVideoIndex = snapshot.data;

            return SizedBox(
              height: 200,
              child: PageView.builder(
                controller: pageController,
                itemCount: 4,
                padEnds: false,
                onPageChanged: (index) {
                  print('videoIndex: $index');
                  // setState(() {
                  //   chewieController.pause();
                  //   isPlay = false;
                  // });
                },
                itemBuilder: (context, pageIndex) {
                  // открываем видео для просмотра
                  if (previewVideoIndex[pageIndex] == 1) {
                    return VideoPlay(pageIndex: pageIndex);
                  }
                  // заблокированное видео
                  return Container(
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
                                  image: AssetImage("assets/images/placeholder_$pageIndex.png"),
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
                  );
                },
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

class VideoPlay extends StatefulWidget {
  final int pageIndex;

  const VideoPlay({super.key, required this.pageIndex});

  @override
  State<VideoPlay> createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  bool isPlay = false;
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  @override
  void initState() {
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse("${AppRemoteAssets().videoAssets()}/${widget.pageIndex}.mp4"));

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
    print('dispose');

    isPlay = false;
    chewieController.pause();
    videoPlayerController.dispose();
    chewieController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int pageIndex = widget.pageIndex;

    // print(Uri.parse("${AppRemoteAssets().videoAssets()}/${widget.pageIndex}.mp4"));

    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: ClipRRect(
        borderRadius: AppLayout.primaryRadius,
        clipBehavior: Clip.hardEdge,
        child: isPlay
            ? Chewie(controller: chewieController)
            : GestureDetector(
                onTap: () {
                  setState(() {
                    chewieController = ChewieController(
                      aspectRatio: 16 / 9,
                      autoPlay: true,
                      showOptions: false,
                      videoPlayerController: VideoPlayerController.networkUrl(
                          Uri.parse("${AppRemoteAssets().videoAssets()}/${widget.pageIndex}.mp4")),
                      deviceOrientationsAfterFullScreen: [
                        DeviceOrientation.portraitUp,
                      ],
                    );
                    isPlay = true;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/placeholder_$pageIndex.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
