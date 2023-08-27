import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_theme.dart';

@RoutePage()
class DiaryRulesScreen extends StatelessWidget {
  const DiaryRulesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      appBar: AppBar(
        title: const Text('Пояснения'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColor.primary,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(borderRadius: AppLayout.primaryRadius, color: Colors.white),
              child: const Text(
                '''
Отмечайте все важное:
-что сбивало, мешало выполнять план и даже побуждало забросить дело
-настроения и мысли, которые поддерживали и воодушевляли
-важные идеи по улучшению организации дел и жизни в целом''',
                // style: TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(borderRadius: AppLayout.primaryRadius, color: Colors.white),
              child: const Text(
                'Именно фиксация мешающих факторов позволяет ослабить их силу',
                // style: TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(borderRadius: AppLayout.primaryRadius, color: Colors.white),
              child: const Text(
                'Опыт показывает - если не фиксировать факты, многое забывается',
                // style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
