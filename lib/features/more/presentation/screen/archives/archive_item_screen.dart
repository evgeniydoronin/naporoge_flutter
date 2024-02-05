import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naporoge/features/more/presentation/widgets/archive_total_box.dart';
import '../../../../../core/constants/app_theme.dart';
import '../../../../planning/domain/entities/stream_entity.dart';
import '../../widgets/archive_count_week_days_box.dart';
import '../../widgets/archive_stream_chart_box.dart';

@RoutePage()
class ArchiveItemScreen extends StatefulWidget {
  final NPStream stream;

  const ArchiveItemScreen({super.key, required this.stream});

  @override
  State<ArchiveItemScreen> createState() => _ArchiveItemScreenState();
}

class _ArchiveItemScreenState extends State<ArchiveItemScreen> {
  late NPStream stream;

  @override
  void initState() {
    stream = widget.stream;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightBG,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          '${stream.title}',
          style: AppFont.scaffoldTitleDark,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
              decoration: AppLayout.boxDecorationShadowBG,
              child: ArchiveTotalBox(stream: stream),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
              decoration: AppLayout.boxDecorationShadowBG,
              child: ArchiveStreamChartBox(stream: stream),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
              decoration: AppLayout.boxDecorationShadowBG,
              child: ArchiveCountWeekDaysBox(
                stream: stream,
              ),
            ),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
