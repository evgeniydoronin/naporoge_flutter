import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_theme.dart';
import '../../../../../core/routes/app_router.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import '../../../../../core/services/controllers/service_locator.dart';
import '../../../../../core/utils/circular_loading.dart';
import '../auth_controller.dart';

@RoutePage()
class LoginPhoneConfirmScreen extends StatefulWidget {
  final String phone;
  final int code;

  const LoginPhoneConfirmScreen({Key? key, required this.phone, required this.code}) : super(key: key);

  @override
  State<LoginPhoneConfirmScreen> createState() => _LoginPhoneConfirmScreenState();
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
                      // Text(widget.code.toString()),
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

                            /// верификация по смс успешна
                            if (int.parse(_authController.smsCodeController.text) == widget.code) {
                              // confirmAuthCode

                              /// Проверка
                              /// Создавался ли пользователь с текущим номером телефона

                              Map user = await _authController.getStudent(widget.phone);

                              /// Пользователь создавался
                              if (user['student'].isNotEmpty) {
                                if (context.mounted) {
                                  CircularLoading(context).startLoading();
                                }
                                // print('user id: ${user['student'][0]}');
                                int userId = user['student'][0]['user_id'];
                                print('userId: $userId');

                                /// 1. Очищаем локальную БД
                                await _authController.clearLocalDB();

                                /// 2. Получаем данные с сервера List
                                final remoteDB = await _authController.getDBFromServer(userId);

                                // print('remoteDB: $remoteDB');

                                /// 3. Наполняем локальную БД
                                await _authController.createLocalDB(remoteDB);

                                /// 4. перенаправляем Splash screen
                                if (context.mounted) {
                                  CircularLoading(context).stopAutoRouterLoading();
                                  context.router.replace(const SplashScreenRoute());
                                }
                              }

                              /// Пользователь не создавался
                              else {
                                /// ВАЖНО: сейчас делаю только для студентов вуза
                                /// 1. Весрия ВУЗА
                                /// перенаправляем на страницу активации вузовского кода
                                if (context.mounted) {
                                  context.router.replace(ActivateAccountScreenRoute(phone: widget.phone));
                                }

                                ///
                                /// 2. Версия Коммерческая
                                /// перенаправляем на создание первого дела
                              }
                            }

                            /// неверный код смс
                            else {
                              print('code error');
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Неверный код'), duration: Duration(seconds: 2)));
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
                        'Если код долго не приходит - проверьте правильно ли указан номер телефона',
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
