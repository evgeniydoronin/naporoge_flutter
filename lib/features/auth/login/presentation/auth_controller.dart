import 'package:flutter/cupertino.dart';
import '../data/repository/user_repository.dart';
import '../../../../core/services/controllers/service_locator.dart';

class AuthController {
  // --------------- Repository -------------
  final userRepository = getIt.get<UserRepository>();

  // -------------- TextField Controller ---------------
  final phoneController = TextEditingController();
  final smsCodeController = TextEditingController();
  final authCodeController = TextEditingController();

  // -------------- Local Variables ---------------
  // final List<NewUser> newUsers = [];

  // -------------- DATABASE ---------------

  // -------------- Methods ---------------

  Future getSmsCode(phone) async {
    final newlySmsCode = await userRepository.getSmsConfirmCodeRequested(phone);
    // newUsers.add(newlySmsCode);
    return newlySmsCode;
  }

  Future confirmAuthCode(authCode) async {
    final confirmAuthCode =
        await userRepository.confirmAuthCodeRequested(authCode);
    return confirmAuthCode;
  }

  Future createStudent(phone, authCode) async {
    final confirmAuthCode =
        await userRepository.createStudentRequested(phone, authCode);
    return confirmAuthCode;
  }

// Future<List<UserModel>> getUsers() async {
//   final users = await userRepository.getUsersRequested();
//   return users;
// }
//
// Future<NewUser> updateUser(int id, String name, String job) async {
//   final updatedUser = await userRepository.updateUserRequested(
//     id,
//     name,
//     job,
//   );
//   newUsers[id] = updatedUser;
//   return updatedUser;
// }
//
// Future<void> deleteNewUser(int id) async {
//   await userRepository.deleteNewUserRequested(id);
//   newUsers.removeAt(id);
// }
}
