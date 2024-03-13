import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/circular_loading.dart';
import '../../domain/entities/diary_note_entity.dart';
import 'package:readmore/readmore.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/services/controllers/service_locator.dart';
import '../../../../core/services/db_client/isar_service.dart';
import '../../../planning/data/sources/local/stream_local_storage.dart';
import '../../../planning/presentation/stream_controller.dart';
import '../bloc/diary_bloc.dart';
import '../utils/get_all_notes_of_day.dart';

@RoutePage()
class DiaryItemsScreen extends StatefulWidget {
  final DateTime dateTime;

  const DiaryItemsScreen({Key? key, required this.dateTime}) : super(key: key);

  @override
  State<DiaryItemsScreen> createState() => _DiaryItemsScreenState();
}

class _DiaryItemsScreenState extends State<DiaryItemsScreen> {
  TextEditingController noteEditingController = TextEditingController();

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
            // сброс Заметок в Дневнике для Заметок на текущий день
            context.read<DiaryBloc>().add(DiaryLastNoteChanged({'createAt': DateTime.now()}));
            context.router.pop();
          },
          icon: RotatedBox(quarterTurns: 2, child: SvgPicture.asset('assets/icons/arrow.svg')),
        ),
        title: Text(
          'Заметки',
          style: AppFont.scaffoldTitleDark,
        ),
      ),
      body: FutureBuilder(
        future: getAllNotesOfDay(widget.dateTime),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List notes = snapshot.data;
            return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, noteIndex) {
                  DiaryNote note = notes[noteIndex];
                  String createAt = DateFormat('dd.MM.yyyy / HH:mm').format(note.createAt!);

                  return Slidable(
                    // Specify a key if the Slidable is dismissible.
                    key: ValueKey(note.id),

                    // Удаление заметки
                    startActionPane: ActionPane(
                      // A motion is a widget used to control how the pane animates.
                      motion: const ScrollMotion(),

                      // A pane can dismiss the Slidable.
                      // dismissible: DismissiblePane(onDismissed: () async {
                      //   await deleteNote(context, note);
                      //   setState(() {});
                      // }),

                      // All actions are defined in the children parameter.
                      children: [
                        // A SlidableAction can have an icon and/or a label.
                        CustomSlidableAction(
                          onPressed: (val) async {
                            await deleteNote(context, note);
                            setState(() {});
                          },
                          backgroundColor: AppColor.red,
                          foregroundColor: Colors.white,
                          child: SvgPicture.asset('assets/icons/deleteNote.svg'),
                        ),
                      ],
                    ),

                    // Редактирование заметки
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        CustomSlidableAction(
                          onPressed: (val) async {
                            await editNote(context, note);
                            setState(() {});
                          },
                          backgroundColor: AppColor.accent,
                          foregroundColor: Colors.white,
                          child: SvgPicture.asset('assets/icons/editNote.svg'),
                        ),
                      ],
                    ),

                    // The child of the Slidable is what the user sees when the
                    // component is not dragged.
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: AppLayout.contentPadding),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColor.grey1))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              createAt,
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: AppFont.smaller),
                            ),
                            const SizedBox(height: 5),
                            ReadMoreText(
                              note.diaryNote.toString(),
                              trimLines: 5,
                              colorClickableText: AppColor.red,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'больше',
                              trimExpandedText: ' ...меньше',
                              style: const TextStyle(height: 1.3),
                              moreStyle: TextStyle(color: AppColor.accent),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

Future editNote(context, noteData) async {
  final _streamController = getIt<StreamController>();
  final streamLocalStorage = StreamLocalStorage();
  final isarService = IsarService();
  DiaryNote note = noteData;
  final _formKey = GlobalKey<FormState>();
  TextEditingController noteController = TextEditingController(text: note.diaryNote);

  return await showDialog(
    context: context,
    builder: (BuildContext context) => Form(
      key: _formKey,
      child: AlertDialog(
        title: const Text('Редактирование'),
        content: SizedBox(
          height: 150,
          child: CupertinoTheme(
            data: const CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                dateTimePickerTextStyle: TextStyle(fontSize: 26),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 230,
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Заполните обязательное поле!';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColor.grey1,
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0, color: Colors.transparent),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 0, color: Colors.transparent),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    controller: noteController,
                    maxLines: 5,
                  ),
                ),
              ],
            ),
          ),
        ),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(13))),
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.zero,
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: Text(
              'Отменить',
              style: TextStyle(color: AppColor.grey2),
            ),
            onPressed: () async {
              Navigator.pop(context);
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Сохранить'),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                CircularLoading(context).startLoading();
                final isar = await isarService.db;
                await Future.delayed(const Duration(milliseconds: 200));
                Map newNoteData = {'id': note.id, 'note': noteController.text};

                // update note on server
                var updatedNoteResults = await _streamController.updateDiaryNote(newNoteData);

                // {note: {id: 40, user_id: 80, note: 12234, created_at: 2023-09-08 11:59:26, updated_at: 2023-09-08 11:59:26}}
                print('updatedNoteResults: $updatedNoteResults');

                // save on local
                DiaryNote updatedNote = await streamLocalStorage.updateDiaryNote(updatedNoteResults);
                print('updatedNote: $updatedNote');

                if (context.mounted) {
                  Navigator.pop(context);
                  CircularLoading(context).stopAutoRouterLoading();
                }
              }
            },
          ),
        ],
      ),
    ),
  );
}

Future deleteNote(context, noteData) async {
  // CircularLoading(context).startLoading();
  final _streamController = getIt<StreamController>();
  final streamLocalStorage = StreamLocalStorage();
  final isarService = IsarService();
  DiaryNote note = noteData;

  return await showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Удалить заметку?'),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(13))),
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: Text(
            'Отменить',
            style: TextStyle(color: AppColor.grey2),
          ),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: Text(
            'Удалить',
            style: TextStyle(color: AppColor.red),
          ),
          onPressed: () async {
            CircularLoading(context).startLoading();
            await Future.delayed(const Duration(milliseconds: 200));
            // delete note on server
            var deleteNoteResults = await _streamController.deleteDiaryNote({'id': note.id});
            print('deleteNoteResults: $deleteNoteResults');

            // delete on local
            await streamLocalStorage.deleteDiaryNote(deleteNoteResults);

            if (context.mounted) {
              Navigator.pop(context);
              CircularLoading(context).stopAutoRouterLoading();
            }
          },
        ),
      ],
    ),
  );
}
