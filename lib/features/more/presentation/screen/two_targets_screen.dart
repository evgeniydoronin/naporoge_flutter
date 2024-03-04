import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isar/isar.dart';
import '../../../planning/domain/entities/stream_entity.dart';

import '../../../../core/constants/app_theme.dart';
import '../../../../core/services/controllers/service_locator.dart';
import '../../../../core/services/db_client/isar_service.dart';
import '../../../../core/utils/circular_loading.dart';
import '../../../../core/utils/get_stream_data.dart';
import '../../../planning/data/sources/local/stream_local_storage.dart';
import '../../../planning/presentation/stream_controller.dart';

@RoutePage()
class TwoTargetScreen extends StatefulWidget {
  const TwoTargetScreen({super.key});

  @override
  State<TwoTargetScreen> createState() => _TwoTargetScreenState();
}

class _TwoTargetScreenState extends State<TwoTargetScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController minimumEditingController = TextEditingController();
  TextEditingController targetOneTitleEditingController = TextEditingController();
  TextEditingController targetOneDescriptionEditingController = TextEditingController();
  TextEditingController targetTwoTitleEditingController = TextEditingController();
  TextEditingController targetTwoDescriptionEditingController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleEditingController.dispose();
    minimumEditingController.dispose();
    targetOneTitleEditingController.dispose();
    targetOneDescriptionEditingController.dispose();
    targetTwoTitleEditingController.dispose();
    targetTwoDescriptionEditingController.dispose();
    super.dispose();
  }

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
          'Две цели дела',
          style: AppFont.scaffoldTitleDark,
        ),
      ),
      body: FutureBuilder(
        future: getTwoTargets(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            TwoTarget? target = snapshot.data != 0 ? snapshot.data : null;

            titleEditingController = TextEditingController(text: target?.title);
            minimumEditingController = TextEditingController(text: target?.minimum);
            targetOneTitleEditingController = TextEditingController(text: target?.targetOneTitle);
            targetOneDescriptionEditingController = TextEditingController(text: target?.targetOneDescription);
            targetTwoTitleEditingController = TextEditingController(text: target?.targetTwoTitle);
            targetTwoDescriptionEditingController = TextEditingController(text: target?.targetTwoDescription);

            return ListView(
              children: [
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
                            decoration: AppLayout.boxDecorationShadowBG,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Дело',
                                  style: AppFont.formLabel,
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  controller: titleEditingController,
                                  style: TextStyle(fontSize: AppFont.small),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColor.grey1,
                                    hintText: 'Развивающее дело',
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                                    isDense: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: AppLayout.smallRadius,
                                      borderSide: BorderSide(width: 1, color: AppColor.grey1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
                            decoration: AppLayout.boxDecorationShadowBG,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Минимум для разового выполнения дела:',
                                        style: AppFont.formLabel,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  controller: minimumEditingController,
                                  style: TextStyle(fontSize: AppFont.small),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColor.grey1,
                                    hintText: 'Например, 10 отжиманий, 5 страниц, 2 км',
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                                    isDense: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: AppLayout.smallRadius,
                                      borderSide: BorderSide(width: 1, color: AppColor.grey1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
                            decoration: AppLayout.boxDecorationShadowBG,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Цель 1. «Внешняя»',
                                        style: AppFont.formLabel,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  controller: targetOneTitleEditingController,
                                  style: TextStyle(fontSize: AppFont.small),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColor.grey1,
                                    hintText: 'Укажите одну цель, основную',
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                                    isDense: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: AppLayout.smallRadius,
                                      borderSide: BorderSide(width: 1, color: AppColor.grey1),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: targetOneDescriptionEditingController,
                                  style: TextStyle(fontSize: AppFont.small),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColor.grey1,
                                    hintText: 'Количествоенное выражение, например, 5 кг',
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                                    isDense: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: AppLayout.smallRadius,
                                      borderSide: BorderSide(width: 1, color: AppColor.grey1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
                            decoration: AppLayout.boxDecorationShadowBG,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Цель 2. «Внутренняя»',
                                        style: AppFont.formLabel,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  controller: targetTwoTitleEditingController,
                                  style: TextStyle(fontSize: AppFont.small),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColor.grey1,
                                    hintText: 'Укажите одно или максимум два качества',
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                                    isDense: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: AppLayout.smallRadius,
                                      borderSide: BorderSide(width: 1, color: AppColor.grey1),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: targetTwoDescriptionEditingController,
                                  style: TextStyle(fontSize: AppFont.small),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColor.grey1,
                                    hintText: 'Признаки внутренних изменений',
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                                    isDense: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: AppLayout.smallRadius,
                                      borderSide: BorderSide(width: 1, color: AppColor.grey1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      CircularLoading(context).startLoading();

                                      final isarService = IsarService();
                                      final isar = await isarService.db;
                                      final stream = await isar.nPStreams.filter().isActiveEqualTo(true).findFirst();
                                      TwoTarget? twoTargets = await isar.twoTargets.where().findFirst();
                                      final streamController = getIt<StreamController>();
                                      final storageController = StreamLocalStorage();

                                      Map twoTargetData = {
                                        'stream_id': stream?.id,
                                      };

                                      twoTargetData['id'] = twoTargets?.id;

                                      /// заголовок
                                      twoTargetData['title'] =
                                          titleEditingController.text.isNotEmpty ? titleEditingController.text : null;

                                      /// минимум
                                      twoTargetData['minimum'] = minimumEditingController.text;

                                      /// цель 1 ключ
                                      twoTargetData['target_one_title'] = targetOneTitleEditingController.text;

                                      /// цель 1 значение
                                      twoTargetData['target_one_description'] =
                                          targetOneDescriptionEditingController.text;

                                      /// цель 2 ключ
                                      twoTargetData['target_two_title'] = targetTwoTitleEditingController.text;

                                      /// цель 2 значение
                                      twoTargetData['target_two_description'] =
                                          targetTwoDescriptionEditingController.text;

                                      print('twoTargetData 1: $twoTargetData');

                                      /// create
                                      if (twoTargets == null) {
                                        print('create two targets');
                                        final twoTargetsServerData =
                                            await streamController.createTwoTargets(twoTargetData);
                                        print('twoTargetsServerData: $twoTargetsServerData');
                                        await storageController.createTwoTargets(twoTargetsServerData);
                                      }

                                      /// update
                                      else {
                                        print('update two targets');
                                        print('twoTargetData 2: $twoTargetData');
                                        final twoTargetsServerData =
                                            await streamController.createTwoTargets(twoTargetData);
                                        print('twoTargetsServerData: $twoTargetsServerData');
                                        await storageController.updateTwoTargets(twoTargetsServerData);
                                      }

                                      // print('editTwoTargets: $editTwoTargets');
                                      //
                                      // // save on local
                                      // await storageController.editTwoTargets(editTwoTargets);

                                      // /// create
                                      // if (twoTargets == null) {
                                      //   // create on server
                                      //
                                      // }
                                      //
                                      // /// update
                                      // else {
                                      //   print('update');
                                      //   twoTargetData['id'] = twoTargets.id;
                                      //   twoTargetData['stream_id'] = stream?.id;
                                      //   print('twoTargetData: $twoTargetData');
                                      //   // update on server
                                      //   final updateTwoTargets = await streamController.updateTwoTargets(twoTargetData);
                                      //
                                      //   print('updateTwoTargets: $updateTwoTargets');
                                      //   // update on local
                                      //   await storageController.updateTwoTargets(updateTwoTargets);
                                      // }

                                      if (context.mounted) {
                                        CircularLoading(context).stopLoading();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Успешно сохранено'),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  style: AppLayout.accentBowBTNStyle,
                                  child: Text(
                                    'Сохранить',
                                    style: AppFont.regularSemibold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                      ],
                    )),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
