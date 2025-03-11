import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:keepnote/domain/entities/note_entity.dart';
import 'package:keepnote/presentation/widgets/priority_badge_widget.dart';

import '../../shared/custom_widgets/custom_text_widget.dart';

class ViewPage extends StatefulWidget {
  const ViewPage({super.key, required this.note});

  final NoteEntity note;

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  // functions
  void deleteNote() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 8.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextWidget(text: 'Delete Note', type: 'title'),
              CustomTextWidget(
                text: "Are you sure you want to delete this note?",
                type: 'body',
                opacity: 0.5,
              ),
              Row(
                spacing: 8.0,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        print("Proceed deletion");
                      },
                      child: Text("Yes, Delete"),
                    ),
                  ),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      child: Text("No, Keep It"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // mark as completed
  void markAsCompleted() {
    print("Marked as completed");
  }

  // mark as pending
  void markAsPending() {
    print("Marked as pending");
  }

  @override
  Widget build(BuildContext context) {
    String priority = "";
    switch (widget.note.priority) {
      case NotePriorityEnum.low:
        priority = "low";
        break;
      case NotePriorityEnum.normal:
        priority = "normal";
        break;
      case NotePriorityEnum.high:
        priority = "high";
        break;
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
        elevation: 4,
        title: CustomTextWidget(text: 'Note Details', type: 'title'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: InkWell(
              onTap: () => context.push('/note/update', extra: widget.note),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Icon(Icons.edit),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: () {
                print("Delete note");
                deleteNote();
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Icon(Icons.delete_outline),
            ),
          ),
        ],
      ),

      backgroundColor: Theme.of(context).canvasColor,

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.maxFinite,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    spacing: 12.0,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.note.title != null
                          ? Row(
                            children: [
                              Expanded(
                                child: CustomTextWidget(
                                  text: widget.note.title ?? 'No title',
                                  type: 'title',
                                ),
                              ),
                              PriorityBadge(priority: priority),
                            ],
                          )
                          : PriorityBadge(priority: priority),
                      CustomTextWidget(
                        text: widget.note.dateTime.toString(),
                        type: 'label',
                        opacity: 0.4,
                      ),
                      CustomTextWidget(
                        text: widget.note.description,
                        type: 'body',
                        opacity: 0.6,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Container(
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                height: 45.0,
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    print(
                      widget.note.completed
                          ? "Marked as pending"
                          : "Marked as completed",
                    );
                  },
                  child: Text(
                    widget.note.completed
                        ? "Mark as Pending"
                        : "Mark As Completed",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
