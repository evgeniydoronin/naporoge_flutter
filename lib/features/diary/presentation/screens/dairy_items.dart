import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readmore/readmore.dart';
import '../../../../core/constants/app_theme.dart';

@RoutePage()
class DiaryItemsScreen extends StatelessWidget {
  const DiaryItemsScreen({Key? key}) : super(key: key);

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
          icon: RotatedBox(quarterTurns: 2, child: SvgPicture.asset('assets/icons/arrow.svg')),
        ),
        title: Text(
          'Заметки',
          style: AppFont.scaffoldTitleDark,
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColor.grey1))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '04.01.2023 / 13:24',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: AppFont.smaller),
                  ),
                  const SizedBox(height: 5),
                  ReadMoreText(
                    'С другой стороны сложившаяся структура организации обеспечивает широкому кругу (специалистов) участие в формировании существенных финансовых и административных условий. Разнообразный и богатый опыт начало повседневной работы по формированию н позиции',
                    trimLines: 5,
                    colorClickableText: AppColor.red,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'больше',
                    trimExpandedText: ' ...меньше',
                    style: const TextStyle(height: 1.3),
                    moreStyle: TextStyle(color: AppColor.accent),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColor.grey1))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '04.01.2023 / 13:24',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: AppFont.smaller),
                  ),
                  const SizedBox(height: 5),
                  ReadMoreText(
                    'С другой стороны сложившаяся структура организации обеспечивает широкому кругу (специалистов) участие в формировании существенных финансовых и административных условий. Разнообразный и богатый опыт начало повседневной работы по формированию н позиции',
                    trimLines: 5,
                    colorClickableText: AppColor.red,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'больше',
                    trimExpandedText: ' ...меньше',
                    style: const TextStyle(height: 1.3),
                    moreStyle: TextStyle(color: AppColor.accent),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColor.grey1))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '04.01.2023 / 13:24',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: AppFont.smaller),
                  ),
                  const SizedBox(height: 5),
                  ReadMoreText(
                    'С другой стороны сложившаяся структура организации обеспечивает широкому кругу (специалистов) участие в формировании существенных финансовых и административных условий. Разнообразный и богатый опыт начало повседневной работы по формированию н позиции',
                    trimLines: 5,
                    colorClickableText: AppColor.red,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'больше',
                    trimExpandedText: ' ...меньше',
                    style: const TextStyle(height: 1.3),
                    moreStyle: TextStyle(color: AppColor.accent),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColor.grey1))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '04.01.2023 / 13:24',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: AppFont.smaller),
                  ),
                  const SizedBox(height: 5),
                  ReadMoreText(
                    'С другой стороны сложившаяся структура организации обеспечивает широкому кругу (специалистов) участие в формировании существенных финансовых и административных условий. Разнообразный и богатый опыт начало повседневной работы по формированию н позиции',
                    trimLines: 5,
                    colorClickableText: AppColor.red,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'больше',
                    trimExpandedText: ' ...меньше',
                    style: const TextStyle(height: 1.3),
                    moreStyle: TextStyle(color: AppColor.accent),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColor.grey1))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '04.01.2023 / 13:24',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: AppFont.smaller),
                  ),
                  const SizedBox(height: 5),
                  ReadMoreText(
                    'С другой стороны сложившаяся структура организации обеспечивает широкому кругу (специалистов) участие в формировании существенных финансовых и административных условий. Разнообразный и богатый опыт начало повседневной работы по формированию н позиции',
                    trimLines: 5,
                    colorClickableText: AppColor.red,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'больше',
                    trimExpandedText: ' ...меньше',
                    style: const TextStyle(height: 1.3),
                    moreStyle: TextStyle(color: AppColor.accent),
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
