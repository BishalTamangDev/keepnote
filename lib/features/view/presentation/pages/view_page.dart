import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:keepnote/features/home/presentation/bloc/home_bloc.dart';
import 'package:keepnote/features/view/presentation/view_error_page.dart';
import 'package:keepnote/shared/custom_widgets/custom_snackbar_widget.dart';

import '../../../../core/utils/format_date_time_helper.dart';
import '../../../../shared/custom_widgets/custom_text_widget.dart';
import '../../../../shared/priority_badge_widget.dart';
import '../bloc/view_bloc.dart';

class ViewPage extends StatefulWidget {
  const ViewPage({super.key});

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  // variables
  bool? _completed;

  // functions
  // update changing details ::
  void _updateChangingData(bool completed) {
    setState(() {
      _completed = completed;
    });
  }

  // delete note
  void _deleteNote(int id) {
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
                        context.read<ViewBloc>().add(ViewDeleteNoteEvent(id));
                        context.pop();
                      },
                      child: const Text("Yes, Delete"),
                    ),
                  ),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      child: const Text("No, Keep It"),
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ViewBloc, ViewState>(
      listenWhen: (previous, current) => current is ViewAction,
      buildWhen: (previous, current) => current is! ViewAction,
      listener: (context, state) {
        if (state is ViewUpdateChangingDataAction) {
          _updateChangingData(state.completed);
        } else if (state is ViewMarkAsCompletedResponseAction) {
          if (state.response) {
            // update data
            context.read<HomeBloc>().add(HomeFetchEvent());
            _updateChangingData(true);
          } else {
            CustomSnackBarWidget.show(context: context, message: state.message);
          }
        } else if (state is ViewMarkAsPendingResponseAction) {
          if (state.response) {
            // update data
            context.read<HomeBloc>().add(HomeFetchEvent());
            _updateChangingData(false);
          } else {
            CustomSnackBarWidget.show(context: context, message: state.message);
          }
        } else if (state is ViewDeleteResponseAction) {
          if (state.response) {
            context.read<HomeBloc>().add(HomeFetchEvent());
            context.pop();
          } else {
            CustomSnackBarWidget.show(context: context, message: state.message);
          }
        }
      },
      builder: (context, state) {
        switch (state) {
          case ViewError():
            return ViewErrorPage();
          case ViewLoaded():
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                leading: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: () => context.pop(),
                ),
                elevation: 4,
                title: CustomTextWidget(text: 'Note Details', type: 'title'),
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: 12.0),
                    child: InkWell(
                      onTap:
                          () => context.push(
                            '/note/update/${state.noteEntity.id}',
                          ),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: const Icon(Icons.edit),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: InkWell(
                      onTap: () => _deleteNote(state.noteEntity.id ?? 0),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: const Icon(Icons.delete_outline),
                    ),
                  ),
                ],
              ),

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
                              state.noteEntity.title != null &&
                                      state.noteEntity.title!.isNotEmpty
                                  ? Row(
                                    children: [
                                      Expanded(
                                        child: CustomTextWidget(
                                          text:
                                              state.noteEntity.title ??
                                              'No title',
                                          type: 'title',
                                        ),
                                      ),
                                      PriorityBadge(
                                        priority: state.noteEntity.priority,
                                      ),
                                    ],
                                  )
                                  : PriorityBadge(
                                    priority: state.noteEntity.priority,
                                  ),
                              CustomTextWidget(
                                text: FormatDateTimeHelper.getString(
                                  state.noteEntity.dateTime,
                                ),
                                type: 'label',
                                opacity: 0.4,
                              ),
                              CustomTextWidget(
                                text: state.noteEntity.description,
                                type: 'body',
                                opacity: 0.6,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // action :: mark as completed || mark as pending
                  Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        height: 45.0,
                        color: Colors.transparent,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () {
                            debugPrint("Mark as completed || pending.");
                            if (_completed == null) return;
                            if (_completed!) {
                              context.read<ViewBloc>().add(
                                ViewMarkAsPendingEvent(
                                  state.noteEntity.id ?? 0,
                                ),
                              );
                            } else {
                              context.read<ViewBloc>().add(
                                ViewMarkAsCompletedEvent(
                                  state.noteEntity.id ?? 0,
                                ),
                              );
                            }
                          },
                          child:
                              _completed == null
                                  ? CircularProgressIndicator()
                                  : Text(
                                    _completed!
                                        ? 'Mark as Pending'
                                        : 'Mark as Completed',
                                  ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          default:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
        }
      },
    );
  }
}
