import 'package:any_link_preview/any_link_preview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studybean/common/di/get_it.dart';
import 'package:studybean/common/extensions/context_dialog_extension.dart';
import 'package:studybean/common/extensions/context_theme.dart';

import '../../../../../common/widgets/bottom_sheet_header_widget.dart';
import '../../../models/create_action_resource_input.dart';
import '../../../models/roadmap.dart';
import '../bloc/create_action_resource_cubit/create_action_resource_cubit.dart';

class CreateActionResourceWidget extends StatefulWidget {
  const CreateActionResourceWidget({super.key, required this.actionId});

  final String actionId;

  @override
  State<CreateActionResourceWidget> createState() =>
      _CreateActionResourceWidgetState();
}

class _CreateActionResourceWidgetState
    extends State<CreateActionResourceWidget> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _linkController;
  late final FocusNode _titleFocusNode;
  late final FocusNode _linkToResourceFocusNode;
  late final FocusNode _descriptionFocusNode;

  final GlobalKey _descriptionKey = GlobalKey();

  final youtubeRegex =
      RegExp(r'^.*(youtu\.be/|v/|u/\w/|embed/|watch\?v=|&v=|\?v=)([^#&?]*).*');

  bool isPasting = false;
  bool isValidLink = false;

  ResourceType? _currentResourceType;

  FilePickerResult? filePickerResult;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _linkController = TextEditingController();
    _titleFocusNode = FocusNode();
    _linkToResourceFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _linkController.dispose();
    _titleFocusNode.dispose();
    _linkToResourceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _createResource(BuildContext context) {
    switch (_currentResourceType) {
      case null:
        return;
      case ResourceType.pdf:
        if (filePickerResult != null) {
          context.read<CreateActionResourceCubit>().createResourceWithFile(
                CreateActionResourceInput(
                    title: _titleController.text,
                    description: _descriptionController.text,
                    actionId: widget.actionId,
                    resourceType: _currentResourceType!),
                filePickerResult!,
              );
        }
        break;
      case ResourceType.image:
        if (filePickerResult != null) {
          context.read<CreateActionResourceCubit>().createResourceWithFile(
                CreateActionResourceInput(
                    title: _titleController.text,
                    description: _descriptionController.text,
                    actionId: widget.actionId,
                    resourceType: _currentResourceType!),
                filePickerResult!,
              );
        }
        break;
      case ResourceType.websiteLink:
        context.read<CreateActionResourceCubit>().createResource(
              CreateActionResourceInput(
                  title: _titleController.text,
                  url: _linkController.text,
                  description: _descriptionController.text,
                  actionId: widget.actionId,
                  resourceType: _currentResourceType!),
            );
        break;
      case ResourceType.youtubeLink:
        final youtubeLink = _linkController.text;
        final match = youtubeRegex.firstMatch(youtubeLink);
        final embedded = 'https://youtube.com/embed/${match!.group(2)}?autoplay=0';
        context.read<CreateActionResourceCubit>().createResource(
                  CreateActionResourceInput(
                      title: _titleController.text,
                      url: embedded,
                      description: _descriptionController.text,
                      actionId: widget.actionId,
                      resourceType: _currentResourceType!),
                );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CreateActionResourceCubit>(),
      child: Column(
        children: [
          BlocConsumer<CreateActionResourceCubit, CreateActionResourceState>(
            listener: (context, state) {
              switch (state) {
                case CreateActionResourceInitial():
                case CreateActionResourceLoading():
                  break;
                case CreateActionResourceSuccess():
                  context.pop(state.resource);
                  break;
                case CreateActionResourceError():
                  context.showErrorDialog(
                      title: 'Failed to add resource',
                      message: 'Something went wrong. Please try again later',
                      onRetry: () {
                        _createResource(context);
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
                      _createResource(context);
                    }
                  },
                  child: (state is CreateActionResourceLoading)
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
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Resource',
                        style: context.theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      if (!isPasting && filePickerResult == null)
                        Wrap(
                          spacing: 8,
                          children: ResourceType.values.map((type) {
                            Widget avatar = const SizedBox.shrink();
                            VoidCallback? onPressed;

                            switch (type) {
                              case ResourceType.pdf:
                                avatar =
                                    const Icon(Icons.picture_as_pdf_rounded);
                                onPressed = () async {
                                  final result =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['pdf'],
                                    allowMultiple: false,
                                  );

                                  if (result != null) {
                                    setState(() {
                                      filePickerResult = result;
                                      _currentResourceType = type;
                                    });
                                  }
                                };
                                break;
                              case ResourceType.websiteLink:
                                avatar = const Icon(Icons.web_rounded);
                                onPressed = () {
                                  setState(() {
                                    isPasting = true;
                                    _currentResourceType = type;
                                  });
                                };
                                break;
                              case ResourceType.youtubeLink:
                                avatar = const Icon(
                                    Icons.youtube_searched_for_rounded);
                                onPressed = () {
                                  setState(() {
                                    isPasting = true;
                                    _currentResourceType = type;
                                  });
                                };
                                break;
                              case ResourceType.image:
                                avatar = const Icon(Icons.image_rounded);
                                onPressed = () async {
                                  final result =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.image,
                                    allowMultiple: false,
                                  );

                                  if (result != null) {
                                    setState(() {
                                      filePickerResult = result;
                                      _currentResourceType = type;
                                    });
                                  }
                                };
                                break;
                            }

                            return ActionChip(
                              label: Text(type.label),
                              onPressed: onPressed,
                              avatar: avatar,
                            );
                          }).toList(),
                        ),
                      if (filePickerResult != null)
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                filePickerResult!.files.single.name,
                                style: context.theme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: context.theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  filePickerResult = null;
                                  _currentResourceType = null;
                                });
                              },
                              child: Icon(
                                Icons.remove_circle_outline,
                                color: context.theme.colorScheme.error,
                              ),
                            )
                          ],
                        ),
                      if (isPasting)
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a link';
                                      }

                                      if (_currentResourceType ==
                                          ResourceType.youtubeLink) {
                                        final match =
                                            youtubeRegex.firstMatch(value);

                                        if (match == null) {
                                          return 'Invalid youtube link';
                                        }

                                        if (match.group(2) == null) {
                                          return 'Invalid youtube link';
                                        }

                                        if (match.group(2) != null &&
                                            match.group(2)!.length != 11) {
                                          return 'Invalid youtube link';
                                        }
                                      }

                                      if (!AnyLinkPreview.isValidLink(value)) {
                                        return 'Please enter a valid link';
                                      }

                                      return null;
                                    },
                                    onChanged: (value) {
                                      final valid =
                                          AnyLinkPreview.isValidLink(value);
                                      setState(() {
                                        isValidLink = valid;
                                      });
                                    },
                                    controller: _linkController,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isPasting = false;
                                      _linkController.text = '';
                                      _currentResourceType = null;
                                    });
                                  },
                                  child: Icon(
                                    Icons.remove_circle_outline_rounded,
                                    color: context.theme.colorScheme.error,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            if (isValidLink)
                              AnyLinkPreview(
                                link: _linkController.text,
                              )
                            else
                              Text(
                                'Link is empty or invalid',
                                style: context.theme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: Colors.red,
                                ),
                              ),
                          ],
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
