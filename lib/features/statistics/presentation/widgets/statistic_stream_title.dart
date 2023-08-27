import 'package:flutter/material.dart';

import '../../../../core/constants/app_theme.dart';
import '../../../planning/data/sources/local/stream_local_storage.dart';
import '../../../planning/domain/entities/stream_entity.dart';

class StreamTitle extends StatefulWidget {
  const StreamTitle({super.key});

  @override
  State<StreamTitle> createState() => _StreamTitleState();
}

class _StreamTitleState extends State<StreamTitle> {
  Future getStream() async {
    final storage = StreamLocalStorage();
    return await storage.getActiveStream();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            NPStream stream = snapshot.data;
            return Text(
              stream.title!,
              style: TextStyle(color: AppColor.accentBOW, fontSize: AppFont.large, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
