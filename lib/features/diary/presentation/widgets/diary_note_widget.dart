import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/routes/app_router.dart';

import '../../../../core/constants/app_theme.dart';
import '../../../../core/services/db_client/isar_service.dart';
import '../../domain/entities/diary_note_entity.dart';
import '../bloc/diary_bloc.dart';
import '../utils/get_diary_last_note.dart';

class DiaryNoteWidget extends StatefulWidget {
  const DiaryNoteWidget({super.key});

  @override
  State<DiaryNoteWidget> createState() => _DiaryNoteWidgetState();
}

class _DiaryNoteWidgetState extends State<DiaryNoteWidget> {
  DateTime? firstDayOfCurrentMonth;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DiaryBloc, DiaryState>(
      listener: (context, state) {},
      builder: (context, state) {
        firstDayOfCurrentMonth = state.lastNote['createAt'];

        if (state.currentMonth.isNotEmpty) {
          firstDayOfCurrentMonth = state.currentMonth['currentDay'];
          print('state.currentMonth.isNotEmpty: $firstDayOfCurrentMonth');
        } else {
          firstDayOfCurrentMonth = DateTime.now();
          print('state.currentMonth.isEmpty: $firstDayOfCurrentMonth');
        }

        return FutureBuilder(
          future: getDiaryLastNote(firstDayOfCurrentMonth),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              DiaryNote note = snapshot.data;

              String text = note.diaryNote!;
              String createAt = DateFormat('dd.MM.yyyy / HH:mm').format(note.createAt!);

              return Padding(
                padding: EdgeInsets.only(right: AppLayout.contentPadding, left: AppLayout.contentPadding, bottom: 15),
                child: Container(
                  decoration: AppLayout.boxDecorationShadowBG,
                  child: Theme(
                    data: ThemeData().copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      maintainState: true,
                      tilePadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 18),
                      title: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Заметки',
                                style: AppFont.scaffoldTitleDark,
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Contents
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                                decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide(width: 1, color: AppColor.grey1),
                                        bottom: BorderSide(width: 1, color: AppColor.grey1))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      createAt,
                                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: AppFont.smaller),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      text,
                                      style: TextStyle(color: AppColor.blk),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            context.router.push(DiaryItemsScreenRoute(dateTime: note.createAt!));
                          },
                          child: Text(
                            'Посмотреть все заметки',
                            style: TextStyle(
                                color: AppColor.primary, fontSize: AppFont.small, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        );
      },
    );
  }
}

Future getNote(noteId) async {
  await Future.delayed(const Duration(milliseconds: 200));
  final isarService = IsarService();
  final isar = await isarService.db;

  DiaryNote? note;

  note = await isar.diaryNotes.get(noteId);

  return note;
}
