import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:naporoge/features/planning/domain/entities/stream_entity.dart';

import '../../../../core/constants/app_theme.dart';
import '../../../../core/services/db_client/isar_service.dart';
import '../../../../core/utils/extend_stream.dart';

class ExpandStreamWidget extends StatelessWidget {
  const ExpandStreamWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: countStreams(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool isExpandStream = snapshot.data;

            if (!isExpandStream) return const SizedBox();

            return Flexible(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
                decoration: AppLayout.boxDecorationOpacityShadowBG,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Продлить Дело на 1 неделю?',
                      style: TextStyle(fontSize: AppFont.large, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Закрепите полезные привычки',
                      style: TextStyle(fontSize: AppFont.smaller, fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              print('продлить');
                              await extendStreamDialog(context);
                            },
                            style: AppLayout.accentBTNStyle,
                            child: Text(
                              'Продлить',
                              style: AppFont.regularSemibold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        });
  }
}

Future countStreams() async {
  bool isExpandStream = false;
  final isarService = IsarService();
  final isar = await isarService.db;
  final stream = await isar.nPStreams.filter().isActiveEqualTo(true).findFirst();
  List streams = await isar.nPStreams.where().findAll();

  if (streams.length == 1 && stream!.weeks! == 3) {
    final mayBeExpandDate = stream.startAt!.add(const Duration(days: 21));
    if (DateTime.now().isBefore(mayBeExpandDate)) {
      isExpandStream = true;
    }
  }
  return isExpandStream;
}
