class PushNotificationModel {
  int? id;
  String? title;
  String? body;
  String? startTime;

  PushNotificationModel({
    this.id,
    this.title,
    this.body,
    this.startTime,
  });

  PushNotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    startTime = json['start_time'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'start_time': startTime,
      };
}

List<PushNotificationModel> fakePushNotifications = [
  PushNotificationModel(
    id: 0,
    title: '1',
    body: 'Привет! Курс начался, желаем успехов!',
    startTime: '05:00',
  ),
  PushNotificationModel(
    id: 1,
    title: '2',
    body: 'Старайтесь отмечать результаты как можно точнее',
    startTime: '05:00',
  ),
  PushNotificationModel(
      id: 2,
      title: '3',
      body: 'Появилось 2 новых видео! Что делать, когда не хочу делать дело? Почему откладываются дела?',
      startTime: '09:00'),
  PushNotificationModel(
    id: 3,
    title: '4',
    body: 'Появилось новое видео: Верное завершение дел',
    startTime: '09:00',
  ),
];
