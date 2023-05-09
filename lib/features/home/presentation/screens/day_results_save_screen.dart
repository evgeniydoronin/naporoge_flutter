import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/routes/app_router.dart';

import '../../../../core/constants/app_theme.dart';

@RoutePage()
class DayResultsSaveScreen extends StatelessWidget {
  const DayResultsSaveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightBG,
      appBar: AppBar(
        backgroundColor: AppColor.lightBG,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            context.router.pop();
          },
          icon: RotatedBox(
              quarterTurns: 2,
              child: SvgPicture.asset('assets/icons/arrow.svg')),
        ),
        title: Text(
          'Внесите результаты',
          style: AppFont.scaffoldTitleDark,
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 15, left: 18, right: 18),
              decoration: AppLayout.boxDecorationShadowBG,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Время начала дела', style: AppFont.formLabel),
                  const SizedBox(height: 5),
                  TextField(
                    style: TextStyle(fontSize: AppFont.small),
                    readOnly: true,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColor.grey1,
                        hintText: '10:45',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 10),
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: AppLayout.smallRadius,
                            borderSide:
                                BorderSide(width: 1, color: AppColor.grey1))),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 0, left: 18, right: 18),
              decoration: AppLayout.boxDecorationShadowBG,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Объем выполнения', style: AppFont.formLabel),
                      Text('100%', style: AppFont.formLabel),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const SliderBox(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 15, left: 18, right: 18),
              decoration: AppLayout.boxDecorationShadowBG,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Результат дня',
                    style: AppFont.formLabel,
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    style: TextStyle(fontSize: AppFont.small),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColor.grey1,
                        hintText: '10 кругов',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 10),
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: AppLayout.smallRadius,
                            borderSide:
                                BorderSide(width: 1, color: AppColor.grey1))),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Flexible(
                    child: WishBox(
                  title: 'Сила желаний',
                )),
                SizedBox(width: 20),
                Flexible(
                    child: WishBox(
                  title: 'Сила нежеланий',
                )),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 15, left: 18, right: 18),
              decoration: AppLayout.boxDecorationShadowBG,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Иные помехи и трудности',
                    style: AppFont.formLabel,
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    style: TextStyle(fontSize: AppFont.small),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColor.grey1,
                        hintText: 'Запишите все, что мешало выполнять дело',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 10),
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: AppLayout.smallRadius,
                            borderSide:
                                BorderSide(width: 1, color: AppColor.grey1))),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 15, left: 18, right: 18),
              decoration: AppLayout.boxDecorationShadowBG,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Удалось порадоваться?',
                    style: AppFont.formLabel,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RotatedBox(
                        quarterTurns: 2,
                        child: IconButton(
                            onPressed: () {},
                            icon: SvgPicture.asset('assets/icons/342.svg')),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset('assets/icons/342.svg')),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {
                context.router.push(const ResultsStreamScreenRoute());
              },
              style: AppLayout.accentBowBTNStyle,
              child: Text(
                'Итоги работы',
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

class SliderBox extends StatefulWidget {
  const SliderBox({Key? key}) : super(key: key);

  @override
  State<SliderBox> createState() => _SliderBoxState();
}

class _SliderBoxState extends State<SliderBox> {
  double _currentSliderValue = 20;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackShape: CustomTrackShape(),
      ),
      child: Slider(
        value: _currentSliderValue,
        max: 100,
        onChanged: (double value) {
          setState(() {
            _currentSliderValue = value;
          });
        },
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

enum WishPower { small, middle, large }

class WishBox extends StatefulWidget {
  final String title;

  const WishBox({Key? key, required this.title}) : super(key: key);

  @override
  State<WishBox> createState() => _WishBoxState();
}

class _WishBoxState extends State<WishBox> {
  WishPower? wishPower = WishPower.small;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
      decoration: AppLayout.boxDecorationShadowBG,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            widget.title,
            style: AppFont.formLabel,
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(33, 33),
                  elevation: 0,
                  shape: const CircleBorder(),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {},
                child: SizedBox(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(33, 33),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  side: BorderSide(width: 1, color: AppColor.deep),
                  shape: const CircleBorder(),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {},
                child: SizedBox(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(33, 33),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  side: BorderSide(width: 1, color: AppColor.deep),
                  shape: const CircleBorder(),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {},
                child: SizedBox(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
