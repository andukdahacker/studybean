import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studybean/common/di/get_it.dart';
import 'package:studybean/common/extensions/context_dialog_extension.dart';
import 'package:studybean/common/extensions/context_theme.dart';
import 'package:studybean/features/roadmap/models/create_local_action_resource_input.dart';

import '../../../../../common/widgets/bottom_sheet_header_widget.dart';
import '../bloc/create_action_resource_cubit/create_local_action_resource_cubit.dart';

class CreateLocalActionResourceWidget extends StatefulWidget {
  const CreateLocalActionResourceWidget({super.key, required this.actionId});

  final String actionId;

  @override
  State<CreateLocalActionResourceWidget> createState() =>
      _CreateLocalActionResourceWidgetState();
}

class _CreateLocalActionResourceWidgetState
    extends State<CreateLocalActionResourceWidget> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _titleController;
  late final TextEditingController _linkToResourceController;
  late final TextEditingController _descriptionController;
  late final FocusNode _titleFocusNode;
  late final FocusNode _linkToResourceFocusNode;
  late final FocusNode _descriptionFocusNode;

  final GlobalKey _descriptionKey = GlobalKey();

  bool isValidLink = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _titleController = TextEditingController();
    _linkToResourceController = TextEditingController();
    _descriptionController = TextEditingController();
    _titleFocusNode = FocusNode();
    _linkToResourceFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _linkToResourceController.dispose();
    _descriptionController.dispose();
    _titleFocusNode.dispose();
    _linkToResourceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CreateLocalActionResourceCubit>(),
      child: Column(
        children: [
          BlocConsumer<CreateLocalActionResourceCubit,
              CreateLocalActionResourceState>(
            listener: (context, state) {
              switch (state) {
                case CreateLocalActionResourceInitial():
                case CreateLocalActionResourceLoading():
                  break;
                case CreateLocalActionResourceSuccess():
                  context.pop(state.resource);
                  break;
                case CreateLocalActionResourceError():
                  context.showErrorDialog(
                      title: 'Failed to add resource',
                      message: 'Something went wrong. Please try again later',
                      onRetry: () {
                        context
                            .read<CreateLocalActionResourceCubit>()
                            .createResource(
                              CreateLocalActionResourceInput(
                                title: _titleController.text,
                                url: _linkToResourceController.text,
                                description: _descriptionController.text,
                                actionId: widget.actionId,
                              ),
                            );
                        context.pop();
                      });
                  break;
              }
            },
            builder: (context, state) {
              return BottomSheetHeaderWidget(
                action: GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      final input = CreateLocalActionResourceInput(
                        title: _titleController.text,
                        url: _linkToResourceController.text,
                        description: _descriptionController.text,
                        actionId: widget.actionId,
                      );

                      context
                          .read<CreateLocalActionResourceCubit>()
                          .createResource(input);
                    }
                  },
                  child: (state is CreateLocalActionResourceLoading)
                      ? const CircularProgressIndicator()
                      : Text(
                          'Create',
                          style: context.theme.textTheme.bodyLarge?.copyWith(
                              color: context.theme.colorScheme.primary,
                              fontWeight: FontWeight.bold),
                        ),
                ),
              );
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Title',
                        style: context.theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _titleController,
                        focusNode: _titleFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                        onEditingComplete: () {
                          _titleFocusNode.unfocus();
                          FocusScope.of(context)
                              .requestFocus(_linkToResourceFocusNode);
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Link to resource',
                        style: context.theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a link';
                          }

                          if (!AnyLinkPreview.isValidLink(value)) {
                            return 'Please enter a valid link';
                          }

                          return null;
                        },
                        controller: _linkToResourceController,
                        focusNode: _linkToResourceFocusNode,
                        onChanged: (value) {
                          final valid = AnyLinkPreview.isValidLink(value);
                          setState(() {
                            isValidLink = valid;
                          });
                        },
                        onEditingComplete: () {
                          _linkToResourceFocusNode.unfocus();
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                          Scrollable.ensureVisible(
                              _descriptionKey.currentContext!);
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      if (isValidLink)
                        AnyLinkPreview(
                          link: _linkToResourceController.text,
                        )
                      else
                        Text(
                          'Link is empty or invalid',
                          style: context.theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.red,
                          ),
                        ),
                      const SizedBox(
                        height: 32,
                      ),
                      Text(
                        'Description',
                        style: context.theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        key: _descriptionKey,
                        controller: _descriptionController,
                        focusNode: _descriptionFocusNode,
                        maxLines: 5,
                        onEditingComplete: () {
                          _descriptionFocusNode.unfocus();
                        },
                      ),
                      const SizedBox(
                        height: 480,
                      )
                    ],
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
