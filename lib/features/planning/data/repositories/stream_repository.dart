import 'package:dio/dio.dart';
import 'package:naporoge/features/diary/domain/entities/diary_note_entity.dart';
import 'package:naporoge/features/planning/domain/entities/stream_entity.dart';
import '../models/stream_model.dart';
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

  /// Get user streams
  Future getNPStreamsRequested(int userId) async {
    try {
      final response = await streamApi.getNPStreamsApi(userId);

      return (response.data['streams'] as List).map((e) => NPStreamModel.fromJson(e)).toList();
    } on DioException catch (e) {
      rethrow;
    }
  }

  /// Get stream weeks
  Future getWeeksRequested(List<NPStreamModel> streams) async {
    try {
      final response = await streamApi.getWeeksApi(streams);

      return (response.data['weeks'] as List).map((e) => WeekModel.fromJson(e)).toList();
    } on DioException catch (e) {
      rethrow;
    }
  }

  /// Get week days
  Future getDaysRequested(List<WeekModel> weeks) async {
    try {
      final response = await streamApi.getDaysApi(weeks);

      return (response.data['days'] as List).map((e) => DayModel.fromJson(e)).toList();
    } on DioException catch (e) {
      rethrow;
    }
  }

  /// Get days results
  Future getDaysResultsRequested(List<DayModel> days) async {
    try {
      final response = await streamApi.getDaysResultsApi(days);

      return (response.data['daysResults'] as List).map((e) => DayResultsModel.fromJson(e)).toList();
    } on DioException catch (e) {
      rethrow;
    }
  }

  /// Get diary notes
  Future getDiaryNotesRequested(int userId) async {
    try {
      final response = await streamApi.getDiaryNotesApi(userId);

      return (response.data['diaryNotes'] as List).map((e) => DiaryNoteModel.fromJson(e)).toList();
    } on DioException catch (e) {
      rethrow;
    }
  }

  /// Get two targets
  Future getTwoTargetsRequested(List<NPStreamModel> streams) async {
    try {
      final response = await streamApi.getTwoTargetsApi(streams);

      return (response.data['twoTargets'] as List).map((e) => TwoTargetsModel.fromJson(e)).toList();
    } on DioException catch (e) {
      rethrow;
    }
  }
}
