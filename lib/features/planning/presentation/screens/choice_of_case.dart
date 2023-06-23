import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naporoge/features/planning/presentation/bloc/planner_bloc.dart';
import '../../../../core/constants/app_theme.dart';
import '../../../../core/routes/app_router.dart';

import '../../../../core/data/models/case_model.dart';

// import '../bloc/planner_builder_bloc.dart';
import '../widgets/stepper_widget.dart';

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

  final _formKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> _shortTitleController = {};

  String caseId = '';
  String caseTitle = '';

  @override
  void initState() {
    super.initState();
    _isActivated = false;

    for (var cases in _cases) {
      _shortTitleController[cases.title] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var cases in _cases) {
      _shortTitleController[cases.title]?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List formatters = [
      FilteringTextInputFormatter.digitsOnly,
      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
      FilteringTextInputFormatter.deny(RegExp(r'[/\\]'))
    ];

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
                      child: Column(
                        children: <Widget>[
                          Theme(
                            data: ThemeData()
                                .copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              key: Key(index.toString()),
                              initiallyExpanded: index == selected,
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
                                    _isActivated = false;
                                  });
                                } else {
                                  setState(() {
                                    selected = -1;
                                    _isActivated = false;
                                  });
                                }
                              }),
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      _cases[index].description,
                                      style: const TextStyle(height: 1.5),
                                    ),
                                    const SizedBox(height: 30),
                                    TextFormField(
                                      controller: _shortTitleController[
                                          _cases[index].caseId],
                                      onChanged: (title) {
                                        context.read<PlannerBloc>().add(
                                            StreamCourseTitleChanged(title));
                                        print(title);
                                        // context
                                        //     .read<PlannerBuilderBloc>()
                                        //     .add(PlannerDataEvent(
                                        //     courseId:
                                        //     _cases[index].caseId,
                                        //     courseTitle: title));

                                        if (title.isNotEmpty) {
                                          setState(() {
                                            _isActivated = true;
                                          });
                                        } else {
                                          setState(() {
                                            _isActivated = false;
                                          });
                                        }
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Краткое название дела',
                                        hintStyle: const TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                        labelStyle: const TextStyle(
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
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
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
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
