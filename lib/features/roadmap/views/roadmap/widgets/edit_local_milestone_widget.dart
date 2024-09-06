import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studybean/common/di/get_it.dart';
import 'package:studybean/common/extensions/context_dialog_extension.dart';
import 'package:studybean/common/extensions/context_theme.dart';
import 'package:studybean/common/widgets/bottom_sheet_header_widget.dart';
import 'package:studybean/features/roadmap/models/edit_local_milestone_input.dart';
import 'package:studybean/features/roadmap/models/roadmap.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/edit_milestone_cubit/edit_local_milestone_cubit.dart';

class EditLocalMilestoneWidget extends StatefulWidget {
  const EditLocalMilestoneWidget({super.key, required this.milestone});

  final Milestone milestone;

  @override
  State<EditLocalMilestoneWidget> createState() =>
      _EditLocalMilestoneWidgetState();
}

class _EditLocalMilestoneWidgetState extends State<EditLocalMilestoneWidget> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _titleController;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _titleController = TextEditingController(text: widget.milestone.name);
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EditLocalMilestoneCubit>(),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            BlocConsumer<EditLocalMilestoneCubit, EditLocalMilestoneState>(
              listener: (context, state) {
                switch (state) {
                  case EditLocalMilestoneInitial():
                  case EditLocalMilestoneLoading():
                    break;
                  case EditLocalMilestoneSuccess():
                    context.pop(state.milestone);
                    break;
                  case EditLocalMilestoneError():
                    context.showErrorDialog(
                        title: 'Failed to save milestone',
                        message: 'Something went wrong, please try again later',
                        onRetry: () {
                          context.read<EditLocalMilestoneCubit>().editMilestone(
                                EditLocalMilestoneInput(
                                  name: _titleController.text,
                                  milestoneId: widget.milestone.id,
                                ),
                              );
                        });
                    break;
                }
              },
              builder: (context, state) {
                return BottomSheetHeaderWidget(
                  action: GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<EditLocalMilestoneCubit>().editMilestone(
                              EditLocalMilestoneInput(
                                name: _titleController.text,
                                milestoneId: widget.milestone.id,
                              ),
                            );
                      }
                    },
                    child: Text(
                      'Save',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.theme.colorScheme.primary,
                          ),
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Title',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    controller: _titleController,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
