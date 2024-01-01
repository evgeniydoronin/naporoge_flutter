import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:naporoge/core/routes/app_router.dart';
import '../../features/planning/data/sources/local/stream_local_storage.dart';
import '../../features/planning/domain/entities/stream_entity.dart';
import '../../features/planning/presentation/stream_controller.dart';
import '../constants/app_theme.dart';
import '../services/controllers/service_locator.dart';
import '../services/db_client/isar_service.dart';
import 'circular_loading.dart';

Future extendStreamDialog(context) async {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        'Продлить Дело?',
        textAlign: TextAlign.center,
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                  style: AppLayout.accentBTNStyle,
                  onPressed: () async {
                    await expandFirstStream(context);
                    if (context.mounted) {
                      Navigator.pop(context, false);
                      context.replaceRoute(const HomesEmptyRouter());
                    }
                  },
                  child: Text(
                    'Да',
                    style: AppFont.largeSemibold,
                  )),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Отмена',
                  style: TextStyle(color: AppColor.grey3),
                )),
          ],
        ),
      ],
      titlePadding: AppLayout.dialogTitlePadding,
      actionsPadding: AppLayout.dialogTitlePadding,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      titleTextStyle: AppLayout.dialogTitleTextStyle,
      shape: AppLayout.dialogShape,
    ),
  );
}

Future expandFirstStream(context) async {
  final streamController = getIt<StreamController>();
  final streamLocalStorage = StreamLocalStorage();
  final isarService = IsarService();
  final isar = await isarService.db;
  final NPStream? activeStream = await isar.nPStreams.filter().isActiveEqualTo(true).findFirst();
  CircularLoading(context).startLoading();
  // print('activeStream: ${activeStream!.id}');
  // обновляем курс
  Map streamData = {
    "stream_id": activeStream!.id,
    "weeks": 9,
  };

  print('update streamData: $streamData');

  // expand on server
  var expandStream = await streamController.expandStream(streamData);

  // expand on local
  if (expandStream['stream']['id'] != null) {
    await streamLocalStorage.updateStream(expandStream);
  }

  if (context.mounted) {
    CircularLoading(context).stopLoading();
  }
}
