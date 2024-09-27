import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studybean/common/di/get_it.dart';
import 'package:studybean/common/extensions/context_dialog_extension.dart';
import 'package:studybean/common/extensions/context_theme.dart';
import 'package:studybean/features/roadmap/models/duration_unit.dart';
import 'package:studybean/features/roadmap/models/roadmap.dart';

import '../../../../../common/widgets/bottom_sheet_header_widget.dart';
import '../../../models/update_action_input.dart';
import '../bloc/edit_action_cubit/edit_action_cubit.dart';

class EditActionWidget extends StatefulWidget {
  const EditActionWidget({super.key, required this.action});

  final MilestoneAction action;

  @override
  State<EditActionWidget> createState() => _EditActionWidgetState();
}

class _EditActionWidgetState extends State<EditActionWidget> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _titleController;
  late final TextEditingController _durationController;
  late final TextEditingController _descriptionController;
  late final FocusNode _descriptionFocusNode;
  late final FocusNode _titleFocusNode;
  late final FocusNode _durationFocusNode;

  late DurationUnit _durationUnit = widget.action.durationUnit;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _titleController = TextEditingController()..text = widget.action.name;
    _durationController = TextEditingController()
      ..text = widget.action.duration.toString();
    _descriptionController = TextEditingController()
      ..text = widget.action.description ?? '';
    _titleFocusNode = FocusNode();
    _durationFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _descriptionController.dispose();
    _titleFocusNode.dispose();
    _durationFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EditActionCubit>(),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            BlocConsumer<EditActionCubit, EditActionState>(
              listener: (context, state) {
                switch (state) {
                  case EditActionInitial():
                  case EditActionLoading():
                    break;
                  case EditActionSuccess():
                    context.pop(state.action);
                    break;
                  case EditActionError():
                    context.showErrorDialog(
                        title: 'Failed to save action',
                        message: 'Something went wrong, please try again later',
                        onRetry: () {
                          context.read<EditActionCubit>().editAction(
                            UpdateActionInput(
                              id: widget.action.id,
                              name: _titleController.text,
                              description: _descriptionController.text,
                              duration: int.parse(_durationController.text),
                              durationUnit: _durationUnit,
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
                        context.read<EditActionCubit>().editAction(
                          UpdateActionInput(
                            id: widget.action.id,
                            name: _titleController.text,
                            description: _descriptionController.text,
                            duration: int.parse(_durationController.text),
                            durationUnit: _durationUnit,
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Save',
                      style: context.theme.textTheme.bodyMedium?.copyWith(
                        color: context.theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Title',
                        style: context.theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _titleController,
                        focusNode: _titleFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter title';
                          }
                          return null;
                        },
                        decoration: const InputDecoration()
                            .applyDefaults(context.theme.inputDecorationTheme)
                            .copyWith(
                          hintText: 'What are you going to do?',
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Estimated time',
                        style: context.theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _durationController,
                              focusNode: _durationFocusNode,
                              onChanged: (value) {
                                if (value.isEmpty) return;
                              },
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration()
                                  .applyDefaults(
                                  context.theme.inputDecorationTheme)
                                  .copyWith(
                                hintText: '3',
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: DropdownMenu<DurationUnit>(
                              initialSelection: _durationUnit,
                              onSelected: (unit) {
                                if (unit == null) return;

                                setState(() {
                                  _durationUnit = unit;
                                });
                              },
                              dropdownMenuEntries: DurationUnit.values
                                  .map(
                                    (e) => DropdownMenuEntry<DurationUnit>(
                                  value: e,
                                  label: e.name,
                                ),
                              )
                                  .toList(),
                            ),
                          ),
                          const Expanded(flex: 2, child: SizedBox.shrink())
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Description',
                        style: context.theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _descriptionController,
                        focusNode: _descriptionFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter description';
                          }
                          return null;
                        },
                        decoration: const InputDecoration()
                            .applyDefaults(context.theme.inputDecorationTheme)
                            .copyWith(
                          hintText: 'Describe your activity',
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
