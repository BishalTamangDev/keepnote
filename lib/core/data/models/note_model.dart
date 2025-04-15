import '../../constants/app_constants.dart';
import '../../domain/entities/note_entity.dart';

class NoteModel extends NoteEntity {
  NoteModel({
    super.id,
    super.title,
    required super.description,
    super.priority,
    super.completed,
    required super.dateTime,
  });

  // map to model
  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] as int?,
      title: map['title'] as String?,
      description: map['description'] as String,
      priority: NotePriorityEnum.getOption(map['priority']),
      completed: map['completed'] == 1 ? true : false,
      dateTime:
          map['date_time'] != null
              ? DateTime.parse(map['date_time'])
              : DateTime.now(),
    );
  }

  // model to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.name, // Store as string
      'completed': completed,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  // from entity to model
  factory NoteModel.fromEntity(NoteEntity entity) {
    return NoteModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      priority: entity.priority,
      completed: entity.completed,
      dateTime: entity.dateTime,
    );
  }

  // to entity from model
  NoteEntity toEntity() {
    return NoteEntity(
      id: id,
      title: title,
      description: description,
      priority: priority,
      completed: completed,
      dateTime: dateTime,
    );
  }

  // to string
  @override
  String toString() =>
      "NoteModel{id: $id, title: $title, $description: $description, priority: $priority, completed: $completed, dateTime: $dateTime}";
}
