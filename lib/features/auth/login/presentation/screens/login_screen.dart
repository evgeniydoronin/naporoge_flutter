import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../../../core/routes/app_router.dart';
import '../../../../../core/constants/app_theme.dart';

@RoutePage(name: 'LoginEmptyRouter')
class LoginEmptyRouterPage extends AutoRouter {}

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final maskFormatter = MaskTextInputFormatter(mask: '+7 (###) ###-##-##');
  bool isActiveBtn = false;
  bool isChecked = false;

  TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Timer? _timer;
  int _start = 60;
  bool _isTimerStart = false;

  List<int> errorScreen = [];

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
            _isTimerStart = false;
          } else {
            _isTimerStart = true;
            _start = _start - 1;
            // print(_start);
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Вход',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Введите номер телефона, Вам придет смс с кодом для активации',
                    style: TextStyle(
                      height: 1.5,
                      fontSize: AppFont.small,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: phoneController,
                          style: TextStyle(
                              color: Colors.black, fontSize: AppFont.small),
                          decoration: InputDecoration(
                            floatingLabelStyle: TextStyle(
                              fontSize: 18.0,
                              color: AppColor.accent,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFEEEEEF),
                            contentPadding: const EdgeInsets.only(
                                right: 25.0,
                                left: 25.0,
                                top: 20.0,
                                bottom: 20.0),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColor.red,
                                width: 1,
                              ),
                              borderRadius: AppLayout.primaryRadius,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColor.accent,
                                width: 2,
                              ),
                              borderRadius: AppLayout.primaryRadius,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: AppLayout.primaryRadius,
                              borderSide: const BorderSide(
                                  color: Color(0xFFEEEEEF), width: 0),
                            ),
                            labelText: 'Телефон',
                            labelStyle: const TextStyle(fontSize: 14.0),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [maskFormatter],
                          onChanged: (val) {
                            // print(val.length);
                            print(phoneController.text.length);
                            // print(phoneController.text);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              print('vav: $value');
                              return 'Введите номер телефона!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: Checkbox(
                                value: isChecked,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                side: const BorderSide(width: 1),
                                onChanged: (newBool) {
                                  setState(() {
                                    isChecked = newBool!;
                                    isActiveBtn = !isActiveBtn;
                                  });
                                  print(isActiveBtn);
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      color: AppColor.grey2, height: 1.5),
                                  children: [
                                    const TextSpan(
                                      text: 'Я принимаю условия ',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: 'политики конфидециальности',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => context.router.push(
                                            const PrivacyPolicyScreenRoute()),
                                      style: TextStyle(color: AppColor.accent),
                                    ),
                                    const TextSpan(
                                      text: ' и даю согласие на ',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: 'обработку персональных данных',
                                      style: TextStyle(color: AppColor.accent),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => context.router.push(
                                            const PersonalDataScreenRoute()),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Приложение разработано для обучающихся по Программе «Развитие воли и самоорганизации» Код активации выдается учебным заведением',
                          style: TextStyle(
                              color: AppColor.grey2, fontSize: AppFont.small),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 60),
                            shape: RoundedRectangleBorder(
                                borderRadius: AppLayout.primaryRadius),
                          ),
                          onPressed: errorScreen.isEmpty
                              ? _isTimerStart
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        // print('object');
                                        startTimer();
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) =>
                                        //         LoginPhoneConfirmScreen(
                                        //       phone: maskFormatter
                                        //           .getUnmaskedText(),
                                        //     ),
                                        //   ),
                                        // );
                                        context.router.push(
                                            LoginPhoneConfirmScreenRoute(
                                                phone: maskFormatter
                                                    .getUnmaskedText()));
                                      }
                                    }
                              : null,
                          child: _isTimerStart
                              ? Text(
                                  'Отправить через $_start секунд',
                                  style: const TextStyle(fontSize: 18),
                                )
                              : const Text(
                                  'Отправить код',
                                  style: TextStyle(fontSize: 18),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
