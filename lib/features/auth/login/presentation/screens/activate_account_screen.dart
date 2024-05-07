import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_theme.dart';
import '../../../../../core/routes/app_router.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import '../../../../../core/services/db_client/isar_service.dart';
import '../../../../../core/services/controllers/service_locator.dart';
import '../../../../../core/services/push_notifications/push_notifications.dart';
import '../auth_controller.dart';

@RoutePage()
class ActivateAccountScreen extends StatefulWidget {
  final String phone;

  const ActivateAccountScreen({Key? key, required this.phone}) : super(key: key);

  @override
  State<ActivateAccountScreen> createState() => _ActivateAccountScreenState();
}

class _ActivateAccountScreenState extends State<ActivateAccountScreen> {
  final _authController = getIt<AuthController>();
  final isarService = IsarService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightBG,
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: AppColor.lightBG,
        title: const Text(''),
      ),
      body: Container(
        color: AppColor.lightBGItem,
        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
            const SizedBox(
              height: 40,
            ),
            const Text(
              'Введите код активации',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Код активации выдается учебным заведением или на сайте организатора развитиеволи.рф',
              style: TextStyle(
                fontSize: 14,
                color: AppColor.grey2,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                PinCodeTextField(
                  autofocus: true,
                  controller: _authController.authCodeController,
                  maxLength: 6,
                  // hasUnderline: true,
                  hideCharacter: false,
                  keyboardType: TextInputType.text,
                  // pinBoxColor: Pallete.primary,
                  // highlightPinBoxColor: Colors.redAccent,
                  // highlightColor: Colors.greenAccent,
                  onDone: (text) async {
                    /// Проверка пользователя был ли он создан
                    /// Если создан и вышел/удалил приложение
                    /// то выводим попап окно с загрузкой данных предыдущих курсов

                    var isAuthCode = await _authController.confirmAuthCode(_authController.authCodeController.text);

                    /// Авторизация студентов вуза
                    /// студенты вуза
                    /// проверяем код от вуза
                    if (isAuthCode['authCode'].isNotEmpty) {
                      print('create user');
                      // create user
                      var user =
                          await _authController.createStudent(widget.phone, _authController.authCodeController.text);

                      isarService.saveUser(user['student']['id']);

                      if (context.mounted) {
                        AutoRouter.of(context).replace(const WelcomeScreenRoute());
                      }
                    } else {
                      // print warning message
                      print('NULL isAuthCode');
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Неверный код активации'), duration: Duration(seconds: 2)));
                      }
                    }
                  },
                  defaultBorderColor: AppColor.grey2,
                  hasTextBorderColor: AppColor.accent,
                  pinBoxRadius: 5.0,
                  pinBoxHeight: 40,
                  pinBoxWidth: 40,
                  isCupertino: true,
                  pinTextStyle: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
