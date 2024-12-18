import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studybean/common/di/get_it.dart';
import 'package:studybean/common/extensions/context_dialog_extension.dart';
import 'package:studybean/common/widgets/bottom_sheet_header_widget.dart';
import 'package:studybean/features/roadmap/models/edit_local_milestone_input.dart';
import 'package:studybean/features/roadmap/models/roadmap.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/edit_milestone_cubit/edit_local_milestone_cubit.dart';

import '../../../models/edit_milestone_input.dart';
import '../bloc/edit_milestone_cubit/edit_milestone_cubit.dart';

class EditMilestoneWidget extends StatefulWidget {
  const EditMilestoneWidget({super.key, required this.milestone});

  final Milestone milestone;

  @override
  State<EditMilestoneWidget> createState() => _EditMilestoneWidgetState();
}

class _EditMilestoneWidgetState extends State<EditMilestoneWidget> {
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
      create: (context) => getIt<EditMilestoneCubit>(),
      child: BlocConsumer<EditMilestoneCubit, EditMilestoneState>(
        listener: (context, state) {
          switch (state) {
            case EditMilestoneInitial():
            case EditMilestoneLoading():
              break;
            case EditMilestoneSuccess():
              context.pop(state.milestone);
              break;
            case EditMilestoneError():
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
          return Form(
            key: _formKey,
            child: Column(
              children: [
                const BottomSheetHeaderWidget(),
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
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<EditMilestoneCubit>().editMilestone(
                                EditMilestoneInput(
                                  name: _titleController.text,
                                  id: widget.milestone.id,
                                ),
                              );
                        }
                      },
                      child: const Text('Save')),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
