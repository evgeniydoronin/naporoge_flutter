import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:naporoge/core/constants/app_theme.dart';
import 'package:naporoge/core/routes/app_router.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

@RoutePage()
class ActivateAccountScreen extends StatefulWidget {
  const ActivateAccountScreen({Key? key}) : super(key: key);

  @override
  State<ActivateAccountScreen> createState() => _ActivateAccountScreenState();
}

class _ActivateAccountScreenState extends State<ActivateAccountScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  // final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: const Text(''),
      ),
      body: Container(
        color: Colors.white,
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
              'Код активации выдается учебным заведением',
              style: TextStyle(
                fontSize: 14,
                color: AppColor.grey2,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                PinCodeTextField(
                  autofocus: true,
                  controller: _textEditingController,
                  maxLength: 6,
                  // hasUnderline: true,
                  hideCharacter: false,
                  keyboardType: TextInputType.text,
                  // pinBoxColor: Pallete.primary,
                  // highlightPinBoxColor: Colors.redAccent,
                  // highlightColor: Colors.greenAccent,
                  onDone: (text) async {
                    // var authResultsJSON = await _registrationStudent();
                    // var setUserData = await _updateUser(authUserResults);

                    // var authResults = await jsonDecode(authResultsJSON);
                    // if (authResults['status'] == 'error') {
                    //   showSnackBar(context, authResults['message']);
                    // } else {
                    //   // print('success'); // 2ccefd
                    //   var userUpdateResults = _updateUser(authResultsJSON);
                    //   // print(userUpdateResults);
                    //   // Navigator.pushAndRemoveUntil(
                    //   //     context,
                    //   //     MaterialPageRoute(
                    //   //         builder: (context) => OnboardingPage()),
                    //   //         (r) => false);
                    // }
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
            ElevatedButton(
              onPressed: () {
                // Navigator.pushAndRemoveUntil(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const WelcomeScreen()),
                //     (route) => false);
                context.router.replace(const WelcomeScreenRoute());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.accent,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                    borderRadius: AppLayout.primaryRadius),
              ),
              child: const Text(
                'Войти',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // _registrationStudent() async {
  //   try {
  //     var formData = FormData.fromMap({
  //       'formID': 'registration',
  //       'user_id': uid,
  //       'code': _textEditingController.text
  //     });
  //     var response = await Dio().post(
  //         'https://admin.xn--80aealihac0a3ao2a.xn--p1ai/wp-content/plugins/naporoge/db.php',
  //         data: formData);
  //
  //     return response.data;
  //
  //     // setState(() {
  //     //   codeData = response.toString();
  //     // });
  //   } catch (e) {
  //     debugPrint('_registrationStudent error: $e');
  //   }
  // }

  // _updateUser(authUserResults) async {
  //   Map<String, dynamic> data = jsonDecode(authUserResults);
  //
  //   // CollectionReference users =
  //   // FirebaseFirestore.instance.collection('Students');
  //   // final String uid = FirebaseAuth.instance.currentUser!.uid;
  //
  //   // // return users
  //   // //     .doc(uid)
  //   // //     .update({
  //   // //       'time_zone': data['time_zone'],
  //   // //       'verified_user': true,
  //   // //     })
  //   // //     .then((value) => print("User Updated"))
  //   // //     .catchError((error) => print("Failed to update user: $error"));
  //   // await users.doc(uid).update({
  //   //   'time_zone': data['time_zone'],
  //   //   'verified_user': true,
  //   // });
  // }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
