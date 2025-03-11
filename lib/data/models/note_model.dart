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

  // Convert JSON to Model
  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String,
      priority: NotePriorityEnum.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => NotePriorityEnum.normal, // Default if value is invalid
      ),
      completed: json['completed'] == 1 ? true : false,
      dateTime:
          json['dateTime'] != null
              ? DateTime.parse(json['dateTime'])
              : DateTime.now(),
    );
  }

  // Convert Model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.name, // Store as string
      'completed': completed,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  // Convert Entity to Model
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
}
