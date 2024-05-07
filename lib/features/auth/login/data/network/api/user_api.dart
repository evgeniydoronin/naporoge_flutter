import 'package:dio/dio.dart';
import 'package:isar/isar.dart';
import 'package:naporoge/features/auth/login/domain/user_model.dart';

import '../../../../../../core/services/db_client/isar_service.dart';
import '../../../../../../core/services/http_client/dio_client.dart';
import '../../../../../../core/constants/endpoints.dart';
import '../../../../../../core/services/notification_service.dart';
import '../../../../../../core/services/push_notifications/push_notifications.dart';

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
    /// Firebase token
    final String? fcmToken = await NotificationService().getToken();

    DateTime dateTime = DateTime.now();
    String timeZoneName = dateTime.timeZoneName;
    Duration timeZoneOffset = dateTime.timeZoneOffset;

    try {
      final Response response = await dioClient.post(
        Endpoints.createStudent,
        data: {
          'phone': phone,
          'authCode': authCode,
          'fcmToken': fcmToken,
          'timeZoneName': timeZoneName,
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

  Future<Response> updateUserTokenApi() async {
    final isarService = IsarService();
    final isar = await isarService.db;
    final user = await isar.users.where().findFirst();

    /// Firebase token
    final String? fcmToken = await NotificationService().getToken();

    print('updateUserTokenApi: ${user?.id} $fcmToken');

    try {
      final Response response = await dioClient.post(
        Endpoints.updateToken,
        data: {
          'user_id': user?.id,
          'fcmToken': fcmToken,
        },
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
