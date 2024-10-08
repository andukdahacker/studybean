import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studybean/common/di/get_it.dart';
import 'package:studybean/common/extensions/context_dialog_extension.dart';
import 'package:studybean/common/extensions/context_theme.dart';
import 'package:studybean/features/roadmap/models/edit_local_action_resource_input.dart';
import 'package:studybean/features/roadmap/models/roadmap.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/edit_local_action_resource_cubit/edit_local_action_resource_cubit.dart';

import '../../../../../common/widgets/bottom_sheet_header_widget.dart';

class EditLocalActionResourceWidget extends StatefulWidget {
  const EditLocalActionResourceWidget({super.key, required this.resource});

  final ActionResource resource;

  @override
  State<EditLocalActionResourceWidget> createState() =>
      _EditLocalActionResourceWidgetState();
}

class _EditLocalActionResourceWidgetState
    extends State<EditLocalActionResourceWidget> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _titleController;
  late final TextEditingController _linkToResourceController;
  late final TextEditingController _descriptionController;
  late final FocusNode _titleFocusNode;
  late final FocusNode _linkToResourceFocusNode;
  late final FocusNode _descriptionFocusNode;

  final GlobalKey _descriptionKey = GlobalKey();

  late bool isValidLink = widget.resource.url.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _titleController = TextEditingController()..text = widget.resource.title;
    _linkToResourceController = TextEditingController()
      ..text = widget.resource.url;
    _descriptionController = TextEditingController()
      ..text = widget.resource.description ?? '';
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
      create: (context) => getIt<EditLocalActionResourceCubit>(),
      child: Column(
        children: [
          BlocConsumer<EditLocalActionResourceCubit,
              EditLocalActionResourceState>(
            listener: (context, state) {
              switch (state) {
                case EditLocalActionResourceInitial():
                case EditLocalActionResourceLoading():
                  break;
                case EditLocalActionResourceSuccess():
                  context.pop(state.resource);
                  break;
                case EditLocalActionResourceError():
                  context.showErrorDialog(
                    title: 'Error',
                    message: 'Failed to edit resource',
                    onRetry: () {
                      context
                          .read<EditLocalActionResourceCubit>()
                          .editLocalActionResource(
                            EditLocalActionResourceInput(
                              id: widget.resource.id,
                              title: _titleController.text,
                              url: _linkToResourceController.text,
                              description: _descriptionController.text,
                            ),
                          );
                      context.pop();
                    },
                  );
                  break;
              }
            },
            builder: (context, state) {
              return BottomSheetHeaderWidget(
                action: GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      context
                          .read<EditLocalActionResourceCubit>()
                          .editLocalActionResource(EditLocalActionResourceInput(
                              id: widget.resource.id,
                              title: _titleController.text,
                              url: _linkToResourceController.text,
                              description: _descriptionController.text));
                    }
                  },
                  child: (state is EditLocalActionResourceLoading)
                      ? const CircularProgressIndicator()
                      : Text(
                          'Save',
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
