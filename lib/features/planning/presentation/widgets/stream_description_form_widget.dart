import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_theme.dart';
import '../../../../core/services/controllers/service_locator.dart';
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
  final _formKey = GlobalKey<FormState>();

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

            int maxLength = 200;
            int textLength = descriptionEditingController.text.length;

            context.read<CountDescriptionBloc>().add(ChangeDescriptionLength(textLength));

            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: AppLayout.primaryRadius,
                          ),
                          child: Row(
                            children: [
                              Flexible(
                                fit: FlexFit.tight,
                                child: TextFormField(
                                  autofocus: false,
                                  controller: descriptionEditingController,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Заполните обязательное поле!';
                                    }
                                    return null;
                                  },
                                  onChanged: (description) {
                                    _description = description;
                                    context
                                        .read<CountDescriptionBloc>()
                                        .add(ChangeDescriptionLength(description.length));
                                  },
                                  // onTapOutside: (val) {
                                  //   context.read<PlannerBloc>().add(StreamCourseDescriptionChanged(_description));
                                  // },
                                  maxLines: 2,
                                  maxLength: maxLength,
                                  decoration: InputDecoration(
                                    counterText: "",
                                    contentPadding: const EdgeInsets.all(10),
                                    hintText: 'Укажите объем выполнения и цель дела',
                                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                                    labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                                    filled: false,
                                    errorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.green, width: 0),
                                        borderRadius: AppLayout.primaryRadius,
                                        gapPadding: 1),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.transparent),
                                        borderRadius: AppLayout.primaryRadius),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.transparent),
                                        borderRadius: AppLayout.primaryRadius),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.transparent),
                                        borderRadius: AppLayout.primaryRadius),
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      CircularLoading(context).startLoading();

                                      await Future.delayed(const Duration(seconds: 1));

                                      Map streamData = {
                                        "stream_id": stream.id,
                                        "description": descriptionEditingController.text,
                                      };

                                      // print('streamData: $streamData');

                                      /// update on server
                                      /// update stream description
                                      final updatedDescription = await _streamController.updateStream(streamData);

                                      /// update local
                                      if (updatedDescription['stream']['id'] != null) {
                                        streamLocalStorage.updateStream(updatedDescription);

                                        if (context.mounted) {
                                          CircularLoading(context).stopLoading();
                                          CircularLoading(context).saveSuccess();
                                        }
                                      }
                                    }
                                  },
                                  icon: Icon(
                                    Icons.save,
                                    color: AppColor.accent,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
