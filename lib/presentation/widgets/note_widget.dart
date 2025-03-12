import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:keepnote/core/utils/format_date_time_helper.dart';
import 'package:keepnote/domain/entities/note_entity.dart';
import 'package:keepnote/presentation/widgets/priority_badge_widget.dart';
import 'package:keepnote/shared/custom_widgets/custom_text_widget.dart';

import '../../core/constants/app_constants.dart';

class NoteWidget extends StatefulWidget {
  const NoteWidget({super.key, required this.note, required this.callback});

  final NoteEntity note;

  final VoidCallback callback;

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  @override
  Widget build(BuildContext context) {
    String priority = NotePriorityEnum.getTitle(widget.note.priority);

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(8.0),
      onTap:
          () => context
              .push("/note/view/${widget.note.id}")
              .then((_) => widget.callback()),
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
                widget.note.title != null && widget.note.title!.isNotEmpty
                    ? Row(
                      children: [
                        Expanded(
                          child: CustomTextWidget(
                            text: widget.note.title ?? "",
                            type: 'title',
                          ),
                        ),
                        PriorityBadge(priority: widget.note.priority),
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
                        PriorityBadge(priority: widget.note.priority),
                      ],
                    ),

                if (widget.note.title != null && widget.note.title!.isNotEmpty)
                  CustomTextWidget(
                    text: widget.note.description ?? "",
                    opacity: 0.7,
                    maxLines: 2,
                  ),

                CustomTextWidget(
                  text: FormatDateTimeHelper.getString(widget.note.dateTime),
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
