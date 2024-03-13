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
    final PageController pageController = PageController(viewportFraction: 0.8);

    return FutureBuilder(
        future: getHomeVideos(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List previewVideoIndex = snapshot.data;

            return SizedBox(
              height: 220,
              child: PageView.builder(
                controller: pageController,
                itemCount: 4,
                padEnds: false,
                itemBuilder: (context, pageIndex) {
                  Widget pageContent;

                  if (previewVideoIndex[pageIndex] == 1) {
                    pageContent = VideoPlay(pageIndex: pageIndex);
                  } else {
                    pageContent = ClipRRect(
                      borderRadius: AppLayout.primaryRadius,
                      clipBehavior: Clip.hardEdge,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/images/placeholder_$pageIndex.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                          Positioned.fill(
                            child: IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset('assets/icons/lock_video.svg'),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Container(
                      margin: EdgeInsets.only(
                          left: AppLayout.contentPadding, right: pageIndex == 3 ? AppLayout.contentPadding : 0),
                      child: pageContent);
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

    return ClipRRect(
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
    );
  }
}
