import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naporoge/features/planning/presentation/widgets/day_schedule_widget.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/utils/get_status_stream.dart';
import '../../data/sources/local/stream_local_storage.dart';
import '../../domain/entities/stream_entity.dart';
import '../widgets/day_schedule_stream_widget.dart';

@RoutePage()
class PlanningScreen extends StatefulWidget {
  const PlanningScreen({Key? key}) : super(key: key);

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  late final Future _getStream;
  late bool activeBtnPlanConfirm;

  @override
  void initState() {
    _getStream = getActiveStream();
    activeBtnPlanConfirm = false;
    super.initState();
  }

  Future getActiveStream() async {
    final storage = StreamLocalStorage();
    return await storage.getActiveStream();
  }

  @override
  Widget build(BuildContext context) {
    String courseTitle = '';
    return Scaffold(
      backgroundColor: AppColor.lightBG,
      appBar: AppBar(
        backgroundColor: AppColor.lightBG,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Планирование',
          style: AppFont.scaffoldTitleDark,
        ),
      ),
      body: FutureBuilder(
        future: _getStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            NPStream stream = snapshot.data;
            Map streamStatus = getStreamStatus(stream);
            TextEditingController descriptionEditingController =
                TextEditingController(text: stream.description);

            return ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 18, right: 18),
                    decoration: AppLayout.boxDecorationShadowBG,
                    child: Text(
                      stream.title!,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: AppFont.large,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Моя задача:'),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: descriptionEditingController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Заполните обязательное поле!';
                          }
                          return null;
                        },
                        maxLines: 2,
                        maxLength: 200,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          hintText: 'Укажите объем выполнения и цель дела',
                          hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                          labelStyle:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                          fillColor: Colors.white,
                          filled: true,
                          errorBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.redAccent),
                              borderRadius: AppLayout.primaryRadius),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                              borderRadius: AppLayout.primaryRadius),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                              borderRadius: AppLayout.primaryRadius),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                      padding: const EdgeInsets.only(bottom: 5),
                      decoration: AppLayout.boxDecorationShadowBG,
                      child: DayScheduleStreamWidget(stream: stream)),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: AppLayout.accentBTNStyle,
                          child: Text(
                            'План мне подходит',
                            style: AppFont.largeSemibold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
