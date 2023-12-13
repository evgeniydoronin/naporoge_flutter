import 'package:dio/dio.dart';
import 'package:naporoge/features/diary/domain/entities/diary_note_entity.dart';
import '../sources/remote/stream_api.dart';

class StreamRepository {
  final StreamApi streamApi;

  StreamRepository(this.streamApi);

  Future createStreamRequested(Map data) async {
    try {
      final response = await streamApi.createStreamApi(data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future deleteStreamRequested(Map data) async {
    try {
      final response = await streamApi.deleteStreamApi(data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future deactivateStreamRequested(Map data) async {
    try {
      final response = await streamApi.deactivateStreamApi(data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future createNextStreamRequested(Map data) async {
    try {
      final response = await streamApi.createNextStreamApi(data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future updateStreamRequested(Map data) async {
    try {
      final response = await streamApi.updateStreamApi(data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future expandStreamRequested(Map data) async {
    try {
      final response = await streamApi.expandStreamApi(data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future createWeekRequested(Map data) async {
    try {
      final response = await streamApi.createWeekApi(data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future updateWeekRequested(Map data) async {
    try {
      final response = await streamApi.updateWeekApi(data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future updateWeekProgressRequested(Map data) async {
    try {
      final response = await streamApi.updateWeekProgressApi(data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future createDayResultRequested(Map data) async {
    try {
      final response = await streamApi.createDayResultApi(data);
      return response.data;
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future createTwoTargetsRequested(Map data) async {
    try {
      final response = await streamApi.createTwoTargetsApi(data);
      return response.data;
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future updateTwoTargetsRequested(Map data) async {
    try {
      final response = await streamApi.updateTwoTargetsApi(data);
      return response.data;
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future createDiaryNoteRequested(Map data) async {
    try {
      final response = await streamApi.createDiaryNoteApi(data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future updateDiaryNoteRequested(Map data) async {
    try {
      final response = await streamApi.updateDiaryNoteApi(data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future deleteDiaryNoteRequested(Map data) async {
    try {
      final response = await streamApi.deleteDiaryNoteApi(data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future deleteDuplicatesRequested(Map data) async {
    try {
      final response = await streamApi.deleteDuplicatesResultApi(data);
      return response.data;
    } on DioException catch (e) {
      rethrow;
    }
  }

// Future<List<UserModel>> getUsersRequested() async {
//   try {
//     final response = await streamApi.getUsersApi();
//     final users = (response.data['data'] as List)
//         .map((e) => UserModel.fromJson(e))
//         .toList();
//     return users;
//   } on DioError catch (e) {
//     rethrow;
//   }
// }
//
// Future<NewUser> updateUserRequested(int id, String name, String job) async {
//   try {
//     final response = await streamApi.updateUserApi(id, name, job);
//     return NewUser.fromJson(response.data);
//   } on DioError catch (e) {
//     rethrow;
//   }
// }
//
// Future<void> deleteNewUserRequested(int id) async {
//   try {
//     await streamApi.deleteUserApi(id);
//   } on DioError catch (e) {
//     rethrow;
//   }
// }
}
