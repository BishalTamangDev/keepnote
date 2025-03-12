import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:keepnote/core/utils/format_date_time_helper.dart';
import 'package:keepnote/data/repositories/note_repository_impl.dart';
import 'package:keepnote/domain/entities/note_entity.dart';
import 'package:keepnote/domain/usecases/delete_note_usecase.dart';
import 'package:keepnote/domain/usecases/mark_note_as_completed_usecase.dart';
import 'package:keepnote/domain/usecases/mark_note_as_pending_usecase.dart';
import 'package:keepnote/presentation/widgets/priority_badge_widget.dart';
import 'package:keepnote/shared/custom_widgets/custom_snackbar_widget.dart';

import '../../shared/custom_widgets/custom_text_widget.dart';

class ViewPage extends StatefulWidget {
  const ViewPage({super.key, required this.note});

  final NoteEntity note;

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  // delete function
  Future<bool> deleteNote() async {
    final noteRepository = NoteRepositoryImpl();
    final deleteNoteUseCase = DeleteNoteUseCase(
      noteRepository: noteRepository,
      id: widget.note.id!,
    );
    return await deleteNoteUseCase.call();
  }

  // functions
  void showNoteDeletionDialog() {
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
                      onPressed: () async {
                        bool response = await deleteNote();

                        if (!context.mounted) return;

                        context.pop();
                        context.pop();

                        CustomSnackBarWidget.show(
                          context: context,
                          message:
                              response
                                  ? "Note deleted successfully"
                                  : "Note couldn't be deleted",
                          floatHigher: false,
                        );
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
  Future<bool> markAsCompleted() async {
    final noteRepository = NoteRepositoryImpl();
    final markNoteAaCompletedUseCase = MarkNoteAsCompletedUseCase(
      id: widget.note.id!,
      noteRepository: noteRepository,
    );
    return markNoteAaCompletedUseCase.call();
  }

  // mark as pending
  Future<bool> markAsPending() async {
    final noteRepository = NoteRepositoryImpl();
    final markNoteAsPendingUseCase = MarkNoteAsPendingUseCase(
      id: widget.note.id!,
      noteRepository: noteRepository,
    );
    return markNoteAsPendingUseCase.call();
  }

  late String buttonLabel = "-";

  @override
  void initState() {
    super.initState();
    buttonLabel =
        widget.note.completed ? "Mark as Pending" : "Mark as Completed";
  }

  @override
  Widget build(BuildContext context) {
    String priority = widget.note.title!;

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
              onTap: () => showNoteDeletionDialog(),
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
                      widget.note.title != null && widget.note.title!.isNotEmpty
                          ? Row(
                            children: [
                              Expanded(
                                child: CustomTextWidget(
                                  text: widget.note.title ?? 'No title',
                                  type: 'title',
                                ),
                              ),
                              PriorityBadge(priority: widget.note.priority),
                            ],
                          )
                          : PriorityBadge(priority: widget.note.priority),
                      CustomTextWidget(
                        text: FormatDateTimeHelper.getString(
                          widget.note.dateTime,
                        ),
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
                  onPressed: () async {
                    bool response =
                        widget.note.completed
                            ? await markAsPending()
                            : await markAsCompleted();

                    if (response) {
                      setState(() {
                        if (buttonLabel == "Mark as Completed") {
                          buttonLabel = "Mark as Pending";
                        } else {
                          buttonLabel = "Mark as Completed";
                        }
                      });
                    }
                  },
                  child: Text(buttonLabel),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
