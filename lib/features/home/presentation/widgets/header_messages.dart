import 'package:flutter/material.dart';
import '../../utils/get_home_status.dart';

class HeaderMessageWidget extends StatelessWidget {
  const HeaderMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getHomeStatus(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          final message = snapshot.data['topMessage'];
          return Text(message['text']);
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
