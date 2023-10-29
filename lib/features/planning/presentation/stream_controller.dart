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

  Future createNextStream(data) async {
    final stream = await streamRepository.createNextStreamRequested(data);
    return stream;
  }

  Future updateStream(data) async {
    final stream = await streamRepository.updateStreamRequested(data);
    return stream;
  }

  Future createWeek(data) async {
    final week = await streamRepository.createWeekRequested(data);
    return week;
  }

  Future updateWeek(data) async {
    final week = await streamRepository.updateWeekRequested(data);
    return week;
  }

  Future updateWeekProgress(data) async {
    final week = await streamRepository.updateWeekProgressRequested(data);
    return week;
  }

  Future createDayResult(data) async {
    final dayResult = await streamRepository.createDayResultRequested(data);
    return dayResult;
  }

  Future createDiaryNote(data) async {
    final note = await streamRepository.createDiaryNoteRequested(data);
    return note;
  }

  Future updateDiaryNote(data) async {
    final note = await streamRepository.updateDiaryNoteRequested(data);
    return note;
  }

  Future deleteDiaryNote(data) async {
    final note = await streamRepository.deleteDiaryNoteRequested(data);
    return note;
  }

  Future deleteDuplicatesResult(data) async {
    final result = await streamRepository.deleteDuplicatesRequested(data);
    return result;
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
