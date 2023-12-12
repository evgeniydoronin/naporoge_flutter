import '../../features/planning/data/sources/local/stream_local_storage.dart';
import '../../features/planning/domain/entities/stream_entity.dart';

/// Get Stream status
///
/// return: 'status' = "before | after | process";
Future getStreamStatus() async {
  Map streamStatus = {};

  final storage = StreamLocalStorage();
  NPStream stream = await storage.getActiveStream();

  DateTime now = DateTime.now();

  DateTime startStream = stream.startAt!;
  DateTime endStream =
      stream.startAt!.add(Duration(days: (stream.weeks! * 7) - 1, hours: 23, minutes: 59, seconds: 59));

  bool isBeforeStartStream = startStream.isAfter(now);
  bool isAfterEndStream = endStream.isBefore(now);

  // До старта курса
  if (isBeforeStartStream) {
    streamStatus['status'] = "before";
  }
  // После завершения курса
  else if (isAfterEndStream) {
    streamStatus['status'] = "after";
  }
  // Во время прохождения курса
  else if (!isBeforeStartStream && !isAfterEndStream) {
    streamStatus['status'] = "process";
  }

  return streamStatus;
}
