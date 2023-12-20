import 'package:dio/dio.dart';

import '../../../../../../core/services/http_client/dio_client.dart';
import '../../../../../../core/constants/endpoints.dart';

class UserApi {
  final DioClient dioClient;

  UserApi({required this.dioClient});

  Future<Response> getSmsConfirmCodeApi(String phone) async {
    try {
      final Response response = await dioClient.post(
        Endpoints.smsCode,
        data: {
          'phone': phone,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> confirmAuthCodeApi(String authCode) async {
    try {
      final Response response = await dioClient.post(
        Endpoints.authCode,
        data: {
          'authCode': authCode,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> createStudentApi(String phone, String authCode) async {
    try {
      final Response response = await dioClient.post(
        Endpoints.createStudent,
        data: {
          'phone': phone,
          'authCode': authCode,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getStudentApi(String phone) async {
    try {
      final Response response = await dioClient.get(
        Endpoints.getStudent,
        queryParameters: {'phone': phone},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

// Future<Response> getUsersApi() async {
//   try {
//     final Response response = await dioClient.get(Endpoints.users);
//     return response;
//   } catch (e) {
//     rethrow;
//   }
// }
//
// Future<Response> updateUserApi(int id, String name, String job) async {
//   try {
//     final Response response = await dioClient.put(
//       '${Endpoints.users}/$id',
//       data: {
//         'name': name,
//         'job': job,
//       },
//     );
//     return response;
//   } catch (e) {
//     rethrow;
//   }
// }
//
// Future<void> deleteUserApi(int id) async {
//   try {
//     await dioClient.delete('${Endpoints.users}/$id');
//   } catch (e) {
//     rethrow;
//   }
// }
}
