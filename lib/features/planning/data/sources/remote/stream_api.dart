import 'package:dio/dio.dart';

import '../../../../../../core/services/http_client/dio_client.dart';
import '../../../../../../core/constants/endpoints.dart';

class StreamApi {
  final DioClient dioClient;

  StreamApi({required this.dioClient});

  Future<Response> createStreamApi(Map streamData) async {
    // print('createStreamApi: $streamData');
    try {
      final Response response = await dioClient.post(
        Endpoints.createStream,
        data: streamData,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateStreamApi(Map streamData) async {
    // print('updateStreamApi: $streamData');
    try {
      final Response response = await dioClient.post(
        Endpoints.updateStream,
        data: streamData,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> createWeekApi(Map weekData) async {
    // print('updateStreamApi: $streamData');
    try {
      final Response response = await dioClient.post(
        Endpoints.createWeek,
        data: weekData,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateWeekApi(Map weekData) async {
    // print('updateStreamApi: $streamData');
    try {
      final Response response = await dioClient.post(
        Endpoints.updateWeek,
        data: weekData,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateWeekProgressApi(Map weekData) async {
    // print('updateStreamApi: $streamData');
    try {
      final Response response = await dioClient.post(
        Endpoints.updateWeekProgress,
        data: weekData,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> createDayResultApi(Map dayResultData) async {
    try {
      final Response response = await dioClient.post(
        Endpoints.createDayResult,
        data: dayResultData,
      );
      // print(response);
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
