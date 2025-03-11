import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:keepnote/domain/entities/note_entity.dart';
import 'package:keepnote/presentation/widgets/priority_badge_widget.dart';
import 'package:keepnote/shared/custom_widgets/custom_text_widget.dart';

class NoteWidget extends StatefulWidget {
  const NoteWidget({super.key, required this.note});

  final NoteEntity note;

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  @override
  Widget build(BuildContext context) {
    String priority = "";

    switch (widget.note.priority) {
      case NotePriorityEnum.normal:
        priority = "normal";
        break;
      case NotePriorityEnum.low:
        priority = "low";
        break;
      case NotePriorityEnum.high:
        priority = "high";
        break;
    }

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(8.0),
      onTap: () => context.push("/note/view", extra: widget.note),
      child: Opacity(
        opacity: widget.note.completed ? 0.3 : 1,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.2), // Shadow color
                spreadRadius: 0.5,
                blurRadius: 16,
                offset: Offset(0, 0), // X and Y offset
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              spacing: 8.0,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.note.title != null
                    ? Row(
                      children: [
                        Expanded(
                          child: CustomTextWidget(
                            text: widget.note.title ?? "",
                            type: 'title',
                          ),
                        ),
                        PriorityBadge(priority: priority),
                      ],
                    )
                    : Row(
                      children: [
                        Expanded(
                          child: CustomTextWidget(
                            text: widget.note.description ?? "",
                            type: 'body',
                          ),
                        ),
                        PriorityBadge(priority: priority),
                      ],
                    ),

                if (widget.note.title != null)
                  CustomTextWidget(
                    text: widget.note.description ?? "",
                    opacity: 0.7,
                    maxLines: 2,
                  ),

                CustomTextWidget(
                  text: widget.note.dateTime.toString(),
                  opacity: 0.3,
                  type: 'label',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
