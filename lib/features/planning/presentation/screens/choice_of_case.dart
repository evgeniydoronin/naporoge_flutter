import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/routes/app_router.dart';

import '../../../../core/data/models/case_model.dart';
import '../widgets/stepper_wigget.dart';

@RoutePage()
class ChoiceOfCaseScreen extends StatefulWidget {
  const ChoiceOfCaseScreen({super.key});

  @override
  State<ChoiceOfCaseScreen> createState() => _ChoiceOfCaseScreenState();
}

class _ChoiceOfCaseScreenState extends State<ChoiceOfCaseScreen> {
  int? selected;
  final List<NPCase> _cases = NPCase.generateDeal();
  late bool _isActivated;
  late bool _customTileExpanded;

  final _formKey = GlobalKey<FormState>();

  late final Map<String, TextEditingController> _shortTitleController = {};
  late final Map<String, TextEditingController> _startTimeFirstDayController =
      {};

  // late TextEditingController _shortTitleController;

  DateTime initialDate = DateTime.now();
  DateTime _timeStartFirstDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    DateTime initial = DateTime.now();
    initialDate =
        DateTime(initial.year, initial.month, initial.day, initial.hour, 0);
    _timeStartFirstDay =
        DateTime(initial.year, initial.month, initial.day, 10, 0);

    _customTileExpanded = false;
    _isActivated = false;

    // !!! text editing controller listview.builder
    _cases.asMap().forEach((key, value) {
      setState(() {
        _shortTitleController[value.caseId] = TextEditingController();
        _startTimeFirstDayController[value.caseId] = TextEditingController();
      });
    });
  }

  @override
  void dispose() {
    _cases.asMap().forEach((key, value) {
      _shortTitleController[value.caseId]?.dispose();
      _startTimeFirstDayController[value.caseId]?.dispose();
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // String _caseIdWatch =
    //     context.watch<FirstPlanning>().getCourseId.toString() == 'null'
    //         ? context.watch<FirstPlanning>().getCourseId.toString()
    //         : '';

    List formatters = [
      FilteringTextInputFormatter.digitsOnly,
      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
      FilteringTextInputFormatter.deny(RegExp(r'[/\\]'))
    ];

///////// TODO: REMOVE START
    // FirstPlanning firstPlanning = Provider.of<FirstPlanning>(context);
    // TextEditingController _nameController = TextEditingController(
    //   text: firstPlanning.name,
    // );
///////// TODO: REMOVE END
    // Map<int, String> selectedCourse = {
    //   0: 'case_runing_id',
    //   1: 'case_workout_id',
    //   2: 'case_day_results_id',
    //   3: 'case_other_id',
    // };
    for (int i = 0; i < _cases.length; i++) {
      setState(() {
        // if (_cases[i].caseId ==
        //     context.watch<FirstPlanning>().getCourseId.toString()) {
        //   selected = i;
        //   // print(selected);
        //   // _isActivated = true;
        // }
      });
    }
    return Scaffold(
      backgroundColor: AppColor.lightBG,
      appBar: AppBar(
          // automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: AppColor.lightBG,
          title: const Text('Выбрать дело')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const StepperIcons(step: 1),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  key: Key(selected.toString()),
                  //attention

                  padding: const EdgeInsets.only(bottom: 25.0),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _cases.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: AppLayout.boxDecorationShadowBG,
                      margin: const EdgeInsets.only(bottom: 15),
                      child: Column(children: <Widget>[
                        Theme(
                          data: ThemeData()
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                              key: Key(index.toString()),
                              //attention
                              initiallyExpanded: index == selected,
                              //attention

                              title: Text(
                                _cases[index].title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              tilePadding: const EdgeInsets.all(5),
                              childrenPadding: const EdgeInsets.all(20),
                              leading: Container(
                                width: 50,
                                padding: const EdgeInsets.only(left: 15),
                                child: SvgPicture.asset(
                                  _cases[index].iconUrl,
                                ),
                              ),
                              trailing: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: SvgPicture.asset(
                                  'assets/icons/arrow_deal_down.svg',
                                ),
                              ),
                              children: <Widget>[
                                Column(
                                  children: [
                                    Text(
                                      _cases[index].description,
                                      style: TextStyle(height: 1.5),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    // Consumer<FirstPlanning>(
                                    //   builder: (context, appState, child) {
                                    //     // print('appState');
                                    //     // print(appState);
                                    //     // print(appState.getFormData);
                                    //     // получаю данные формы
                                    //     Map<String, dynamic> _formData =
                                    //         appState.getFormData;
                                    //     // если они есть - вешаю на контроллер
                                    //     // поля по id
                                    //     if (_formData[_cases[index].caseId]
                                    //                 ?['shortTitle'] !=
                                    //             null &&
                                    //         _formData[_cases[index].caseId]
                                    //                 ?['shortTitle'] !=
                                    //             '' &&
                                    //         _formData[_cases[index].caseId]
                                    //                 ?['shortTitle'] !=
                                    //             'null') {
                                    //       _shortTitleController[
                                    //                   _cases[index].caseId]!
                                    //               .text =
                                    //           _formData[_cases[index].caseId]![
                                    //               'shortTitle'];
                                    //     }
                                    //
                                    //     return TextFormField(
                                    //       // controller: _shortTitleController[
                                    //       //     _cases[index].caseId],
                                    //       controller: _shortTitleController[
                                    //           _cases[index].caseId],
                                    //       maxLength: 20,
                                    //       onChanged: (value) {
                                    //         // print(_shortTitleController[
                                    //         //     _cases[index].caseId]);
                                    //         // print(value);
                                    //         context
                                    //             .read<FirstPlanning>()
                                    //             .changeCourseShortTitle(
                                    //                 _shortTitleController[
                                    //                         _cases[index].caseId]!
                                    //                     .text);
                                    //       },
                                    //       validator: (value) {
                                    //         if (value == null ||
                                    //             value.trim().isEmpty) {
                                    //           return 'Заполните обязательное поле!';
                                    //         }
                                    //         return null;
                                    //       },
                                    //       decoration: InputDecoration(
                                    //         hintText: 'Краткое название дела',
                                    //         hintStyle: TextStyle(
                                    //             color: Colors.grey, fontSize: 12),
                                    //         labelStyle: TextStyle(
                                    //             color: Colors.grey, fontSize: 12),
                                    //         fillColor: Colors.white,
                                    //         filled: true,
                                    //         errorBorder: OutlineInputBorder(
                                    //             borderSide: const BorderSide(
                                    //                 color: Colors.redAccent),
                                    //             borderRadius: primaryRadius),
                                    //         enabledBorder: OutlineInputBorder(
                                    //             borderSide: const BorderSide(
                                    //                 color: Colors.transparent),
                                    //             borderRadius: primaryRadius),
                                    //         focusedBorder: OutlineInputBorder(
                                    //             borderSide: const BorderSide(
                                    //                 color: Colors.transparent),
                                    //             borderRadius: primaryRadius),
                                    //       ),
                                    //     );
                                    //   },
                                    // ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        hintText: 'Краткое название дела',
                                        hintStyle: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                        labelStyle: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                        fillColor: AppColor.grey1,
                                        filled: true,
                                        errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.redAccent),
                                            borderRadius:
                                                AppLayout.smallRadius),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.transparent),
                                            borderRadius:
                                                AppLayout.smallRadius),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.transparent),
                                            borderRadius:
                                                AppLayout.smallRadius),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              onExpansionChanged: ((newState) {
                                if (newState) {
                                  setState(() {
                                    // деактивируем все курсы
                                    for (int i = 0; i < _cases.length; i++) {
                                      _cases[i].isExpanded = false;
                                    }
                                    // активируем выбранный
                                    selected = index;
                                    _cases[index].isExpanded = newState;
                                    _isActivated = true;

                                    // context
                                    //     .read<FirstPlanning>()
                                    //     .changeCourseId(_cases[index].caseId);
                                  });
                                } else {
                                  setState(() {
                                    selected = -1;
                                    _isActivated = false;
                                  });
                                }

                                // _cases[index].isExpanded = newState;
                                // setState(() {
                                //   _customTileExpanded = newState;
                                // });
                              })),
                        ),
                      ]),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 20),
            //   width: MediaQuery.of(context).size.width,
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     mainAxisSize: MainAxisSize.max,
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       // context.read<FirstPlanning>().caseDateStart
            //       Text('Дата старта: ' +
            //           DateFormat('EEEE d MMMM', 'ru_RU')
            //               .format(DateTime.parse(context
            //                   .read<FirstPlanning>()
            //                   .caseDateStart
            //                   .toString()))
            //               .toString()),
            //       Text(context
            //                   .read<FirstPlanning>()
            //                   .getCourseShortTitle
            //                   .toString() !=
            //               'null'
            //           ? 'Краткое название: ' +
            //               context
            //                   .watch<FirstPlanning>()
            //                   .getCourseShortTitle
            //                   .toString()
            //           : 'Краткое название:'),
            //       Text(context
            //                   .watch<FirstPlanning>()
            //                   .getCourseTimeFirstDayStart
            //                   .toString() !=
            //               'null'
            //           ? 'Время начала: ' +
            //               DateFormat('Hm', 'ru_RU').format(DateTime.parse(context
            //                   .watch<FirstPlanning>()
            //                   .getCourseTimeFirstDayStart
            //                   .toString()))
            //           : 'Время начала:'),
            //       Text('caseId: ' +
            //           context.watch<FirstPlanning>().getCourseId.toString()),
            //     ],
            //   ),
            // ),
            // SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    // primary: Pallete.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: AppLayout.primaryRadius)),
                onPressed: _isActivated
                    ? () {
                        context.router.push(const SelectDayPeriodRoute());
                        // if (_formKey.currentState!.validate()) {
                        //   print('validate');
                        // }
                        // for (int i = 0; i < _cases.length; i++) {
                        //   print(_cases[i].caseId);
                        //   print(
                        //       _shortTitleController[_cases[i].caseId]?.text);
                        // }

                        // Validate returns true if the form is valid, or false otherwise.
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          ///////////////////
                          ///
                          // переход на следующий экран
                          // if (widget.pageController.hasClients) {
                          //   widget.pageController.animateToPage(
                          //     2,
                          //     duration: const Duration(milliseconds: 10),
                          //     curve: Curves.easeInOut,
                          //   );
                          // }
                        }
                      }
                    : null,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Выбрать',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
