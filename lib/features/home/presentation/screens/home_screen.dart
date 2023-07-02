import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/get_status_stream.dart';
import '../../../planning/domain/entities/stream_entity.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/routes/app_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../planning/data/sources/local/stream_local_storage.dart';
import '../bloc/home_screen/home_screen_bloc.dart';
import '../widgets/total_button.dart';
import '../widgets/video_box.dart';
import '../widgets/week_progress.dart';
import '../widgets/week_status_point.dart';

@RoutePage(name: 'HomesEmptyRouter')
class HomesEmptyRouterPage extends AutoRouter {}

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Future _getStream;
  late bool activeBtnDayResultSave;

  @override
  void initState() {
    _getStream = getActiveStream();
    activeBtnDayResultSave = false;
    super.initState();
  }

  Future getActiveStream() async {
    final storage = StreamLocalStorage();
    return await storage.getActiveStream();
  }

  @override
  Widget build(BuildContext context) {
    String _btnText = '';
    String topMessage = '';

    return Scaffold(
      backgroundColor: AppColor.lightBG,
      body: FutureBuilder(
        future: _getStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            NPStream stream = snapshot.data;
            Map streamStatus = getStreamStatus(stream);

            return ListView(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(DateFormat('dd-MM-y', 'ru_RU')
                              .format(DateTime.now()))),
                      BlocBuilder<HomeScreenBloc, HomeScreenState>(
                        builder: (context, state) {
                          return Text(
                              state.message ?? streamStatus['topMessage']);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 25, left: 18, right: 45),
                    decoration: BoxDecoration(
                        color: AppColor.lightBGItem,
                        border: AppLayout.primaryBorder,
                        borderRadius: AppLayout.primaryRadius,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            spreadRadius: 0,
                          )
                        ],
                        image: const DecorationImage(
                            alignment: Alignment.bottomRight,
                            image: AssetImage('assets/images/4.png'))),
                    child: RichText(
                      text: const TextSpan(
                        text: 'Пропущенное дело',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w800),
                        children: [
                          TextSpan(
                            text: ' можно выполнить в выходной день.',
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                WeekStatusPoint(stream: stream),
                const SizedBox(height: 10),
                // WeekProgress(stream: stream),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 4,
                        fit: FlexFit.tight,
                        child: ElevatedButton(
                          onPressed: () {
                            context.router.push(const TodoEmptyRouter());
                          },
                          style: AppLayout.primaryBTNStyle,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                  'assets/icons/todo_home_screen.svg'),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Перечень дел',
                                  style: AppFont.regularSemibold,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        flex: 3,
                        child: ElevatedButton(
                          onPressed: () {
                            // context.router.push(SplashScreenRoute());
                          },
                          style: AppLayout.primaryBTNStyle,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                  'assets/icons/rules_home_screen.svg'),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Правила',
                                  style: AppFont.regularSemibold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                const VideoBox(),
                const SizedBox(height: 25),
                TotalButton(stream: stream),
                const SizedBox(height: 25),
              ],
            );
          }
          // while waiting for data to arrive, show a spinning indicator
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
