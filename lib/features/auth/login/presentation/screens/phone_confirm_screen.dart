import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:naporoge/core/constants/app_theme.dart';
import 'package:naporoge/core/routes/app_router.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

@RoutePage()
class LoginPhoneConfirmScreen extends StatefulWidget {
  final String phone;

  const LoginPhoneConfirmScreen({Key? key, required this.phone})
      : super(key: key);

  @override
  State<LoginPhoneConfirmScreen> createState() =>
      _LoginPhoneConfirmScreenState();
}

class _LoginPhoneConfirmScreenState extends State<LoginPhoneConfirmScreen> {
  // AuthService authService = AuthService();
  final TextEditingController _otpController = TextEditingController();
  String smsCode = '';
  String verificationIdFinal = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(widget.phone);
    // authService.verifyPhoneNumber(
    //   '+7${widget.phone}',
    //   context,
    //   setData,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text('Вход'),
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
                          controller: _otpController,
                          maxLength: 4,
                          // hasUnderline: true,
                          hideCharacter: false,
                          // pinBoxColor: ColorApp.primary,
                          // highlightPinBoxColor: Colors.redAccent,
                          // highlightColor: Colors.greenAccent,
                          onDone: (text) async {
                            print('_otpController');
                            // await authService.signinWithPhoneNumber(
                            //     verificationIdFinal,
                            //     _otpController.text,
                            //     context);

                            // Navigator.pushAndRemoveUntil(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             ActivateAccountScreen()),
                            //     (route) => false);

                            context.router.replace(
                                const ActivateAccountScreenRoute());
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

  void setData(String verificationId) {
    setState(() {
      verificationIdFinal = verificationId;
      // print(verificationIdFinal);
    });
  }
}
