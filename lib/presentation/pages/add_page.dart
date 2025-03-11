import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:keepnote/core/utils/title_case_helper.dart';
import 'package:keepnote/domain/entities/note_entity.dart';
import 'package:keepnote/shared/custom_widgets/custom_text_widget.dart';

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
  String priority = "normal";

  // functions
  void resetValues() {
    setState(() {
      titleController.clear();
      descriptionController.clear();
      priority = 'normal';
    });
  }

  // fetch initial values
  void setInitialValues() {
    if (widget.note != null) {
      setState(() {
        titleController.text = widget.note!.title ?? "";
        descriptionController.text = widget.note!.description ?? "";
        switch (widget.note!.priority) {
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
      });
    }
  }

  // add note
  void addNote() {
    print("Add note");
  }

  // update note
  void updateNote() {
    print("Update note");
  }

  @override
  void initState() {
    if (widget.task == 'update') {
      setInitialValues();
    }
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
                            DropdownMenuItem(
                              value: 'normal',
                              child: CustomTextWidget(
                                text: 'Normal',
                                type: 'label',
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'high',
                              child: CustomTextWidget(
                                text: 'High',
                                type: 'label',
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'low',
                              child: CustomTextWidget(
                                text: 'Low',
                                type: 'label',
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
                  onPressed:
                      () => widget.task == 'add' ? addNote() : updateNote(),
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
