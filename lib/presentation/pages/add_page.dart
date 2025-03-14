import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:keepnote/core/utils/title_case_helper.dart';
import 'package:keepnote/data/repositories/note_repository_impl.dart';
import 'package:keepnote/domain/entities/note_entity.dart';
import 'package:keepnote/domain/usecases/add_new_note_usecase.dart';
import 'package:keepnote/domain/usecases/update_note_usecase.dart';
import 'package:keepnote/shared/custom_widgets/custom_snackbar_widget.dart';
import 'package:keepnote/shared/custom_widgets/custom_text_widget.dart';

import '../../core/constants/app_constants.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key, this.task = 'add', this.note});

  final String task;

  final NoteEntity? note;

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  // variables
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime? dateTime;
  String priority = NotePriorityEnum.normal.title;
  late bool completed;

  // functions
  void resetValues() {
    setState(() {
      titleController.clear();
      descriptionController.clear();
      priority = NotePriorityEnum.normal.title;
    });
  }

  // fetch initial values
  void setInitialValues() {
    if (widget.note != null) {
      setState(() {
        completed = widget.note!.completed;
        titleController.text = widget.note!.title ?? "";
        descriptionController.text = widget.note!.description;
        priority = NotePriorityEnum.getTitle(widget.note!.priority);
      });
    }
  }

  // add note
  Future<bool> addNote() async {
    final noteRepository = NoteRepositoryImpl();

    final noteEntity = NoteEntity(
      title: titleController.text.toString(),
      description: descriptionController.text.toString(),
      completed: false,
      dateTime: DateTime.now(),
      priority: NotePriorityEnum.getOption(priority),
    );

    final addNoteUseCase = AddNewNoteUseCase(
      noteRepository: noteRepository,
      noteEntity: noteEntity,
    );

    final response = await addNoteUseCase.call();

    return response;
  }

  // update note
  Future<bool> updateNote() async {
    final noteRepository = NoteRepositoryImpl();

    final noteEntity = NoteEntity(
      id: widget.note!.id,
      title: titleController.text.toString(),
      description: descriptionController.text.toString(),
      completed: widget.note!.completed,
      dateTime: DateTime.now(),
      priority: NotePriorityEnum.getOption(priority),
    );

    final updateNoteUseCase = UpdateNoteUseCase(
      noteEntity: noteEntity,
      noteRepository: noteRepository,
    );

    return await updateNoteUseCase.call();
  }

  @override
  void initState() {
    if (widget.task == 'update') setInitialValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: CustomTextWidget(
          text: widget.task == 'add' ? "Add New Note" : "Update Note",
          type: 'title',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed:
                  () =>
                      widget.task == 'add' ? resetValues() : setInitialValues(),
              icon: Icon(Icons.undo),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).canvasColor,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                spacing: 12.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title
                  TextField(
                    controller: titleController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: 'Title',
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.transparent,
                    ),
                  ),

                  // priority
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [SizedBox(width: 14.0), Text("Priority")]),
                      SizedBox(
                        width: 100.0,
                        child: DropdownButton(
                          isExpanded: true,
                          underline: SizedBox(),
                          value: priority,
                          items: [
                            ...NotePriorityEnum.values.map(
                              (option) => DropdownMenuItem(
                                value: option.title,
                                child: CustomTextWidget(
                                  text: option.title,
                                  type: 'label',
                                ),
                              ),
                            ),
                          ],
                          onChanged: (newVal) {
                            setState(() {
                              priority = newVal!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  // description
                  Expanded(
                    child: Column(
                      children: [
                        Divider(height: 0, thickness: 0),
                        Expanded(
                          child: TextField(
                            controller: descriptionController,
                            maxLines: null,
                            minLines: 1,
                            decoration: InputDecoration(
                              hintText: 'Description',
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.transparent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                height: 45.0,
                child: ElevatedButton(
                  onPressed: () async {
                    // check values
                    if (descriptionController.text.isEmpty) {
                      CustomSnackBarWidget.show(
                        context: context,
                        message: "Description must be provided.",
                        floatHigher: true,
                      );
                      return;
                    }

                    if (widget.task == 'add') {
                      bool response = await addNote();

                      if (!context.mounted) return;

                      CustomSnackBarWidget.show(
                        context: context,
                        message:
                            response
                                ? "Note added successfully"
                                : "Not couldn't be added",
                        floatHigher: true,
                      );

                      if (response) resetValues();
                    } else {
                      bool response = await updateNote();

                      if (!context.mounted) return;

                      // show snack bar
                      CustomSnackBarWidget.show(
                        context: context,
                        message:
                            response
                                ? "Note updated successfully."
                                : "Note couldn't be updated.",
                        floatHigher: true,
                      );
                    }
                  },
                  child: Text(TitleCaseHelper.getString(widget.task)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
