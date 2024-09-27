import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studybean/common/di/get_it.dart';
import 'package:studybean/common/extensions/context_dialog_extension.dart';
import 'package:studybean/common/extensions/context_theme.dart';

import '../../models/create_action_input.dart';
import '../../models/duration_unit.dart';
import 'bloc/create_action_cubit/create_action_cubit.dart';

class CreateActionPage extends StatefulWidget {
  const CreateActionPage({super.key, required this.milestoneId});

  final String milestoneId;

  @override
  State<CreateActionPage> createState() => _CreateActionPageState();
}

class _CreateActionPageState extends State<CreateActionPage> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _titleController;
  late final TextEditingController _durationController;
  late final TextEditingController _descriptionController;
  late final FocusNode _titleFocusNode;
  late final FocusNode _durationFocusNode;
  late final FocusNode _descriptionFocusNode;
  DurationUnit _durationUnit = DurationUnit.day;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _titleController = TextEditingController();
    _durationController = TextEditingController();
    _descriptionController = TextEditingController();
    _titleFocusNode = FocusNode();
    _durationFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
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
      create: (context) => getIt<CreateActionCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add new action'),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                Column(
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
                BlocConsumer<CreateActionCubit, CreateActionState>(
                  listener: (context, state) {
                    switch (state) {
                      case CreateActionInitial():
                        break;
                      case CreateActionLoading():
                        break;
                      case CreateActionSuccess():
                        context.pop(true);
                        break;
                      case CreateActionError():
                        context.showErrorDialog(
                            title: 'Error',
                            message: 'Something went wrong, please try again.',
                            onRetry: () {
                              if (_formKey.currentState!.validate()) {
                                context
                                    .read<CreateActionCubit>()
                                    .createAction(
                                  CreateActionInput(
                                    milestoneId: widget.milestoneId,
                                    name: _titleController.text,
                                    description: _descriptionController.text,
                                    duration:
                                    int.parse(_durationController.text),
                                    durationUnit: _durationUnit,
                                  ),
                                );
                              }

                              Navigator.pop(context);
                            });
                        break;
                    }
                  },
                  builder: (context, state) {
                    switch (state) {
                      case CreateActionInitial():
                      case CreateActionSuccess():
                      case CreateActionError():
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context
                                    .read<CreateActionCubit>()
                                    .createAction(
                                  CreateActionInput(
                                    milestoneId: widget.milestoneId,
                                    name: _titleController.text,
                                    duration:
                                    int.parse(_durationController.text),
                                    description: _descriptionController.text,
                                    durationUnit: _durationUnit,
                                  ),
                                );
                              }
                            },
                            child: const Text('Create'),
                          ),
                        );
                      case CreateActionLoading():
                        return const Align(
                          alignment: Alignment.bottomCenter,
                          child: CircularProgressIndicator(),
                        );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
