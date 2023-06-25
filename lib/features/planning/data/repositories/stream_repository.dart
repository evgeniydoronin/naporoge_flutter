import 'package:dio/dio.dart';
import '../sources/remote/stream_api.dart';

class StreamRepository {
  final StreamApi streamApi;

  StreamRepository(this.streamApi);

  Future createStreamRequested(Map data) async {
    try {
      final response = await streamApi.createStreamApi(data);
      return response.data;
    } on DioError catch (e) {
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
