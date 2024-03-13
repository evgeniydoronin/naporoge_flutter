import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_theme.dart';
import '../../../../core/services/controllers/service_locator.dart';
import '../../../../core/services/db_client/isar_service.dart';
import '../../../../core/utils/circular_loading.dart';
import '../../data/sources/local/stream_local_storage.dart';
import '../../domain/entities/stream_entity.dart';
import '../bloc/description_count/count_description_bloc.dart';
import '../bloc/planner_bloc.dart';
import '../stream_controller.dart';

class StreamDescriptionForm extends StatefulWidget {
  const StreamDescriptionForm({super.key});

  @override
  State<StreamDescriptionForm> createState() => _StreamDescriptionFormState();
}

class _StreamDescriptionFormState extends State<StreamDescriptionForm> {
  final _streamController = getIt<StreamController>();
  final streamLocalStorage = StreamLocalStorage();

  Future getActiveStream() async {
    final storage = StreamLocalStorage();
    return await storage.getActiveStream();
  }

  @override
  Widget build(BuildContext context) {
    String _description = '';

    return FutureBuilder(
        future: getActiveStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            NPStream stream = snapshot.data;
            // описание курса из БД по умолчанию
            TextEditingController descriptionEditingController = TextEditingController(text: stream.description ?? '');
            String description = stream.description ?? 'Укажите объем выполнения и цель дела';

            int maxLength = 200;
            int textLength = descriptionEditingController.text.length;

            context.read<CountDescriptionBloc>().add(ChangeDescriptionLength(textLength));

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppLayout.contentPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocConsumer<CountDescriptionBloc, CountDescriptionState>(
                        listener: (context, state) {
                          // TODO: implement listener
                        },
                        builder: (context, state) {
                          return Text(
                              'Моя задача (${context.watch<CountDescriptionBloc>().state.descriptionLength}/${maxLength.toString()})');
                        },
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: double.maxFinite,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: AppLayout.primaryRadius,
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            await editNoteDescr(stream, context);
                            setState(() {});
                          },
                          child: SingleChildScrollView(
                              child: Text(
                            description,
                            style: TextStyle(fontSize: 16),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Future editNoteDescr(stream, context) async {
    final _streamController = getIt<StreamController>();
    final streamLocalStorage = StreamLocalStorage();
    final _formKey = GlobalKey<FormState>();
    TextEditingController descriptionEditingController = TextEditingController(text: stream.description ?? '');
    int maxLength = 200;

    return await showDialog(
      context: context,
      builder: (BuildContext context) => Form(
        key: _formKey,
        child: AlertDialog(
          title: const Text(
            'Моя задача',
            textAlign: TextAlign.center,
          ),
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColor.blk),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text('Укажите объем выполнения и цель дела'),
              const SizedBox(height: 15),
              CupertinoTheme(
                data: const CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: TextStyle(fontSize: 26),
                  ),
                ),
                child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Заполните обязательное поле!';
                    }
                    return null;
                  },
                  onChanged: (description) {
                    context.read<CountDescriptionBloc>().add(ChangeDescriptionLength(description.length));
                  },
                  decoration: InputDecoration(
                    counterText: "",
                    contentPadding: const EdgeInsets.all(10),
                    hintText: 'Например: Хочу заниматься йогой 40 минут, цель - улучшить растяжку',
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                    labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                    filled: true,
                    fillColor: AppColor.grey1,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(width: 0, color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 0, color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  controller: descriptionEditingController,
                  maxLines: 5,
                  maxLength: maxLength,
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
          contentTextStyle: TextStyle(fontSize: 12, color: AppColor.blk),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(13))),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          actions: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        CircularLoading(context).startLoading();
                        await Future.delayed(const Duration(seconds: 1));

                        Map streamData = {
                          "stream_id": stream.id,
                          "description": descriptionEditingController.text,
                        };

                        print('streamData: $streamData');

                        /// update on server
                        /// update stream description
                        final updatedDescription = await _streamController.updateStream(streamData);

                        /// update local
                        if (updatedDescription['stream']['id'] != null) {
                          streamLocalStorage.updateStream(updatedDescription);

                          if (context.mounted) {
                            Navigator.pop(context);
                            CircularLoading(context).stopAutoRouterLoading();
                            CircularLoading(context).saveSuccess();
                          }
                        }
                      }
                    },
                    style: AppLayout.accentBTNStyle,
                    child: const Text('Сохранить')),
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
              ],
            ),
          ],
          actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
        ),
      ),
    );
  }
}
