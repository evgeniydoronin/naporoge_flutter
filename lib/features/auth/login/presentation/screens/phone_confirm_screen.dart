import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_theme.dart';
import '../../../../../core/routes/app_router.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

import '../../di/service_locator.dart';
import '../controller.dart';

@RoutePage()
class LoginPhoneConfirmScreen extends StatefulWidget {
  final String phone;
  final int code;

  const LoginPhoneConfirmScreen(
      {Key? key, required this.phone, required this.code})
      : super(key: key);

  @override
  State<LoginPhoneConfirmScreen> createState() =>
      _LoginPhoneConfirmScreenState();
}

class _LoginPhoneConfirmScreenState extends State<LoginPhoneConfirmScreen> {
  final _authController = getIt<AuthController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: const Text('Вход'),
      ),
      body: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Подтверждение номера',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Мы отправили вам 4-значный код на номер',
                        style: TextStyle(color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(widget.code.toString()),
                      Text(
                        '+7${widget.phone}',
                        style: TextStyle(
                          color: AppColor.accent,
                          fontSize: AppFont.small,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: PinCodeTextField(
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          controller: _authController.smsCodeController,
                          maxLength: 4,
                          // hasUnderline: true,
                          hideCharacter: false,
                          // pinBoxColor: ColorApp.primary,
                          // highlightPinBoxColor: Colors.redAccent,
                          // highlightColor: Colors.greenAccent,
                          onDone: (text) async {
                            print('_smsCode.smsCodeController');
                            print(_authController.smsCodeController.text);

                            if (int.parse(
                                    _authController.smsCodeController.text) ==
                                widget.code) {
                              // confirmAuthCode
                              print('code success');
                              context.router.replace(ActivateAccountScreenRoute(
                                  phone: widget.phone));
                            } else {
                              print('code error');
                            }
                          },
                          defaultBorderColor: AppColor.grey2,
                          hasTextBorderColor: AppColor.accent,
                          pinBoxRadius: 5.0,
                          pinBoxHeight: 40,
                          pinBoxWidth: 40,
                          isCupertino: true,
                          pinTextStyle: const TextStyle(fontSize: 18),
                        ),
                      ),
                      Text(
                        'Если долго не приходит код - проверьте правильно ли указан номер телефона',
                        style: TextStyle(fontSize: 12, color: AppColor.grey2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

// void setData(String verificationId) {
//   setState(() {
//     verificationIdFinal = verificationId;
//     // print(verificationIdFinal);
//   });
// }
}
