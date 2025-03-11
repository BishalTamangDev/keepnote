class NoteModel {
  int? id;
  String? title;
  String description;
  String priority;
  DateTime? dateTime;
  bool completed;

  NoteModel({
    this.id,
    this.title,
    required this.description,
    this.priority = 'normal',
    this.completed = false,
    DateTime? newDateTime,
  }) : dateTime = newDateTime ?? DateTime.now();

  //   from json
  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      priority: json['priority'],
      completed: json['completed'],
      newDateTime: json['dateTime'],
    );
  }
}
