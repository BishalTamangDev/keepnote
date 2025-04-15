import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:keepnote/core/domain/entities/note_entity.dart';
import 'package:keepnote/core/utils/title_case_helper.dart';
import 'package:keepnote/features/home/presentation/bloc/home_bloc.dart';
import 'package:keepnote/features/view/presentation/bloc/view_bloc.dart';
import 'package:keepnote/shared/custom_widgets/custom_text_widget.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/custom_widgets/custom_snackbar_widget.dart';
import '../bloc/add_bloc.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key, this.task = 'add', this.id = 0});

  final int id;
  final String task;

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  // variables
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? dateTime;
  String priority = NotePriorityEnum.normal.title;
  bool? _completed;

  // functions
  void _reset() {
    setState(() {
      titleController.clear();
      descriptionController.clear();
      priority = NotePriorityEnum.normal.title;
    });
  }

  // fetch initial values
  void _backupData(NoteEntity note) {
    setState(() {
      _completed = note.completed;
      titleController.text = note.title ?? "";
      descriptionController.text = note.description;
      priority = NotePriorityEnum.getTitle(note.priority);
    });
  }

  // add note
  void _addNote() async {
    final NoteEntity noteEntity = NoteEntity(
      title: titleController.text.toString(),
      description: descriptionController.text.toString(),
      completed: false,
      dateTime: DateTime.now(),
      priority: NotePriorityEnum.getOption(priority),
    );
    context.read<AddBloc>().add(AddNoteEvent(noteEntity));
  }

  // update note
  void _updateNote() {
    final noteEntity = NoteEntity(
      id: widget.id,
      title: titleController.text.toString(),
      description: descriptionController.text.toString(),
      completed: _completed ?? false,
      dateTime: DateTime.now(),
      priority: NotePriorityEnum.getOption(priority),
    );

    context.read<AddBloc>().add(AddUpdateEvent(noteEntity));
  }

  @override
  void initState() {
    super.initState();
    if (widget.id != 0) {
      context.read<AddBloc>().add(AddUpdateDataEvent(widget.id));
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new),
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
                      widget.task == 'add'
                          ? context.read<AddBloc>().add(AddResetEvent())
                          : context.read<AddBloc>().add(
                            AddUpdateDataEvent(widget.id),
                          ),
              icon: const Icon(Icons.undo),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).canvasColor,
      body: BlocConsumer<AddBloc, AddState>(
        listenWhen: (previous, current) => current is AddActionState,
        buildWhen: (previous, current) => current is! AddActionState,
        listener: (context, state) {
          if (state is AddUpdateDataAction) {
            // update values
            _backupData(state.noteEntity);
          } else if (state is AddResponseAction) {
            CustomSnackBarWidget.show(context: context, message: state.message);
            // add note response
            if (state.response) {
              context.read<HomeBloc>().add(HomeFetchEvent());
              _reset();
            }
          } else if (state is AddUpdateResponseAction) {
            // update note response
            CustomSnackBarWidget.show(context: context, message: state.message);
            if (state.response) {
              context.read<HomeBloc>().add(HomeFetchEvent());
              context.read<ViewBloc>().add(ViewFetchNoteEvent(widget.id));
            }
          } else if (state is AddResetAction) {
            // reset
            _reset();
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
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
                    const Row(
                      children: [SizedBox(width: 14.0), Text("Priority")],
                    ),
                    SizedBox(
                      width: 100.0,
                      child: DropdownButton(
                        isExpanded: true,
                        underline: const SizedBox(),
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
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        child: SizedBox(
          height: 45.0,
          child: ElevatedButton(
            onPressed: () {
              // check values
              if (descriptionController.text.isEmpty) {
                CustomSnackBarWidget.show(
                  context: context,
                  message: "Description must be provided.",
                );
                return;
              }

              widget.task == 'add' ? _addNote() : _updateNote();
            },
            child: Text(TitleCaseHelper.getString(widget.task)),
          ),
        ),
      ),
    );
  }
}
