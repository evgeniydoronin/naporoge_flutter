import '../../../core/services/controllers/service_locator.dart';
import '../data/repositories/stream_repository.dart';

class StreamController {
  // --------------- Repository -------------
  final streamRepository = getIt.get<StreamRepository>();

  // // -------------- TextField Controller ---------------
  // final phoneController = TextEditingController();
  // final smsCodeController = TextEditingController();
  // final authCodeController = TextEditingController();
  //
  // // -------------- Local Variables ---------------
  // // final List<NewUser> newUsers = [];

  // -------------- DATABASE ---------------

  // -------------- Methods ---------------

  Future createStream(data) async {
    final stream = await streamRepository.createStreamRequested(data);
    return stream;
  }

  Future createDayResult(data) async {
    final dayResult = await streamRepository.createDayResultRequested(data);
    return dayResult;
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
