class NoteEntity {
  int? id;
  String? title;
  String description;
  String priority;
  DateTime? dateTime;
  bool completed;

  NoteEntity({
    this.id,
    this.title,
    required this.description,
    this.priority = 'normal',
    this.completed = false,
    DateTime? newDateTime,
  }) : dateTime = newDateTime ?? DateTime.now();
}
