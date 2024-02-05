import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isar/isar.dart';
import 'package:naporoge/core/routes/app_router.dart';
import '../../../../../core/constants/app_theme.dart';
import '../../../../planning/domain/entities/stream_entity.dart';
import '../../../../../core/services/db_client/isar_service.dart';

@RoutePage()
class ArchivesScreen extends StatefulWidget {
  const ArchivesScreen({super.key});

  @override
  State<ArchivesScreen> createState() => _ArchivesScreenState();
}

class _ArchivesScreenState extends State<ArchivesScreen> {
  late Future _getStreams;

  @override
  void initState() {
    _getStreams = getStreams();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: const Text(
          'Архив дел',
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          onPressed: () {
            context.router.pop();
          },
          icon: RotatedBox(quarterTurns: 2, child: SvgPicture.asset('assets/icons/arrow.svg')),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: _getStreams,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<NPStream> streams = snapshot.data;
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: List.generate(
                      streams.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: InkWell(
                          onTap: () {
                            context.router.push(ArchiveItemScreenRoute(stream: streams[index]));
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
                                      Expanded(
                                        child: Text(
                                          '${streams[index].title}',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Container(
                                        width: 25,
                                        height: 25,
                                        decoration: BoxDecoration(color: AppColor.accent, shape: BoxShape.circle),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            'assets/icons/arrow.svg',
                                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
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
                    ),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}

Future<List<NPStream>> getStreams() async {
  final isarService = IsarService();
  final isar = await isarService.db;

  return await isar.nPStreams.filter().isActiveEqualTo(false).findAll();
}
