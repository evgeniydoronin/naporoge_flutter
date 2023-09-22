import 'package:dio/dio.dart';
import '../network/api/user_api.dart';

class UserRepository {
  final UserApi userApi;

  UserRepository(this.userApi);

  Future getSmsConfirmCodeRequested(String phone) async {
    try {
      final response = await userApi.getSmsConfirmCodeApi(phone);
      return response.data;
    } on DioException catch (dioError) {
      print(dioError.error);
      rethrow;
    }
  }

  Future confirmAuthCodeRequested(String authCode) async {
    try {
      final response = await userApi.confirmAuthCodeApi(authCode);
      return response.data;
    } on DioException catch (dioError) {
      print(dioError.error);
      rethrow;
    }
  }

  Future createStudentRequested(String phone, String authCode) async {
    try {
      final response = await userApi.createStudentApi(phone, authCode);
      return response.data;
    } on DioError catch (e) {
      rethrow;
    }
  }

// Future<List<UserModel>> getUsersRequested() async {
//   try {
//     final response = await userApi.getUsersApi();
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
//     final response = await userApi.updateUserApi(id, name, job);
//     return NewUser.fromJson(response.data);
//   } on DioError catch (e) {
//     rethrow;
//   }
// }
//
// Future<void> deleteNewUserRequested(int id) async {
//   try {
//     await userApi.deleteUserApi(id);
//   } on DioError catch (e) {
//     rethrow;
//   }
// }
}
