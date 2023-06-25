import '../../../../core/data/models/course_model.dart';

class StreamModel {
  int? id;
  Course? npCase;

  StreamModel({this.id, this.npCase});

  StreamModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    npCase = json['npCase']['caseId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['npCase'] = npCase;
    return data;
  }
}
