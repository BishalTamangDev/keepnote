enum NotePriorityEnum { low, normal, high }

class NoteEntity {
  final int? id;
  final String? title;
  final String description;
  final NotePriorityEnum priority;
  final DateTime dateTime;
  final bool completed;

  NoteEntity({
    this.id,
    this.title,
    required this.description,
    this.priority = NotePriorityEnum.normal,
    this.completed = false,
    required this.dateTime,
  });
}
