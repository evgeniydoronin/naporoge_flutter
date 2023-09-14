import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:naporoge/features/planning/domain/entities/stream_entity.dart';

import '../../../../../core/constants/app_theme.dart';
import '../../../../../core/services/db_client/isar_service.dart';
import '../../bloc/save_day_result/day_result_bloc.dart';

class RejoiceBox extends StatefulWidget {
  const RejoiceBox({super.key});

  @override
  State<RejoiceBox> createState() => _RejoiceBoxState();
}

class _RejoiceBoxState extends State<RejoiceBox> {
  final List<bool> _selections = List.generate(2, (_) => false);
  late Future _getRejoiceBox;

  @override
  void initState() {
    _getRejoiceBox = getRejoiceBox();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getRejoiceBox,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
                decoration: AppLayout.boxDecorationShadowBG,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Удалось порадоваться?',
                      style: AppFont.formLabel,
                    ),
                    const SizedBox(height: 5),
                    ToggleButtons(
                      direction: Axis.horizontal,
                      onPressed: (int index) {
                        if (index == 0) {
                          context.read<DayResultBloc>().add(const RejoiceChanged('no'));
                        } else {
                          context.read<DayResultBloc>().add(const RejoiceChanged('yes'));
                        }
                        setState(() {
                          // The button that is tapped is set to true, and the others to false.
                          for (int i = 0; i < _selections.length; i++) {
                            _selections[i] = i == index;
                          }
                        });
                      },
                      borderWidth: 0,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      // selectedBorderColor: Colors.red[700],
                      selectedColor: Colors.white,
                      fillColor: AppColor.accent,
                      constraints: const BoxConstraints(
                        minHeight: 40.0,
                        minWidth: double.minPositive,
                      ),
                      isSelected: _selections,
                      children: [
                        SizedBox(
                            width: (MediaQuery
                                .of(context)
                                .size
                                .width - 81) / 2,
                            child: RotatedBox(
                              quarterTurns: 2,
                              child: SvgPicture.asset('assets/icons/342.svg'),
                            )),
                        SizedBox(
                            width: (MediaQuery
                                .of(context)
                                .size
                                .width - 81) / 2,
                            child: SvgPicture.asset('assets/icons/342.svg')),
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

Future getRejoiceBox() async {
  bool? preview;

  final isarService = IsarService();
  final isar = await isarService.db;
  List allStreams = await isar.nPStreams.where().findAll();

  final stream = await isar.nPStreams.filter().isActiveEqualTo(true).findFirst();

  // активируем сразу на втором курсе
  if (allStreams.length > 1) {
    preview = true;
  }
  // если первый курс - выводим в субботу
  else {
    DateTime now = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    DateTime streamStartAt = DateTime.parse(DateFormat('yyyy-MM-dd').format(stream!.startAt!));
    DateTime firstSaturday = streamStartAt.add(const Duration(days: 5));

    if (now.isAfter(firstSaturday) || now.isAtSameMomentAs(firstSaturday)) {
      preview = true;
    }
  }

  return preview;
}
