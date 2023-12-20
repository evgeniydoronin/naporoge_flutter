class NPStreamModel {
  int? id;
  bool? isActive;
  String? courseId;
  int? weeks;
  DateTime? startAt;
  String? title;
  String? description;

  NPStreamModel(
      {required this.id,
      required this.isActive,
      required this.courseId,
      required this.weeks,
      required this.startAt,
      required this.title,
      required this.description});

  NPStreamModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isActive = json['is_active'] == 0 ? false : true;
    courseId = json['course_id'];
    weeks = json['weeks'];
    startAt = DateTime.parse(json['start_at']);
    title = json['title'];
    description = json['description'];
  }
}

class WeekModel {
  int? id;
  int? streamId;
  int? weekNumber;
  int? weekYear;
  DateTime? monday;
  bool? systemConfirmed;
  bool? userConfirmed;
  String? progress;
  String? cells;

  WeekModel({
    required this.id,
    required this.streamId,
    required this.weekNumber,
    required this.weekYear,
    required this.monday,
    required this.systemConfirmed,
    required this.userConfirmed,
    required this.progress,
    required this.cells,
  });

  WeekModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    streamId = json['stream_id'];
    weekNumber = json['number'];
    weekYear = json['year'];
    monday = DateTime.parse(json['monday']);
    systemConfirmed = json['system_confirmed'] == 0 ? false : true;
    userConfirmed = json['user_confirmed'] == 0 ? false : true;
    progress = json['progress'];
    cells = json['cells'];
  }
}

class DayModel {
  int? id;
  int? weekId;
  DateTime? dateAt;
  DateTime? startAt;
  DateTime? completedAt;

  DayModel({
    required this.id,
    required this.weekId,
    required this.dateAt,
    required this.startAt,
    required this.completedAt,
  });

  DayModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    weekId = json['week_id'];
    dateAt = json['date_at'] != null ? DateTime.parse(json['date_at']) : null;
    startAt = json['start_at'] != null ? DateTime.parse(json['start_at']) : null;
    completedAt = json['completed_at'] != null ? DateTime.parse(json['completed_at']) : null;
  }
}

class DayResultsModel {
  int? id;
  int? dayId;
  int? executionScope;
  String? result;
  String? desires;
  String? reluctance;
  String? interference;
  String? rejoice;

  DayResultsModel({
    required this.id,
    required this.dayId,
    required this.executionScope,
    required this.result,
    required this.desires,
    required this.reluctance,
    required this.interference,
    required this.rejoice,
  });

  DayResultsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dayId = json['day_id'];
    executionScope = json['execution_scope'];
    result = json['result'];
    desires = json['desires'];
    reluctance = json['reluctance'];
    interference = json['interference'];
    rejoice = json['rejoice'];
  }
}

class DiaryNoteModel {
  int? id;
  DateTime? createAt;
  DateTime? updateAt;
  String? diaryNote;

  DiaryNoteModel({
    required this.id,
    required this.createAt,
    required this.updateAt,
    required this.diaryNote,
  });

  DiaryNoteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createAt = json['created_at'] != null ? DateTime.parse(json['created_at']) : null;
    updateAt = json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null;
    diaryNote = json['note'];
  }
}

class TwoTargetsModel {
  int? id;
  int? streamId;
  String? title;
  String? minimum;
  String? targetOneTitle;
  String? targetOneDescription;
  String? targetTwoTitle;
  String? targetTwoDescription;

  TwoTargetsModel({
    required this.id,
    required this.streamId,
    required this.title,
    required this.minimum,
    required this.targetOneTitle,
    required this.targetOneDescription,
    required this.targetTwoTitle,
    required this.targetTwoDescription,
  });

  TwoTargetsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    streamId = json['stream_id'];
    title = json['title'];
    minimum = json['minimum'];
    targetOneTitle = json['target_one_title'];
    targetOneDescription = json['target_one_description'];
    targetTwoTitle = json['target_two_title'];
    targetTwoDescription = json['target_two_description'];
  }
}
