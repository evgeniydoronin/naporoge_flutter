import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:naporoge/features/diary/domain/entities/diary_note_entity.dart';

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

  Future<Response> deleteStreamApi(Map streamData) async {
    // print('createStreamApi: $streamData');
    try {
      final Response response = await dioClient.post(
        Endpoints.deleteStream,
        data: streamData,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> deactivateStreamApi(Map streamData) async {
    // print('createStreamApi: $streamData');
    try {
      final Response response = await dioClient.post(
        Endpoints.deactivateStream,
        data: streamData,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> createNextStreamApi(Map streamData) async {
    // print('createStreamApi: $streamData');
    try {
      final Response response = await dioClient.post(
        Endpoints.createNextStream,
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

  Future<Response> expandStreamApi(Map streamData) async {
    // print('updateStreamApi: $streamData');
    try {
      final Response response = await dioClient.post(
        Endpoints.expandStream,
        data: streamData,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> createWeekApi(Map weekData) async {
    // print('createWeekApi: $weekData');
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

  Future<Response> createTwoTargetsApi(Map data) async {
    try {
      final Response response = await dioClient.post(
        Endpoints.createTwoTargets,
        data: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateTwoTargetsApi(Map data) async {
    try {
      final Response response = await dioClient.post(
        Endpoints.updateTwoTargets,
        data: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> createDiaryNoteApi(Map noteData) async {
    // print('updateStreamApi: $streamData');
    try {
      final Response response = await dioClient.post(
        Endpoints.createDiaryNote,
        data: noteData,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateDiaryNoteApi(Map data) async {
    // print('updateDiaryNoteApi: $data');
    try {
      final Response response = await dioClient.post(
        Endpoints.updateDiaryNote,
        data: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> deleteDiaryNoteApi(Map data) async {
    // print('updateDiaryNoteApi: $data');
    try {
      final Response response = await dioClient.post(
        Endpoints.deleteDiaryNote,
        data: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> deleteDuplicatesResultApi(Map duplicates) async {
    try {
      final Response response = await dioClient.post(
        Endpoints.deleteDuplicatesResult,
        data: duplicates,
      );
      // print(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getNPStreamsApi(int userId) async {
    try {
      final Response response = await dioClient.get(
        Endpoints.getStreams,
        queryParameters: {'user_id': userId},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getTodosApi(int userId) async {
    try {
      final Response response = await dioClient.get(
        Endpoints.getTodos,
        queryParameters: {'user_id': userId},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getWeeksApi(List streams) async {
    List streamsIds = streams.map((stream) => stream.id.toString()).toList();
    // print('streamsIds: ${streamsIds}');
    // print('streamsIds: ${jsonEncode(streamsIds)}');
    try {
      final Response response = await dioClient.get(
        Endpoints.getWeeks,
        queryParameters: {'streamsIds': jsonEncode(streamsIds)},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getDaysApi(List weeks) async {
    List weeksIds = weeks.map((week) => week.id.toString()).toList();
    try {
      final Response response = await dioClient.get(
        Endpoints.getDays,
        queryParameters: {'weeksIds': jsonEncode(weeksIds)},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getDaysResultsApi(List days) async {
    List daysIds = days.map((days) => days.id.toString()).toList();
    try {
      final Response response = await dioClient.get(
        Endpoints.getDaysResults,
        queryParameters: {'daysIds': jsonEncode(daysIds)},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getDiaryNotesApi(int userId) async {
    try {
      final Response response = await dioClient.get(
        Endpoints.getDiaryNotes,
        queryParameters: {'userId': userId},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getTwoTargetsApi(List streams) async {
    List streamsIds = streams.map((stream) => stream.id.toString()).toList();
    try {
      final Response response = await dioClient.get(
        Endpoints.getTwoTargets,
        queryParameters: {'streamsIds': jsonEncode(streamsIds)},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
