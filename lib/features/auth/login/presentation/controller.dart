import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/services/isar_service.dart';
import '../data/models/new_user_model.dart';
import '../data/models/user_model.dart';
import '../data/repository/user_repository.dart';
import '../services/service_locator.dart';
import '../domain/user_model.dart';

class AuthController {
  // --------------- Repository -------------
  final userRepository = getIt.get<UserRepository>();

  // -------------- TextField Controller ---------------
  final phoneController = TextEditingController();
  final smsCodeController = TextEditingController();
  final authCodeController = TextEditingController();

  // -------------- Local Variables ---------------
  final List<NewUser> newUsers = [];

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
