import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isar/isar.dart';
import '../../widgets/archive_total_box.dart';
import '../../../../../core/constants/app_theme.dart';
import '../../../../../core/services/db_client/isar_service.dart';
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
          CompletedDaysWidget(stream: stream),
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

class CompletedDaysWidget extends StatefulWidget {
  final NPStream stream;

  const CompletedDaysWidget({super.key, required this.stream});

  @override
  State<CompletedDaysWidget> createState() => _CompletedDaysWidgetState();
}

class _CompletedDaysWidgetState extends State<CompletedDaysWidget> {
  late Future _completedDays;
  late NPStream stream;

  @override
  void initState() {
    stream = widget.stream;
    _completedDays = getStreamCompletedDays(stream);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _completedDays,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map days = snapshot.data;

          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Выполнено ${days['completed']}',
              style: TextStyle(fontWeight: FontWeight.w600, color: AppColor.deep, fontSize: AppFont.regular),
              children: <TextSpan>[
                TextSpan(text: ' из ${days['total']} дней', style: const TextStyle(fontWeight: FontWeight.normal)),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

Future<Map?> getStreamCompletedDays(NPStream strm) async {
  Map completedDays = {};

  final isarService = IsarService();
  final isar = await isarService.db;
  final stream = await isar.nPStreams.filter().idEqualTo(strm.id).findFirst();

  int weeks = stream!.weeks!;
  int days = 6 * weeks;

  // формируем завершенные дни
  List weekIds = stream.weekBacklink.map((week) => week.id).toList();

  ///////////////////////////////
  // Завершенные дни
  ///////////////////////////////
  List daysIdCompleted = [];
  for (int i = 0; i < weekIds.length; i++) {
    List daysInWeek = await isar.days.filter().weekIdEqualTo(weekIds[i]).completedAtIsNotNull().findAll();
    daysIdCompleted.addAll(daysInWeek);
  }

  completedDays['total'] = days;
  completedDays['completed'] = daysIdCompleted.length;

  return completedDays;
}
