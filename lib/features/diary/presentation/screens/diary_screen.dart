import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/show_closeApp_dialog.dart';
import '../../domain/entities/diary_note_entity.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/services/controllers/service_locator.dart';
import '../../../../core/services/db_client/isar_service.dart';
import '../../../../core/utils/circular_loading.dart';
import '../../../planning/data/sources/local/stream_local_storage.dart';
import '../../../planning/presentation/stream_controller.dart';
import '../bloc/diary_bloc.dart';
import '../widgets/diary_calendar_widget.dart';
import '../widgets/diary_day_results_widget.dart';
import '../widgets/diary_note_widget.dart';

@RoutePage(name: 'DiaryEmptyRouter')
class DiaryEmptyRouterPage extends AutoRouter {}

@RoutePage()
class DiaryScreen extends StatefulWidget {
  const DiaryScreen({Key? key}) : super(key: key);

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  bool isSaving = true;

  @override
  Widget build(BuildContext context) {
    TextEditingController noteController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final isarService = IsarService();
    final _streamController = getIt<StreamController>();
    final streamLocalStorage = StreamLocalStorage();

    return WillPopScope(
      onWillPop: () async {
        final closeApp = await showCloseAppDialog(context);
        return closeApp ?? false;
      },
      child: Scaffold(
        backgroundColor: AppColor.lightBG,
        appBar: AppBar(
          backgroundColor: AppColor.lightBG,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'Дневник',
            style: AppFont.scaffoldTitleDark,
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.info_outline_rounded,
                color: AppColor.primary,
              ),
              color: Colors.black,
              onPressed: () {
                context.router.push(const DiaryRulesScreenRoute());
              },
            ),
          ],
        ),
        body: ListView(
          children: [
            Text(
              'Сегодня: ${DateFormat('dd MMMM, EEEE', 'ru_RU').format(DateTime.now())}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                // padding:
                //     const EdgeInsets.only(top: 7, bottom: 7, left: 18, right: 18),
                decoration: AppLayout.boxDecorationShadowBG,
                child: Theme(
                  data: ThemeData().copyWith(
                    dividerColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    maintainState: true,
                    tilePadding: const EdgeInsets.only(top: 7, bottom: 7, left: 18, right: 18),
                    title: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Календарь',
                              style: AppFont.scaffoldTitleDark,
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Contents
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 5,
                          right: 5,
                        ),
                        child: DiaryCalendarWidget(),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const DiaryDayResultsWidget(),
            const SizedBox(height: 15),
            const DiaryNoteWidget(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: AppLayout.boxDecorationShadowBGBorderNone,
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    controller: noteController,
                    validator: (value) {
                      if (value == null || value
                          .trim()
                          .isEmpty) {
                        return 'Заполните обязательное поле!';
                      }
                      return null;
                    },
                    style: TextStyle(fontSize: AppFont.small, color: AppColor.blk),
                    maxLines: 5,
                    maxLength: 255,
                    autofocus: false,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColor.lightBGItem,
                        hintText: 'Написать заметку',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        isDense: true,
                        errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.redAccent),
                            borderRadius: AppLayout.primaryRadius),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: AppLayout.primaryRadius,
                          borderSide: BorderSide(width: 1, color: AppColor.lightBGItem),
                        )),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: isSaving ? ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    // CircularLoading(context).startLoading();
                    setState(() {
                      isSaving = false;
                    });
                    var user = await isarService.getUser();

                    Map diaryNoteData = {
                      'user_id': user.single.id,
                      'note': noteController.text,
                      'created_at': DateTime.now().toString(),
                      'updated_at': DateTime.now().toString(),
                    };

                    // print('diaryNote: $diaryNoteData');
                    // create note on server
                    var createNoteResults = await _streamController.createDiaryNote(diaryNoteData);

                    // print('createNoteResults: $createNoteResults');
                    // save on local
                    var lastNote = await streamLocalStorage.createDiaryNote(createNoteResults);

                    if (lastNote != null) {
                      // print('localNote: ${localNote.id}');
                      if (context.mounted) {
                        DiaryNote note = lastNote;
                        Map _lastNote = {
                          'id': note.id,
                          'diaryNote': note.diaryNote,
                          'createAt': note.createAt,
                          'updateAt': note.updateAt,
                        };
                        context.read<DiaryBloc>().add(DiaryLastNoteChanged(_lastNote));
                        noteController.clear();

                        setState(() {
                          isSaving = true;
                        });

                        // CircularLoading(context).stopAutoRouterLoading();
                        // FocusScope.of(context).unfocus();
                      }
                    }
                  }
                },
                style: AppLayout.accentBTNStyle,
                child: Text(
                  'Добавить заметку',
                  style: AppFont.regularSemibold,
                ),
              ) : const Center(child: CircularProgressIndicator()),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
