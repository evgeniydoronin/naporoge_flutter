class TodoModel {
  int? id;
  int? userId;
  int? parentId;
  String? title;
  int? category;
  int? order;
  bool? isChecked;

  TodoModel({
    this.id,
    this.userId,
    this.parentId,
    this.title,
    this.category,
    this.order,
    this.isChecked,
  });

  TodoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    parentId = json['parent_id'];
    title = json['title'];
    category = json['category'];
    order = json['order'];
    isChecked = json['is_checked'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'parent_id': parentId,
        'title': title,
        'category': category,
        'order': order,
        'is_checked': isChecked,
      };
}
