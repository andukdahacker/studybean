import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studybean/common/di/get_it.dart';
import 'package:studybean/common/extensions/context_dialog_extension.dart';
import 'package:studybean/common/extensions/context_theme.dart';
import 'package:studybean/features/roadmap/models/roadmap.dart';

import '../../../../../common/widgets/bottom_sheet_header_widget.dart';
import '../../../models/edit_action_resource_input.dart';
import '../bloc/edit_local_action_resource_cubit/edit_action_resource_cubit.dart';

class EditActionResourceWidget extends StatefulWidget {
  const EditActionResourceWidget({super.key, required this.resource});

  final ActionResource resource;

  @override
  State<EditActionResourceWidget> createState() =>
      _EditActionResourceWidgetState();
}

class _EditActionResourceWidgetState extends State<EditActionResourceWidget> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _titleController;
  late final TextEditingController _linkToResourceController;
  late final TextEditingController _descriptionController;
  late final FocusNode _titleFocusNode;
  late final FocusNode _linkToResourceFocusNode;
  late final FocusNode _descriptionFocusNode;

  final GlobalKey _descriptionKey = GlobalKey();

  // late bool isValidLink = widget.resource.url.isNotEmpty;
  // bool isPasting = false;
  // FilePickerResult? filePickerResult;
  // bool isChangingResource = false;

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
      create: (context) => getIt<EditActionResourceCubit>(),
      child: BlocConsumer<EditActionResourceCubit, EditActionResourceState>(
        listener: (context, state) {
          switch (state) {
            case EditActionResourceInitial():
            case EditActionResourceLoading():
              break;
            case EditActionResourceSuccess():
              context.pop(state.resource);
              break;
            case EditActionResourceError():
              context.showErrorDialog(
                title: 'Error',
                message: 'Failed to edit resource',
                onRetry: () {
                  context.read<EditActionResourceCubit>().editResource(
                        EditActionResourceInput(
                          id: widget.resource.id,
                          title: _titleController.text,
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
          return Column(
            children: [
              BottomSheetHeaderWidget(
                action: GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<EditActionResourceCubit>().editResource(
                        EditActionResourceInput(
                          id: widget.resource.id,
                          title: _titleController.text,
                          description: _descriptionController.text,
                        ),
                      );
                    }
                  },
                  child: (state is EditActionResourceLoading)
                      ? const CircularProgressIndicator()
                      : Text(
                          'Save',
                          style: context.theme.textTheme.bodyLarge?.copyWith(
                              color: context.theme.colorScheme.primary,
                              fontWeight: FontWeight.bold),
                        ),
                ),
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
                            onEditingComplete: () {
                              _descriptionFocusNode.unfocus();
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          // Text(
                          //   'Resource',
                          //   style: context.theme.textTheme.bodyMedium,
                          // ),
                          // const SizedBox(
                          //   height: 8,
                          // ),
                          // if (!isChangingResource)
                          //   Row(
                          //     children: [
                          //       Expanded(
                          //         child: Text(
                          //           widget.resource.url,
                          //           style: context.theme.textTheme.bodyMedium
                          //               ?.copyWith(
                          //             color: context.theme.colorScheme.primary,
                          //             fontWeight: FontWeight.bold,
                          //           ),
                          //         ),
                          //       ),
                          //       const SizedBox(
                          //         width: 16,
                          //       ),
                          //       GestureDetector(
                          //         onTap: () {
                          //           setState(() {
                          //             isChangingResource = true;
                          //           });
                          //         },
                          //         child: Icon(
                          //           Icons.change_circle_rounded,
                          //           color: context.theme.colorScheme.primary,
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // if (!isPasting &&
                          //     filePickerResult == null &&
                          //     isChangingResource)
                          //   Wrap(
                          //     spacing: 8,
                          //     children: ResourceType.values.map((type) {
                          //       Widget avatar = const SizedBox.shrink();
                          //       VoidCallback? onPressed;
                          //
                          //       switch (type) {
                          //         case ResourceType.pdf:
                          //           avatar = const Icon(
                          //               Icons.picture_as_pdf_rounded);
                          //           onPressed = () async {
                          //             final result =
                          //                 await FilePicker.platform.pickFiles(
                          //               type: FileType.custom,
                          //               allowedExtensions: ['pdf'],
                          //               allowMultiple: false,
                          //             );
                          //
                          //             if (result != null) {
                          //               setState(() {
                          //                 filePickerResult = result;
                          //               });
                          //             }
                          //           };
                          //           break;
                          //         case ResourceType.websiteLink:
                          //           avatar = const Icon(Icons.web_rounded);
                          //           onPressed = () {
                          //             setState(() {
                          //               isPasting = true;
                          //             });
                          //           };
                          //           break;
                          //         case ResourceType.youtubeLink:
                          //           avatar = const Icon(
                          //               Icons.youtube_searched_for_rounded);
                          //           onPressed = () {
                          //             setState(() {
                          //               isPasting = true;
                          //             });
                          //           };
                          //           break;
                          //         case ResourceType.image:
                          //           avatar = const Icon(Icons.image_rounded);
                          //           onPressed = () async {
                          //             final result =
                          //                 await FilePicker.platform.pickFiles(
                          //               type: FileType.image,
                          //               allowMultiple: false,
                          //             );
                          //
                          //             if (result != null) {
                          //               setState(() {
                          //                 filePickerResult = result;
                          //               });
                          //             }
                          //           };
                          //           break;
                          //       }
                          //
                          //       return ActionChip(
                          //         label: Text(type.label),
                          //         onPressed: onPressed,
                          //         avatar: avatar,
                          //       );
                          //     }).toList(),
                          //   ),
                          // if (filePickerResult != null)
                          //   Row(
                          //     children: [
                          //       Expanded(
                          //         child: Text(
                          //           filePickerResult!.files.single.name,
                          //           style: context.theme.textTheme.bodyMedium
                          //               ?.copyWith(
                          //             color: context.theme.colorScheme.primary,
                          //             fontWeight: FontWeight.bold,
                          //           ),
                          //         ),
                          //       ),
                          //       const SizedBox(
                          //         width: 16,
                          //       ),
                          //       GestureDetector(
                          //         onTap: () {
                          //           setState(() {
                          //             filePickerResult = null;
                          //           });
                          //         },
                          //         child: Icon(
                          //           Icons.remove_circle_outline,
                          //           color: context.theme.colorScheme.error,
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // if (isPasting)
                          //   Column(
                          //     children: [
                          //       Row(
                          //         children: [
                          //           Expanded(
                          //             child: TextFormField(
                          //               validator: (value) {
                          //                 if (value == null || value.isEmpty) {
                          //                   return 'Please enter a link';
                          //                 }
                          //
                          //                 if (!AnyLinkPreview.isValidLink(
                          //                     value)) {
                          //                   return 'Please enter a valid link';
                          //                 }
                          //
                          //                 return null;
                          //               },
                          //               onChanged: (value) {
                          //                 final valid =
                          //                     AnyLinkPreview.isValidLink(value);
                          //                 setState(() {
                          //                   isValidLink = valid;
                          //                 });
                          //               },
                          //               controller: _linkToResourceController,
                          //             ),
                          //           ),
                          //           const SizedBox(
                          //             width: 8,
                          //           ),
                          //           GestureDetector(
                          //             onTap: () {
                          //               setState(() {
                          //                 isPasting = false;
                          //                 _linkToResourceController.text = '';
                          //               });
                          //             },
                          //             child: Icon(
                          //               Icons.remove_circle_outline_rounded,
                          //               color: context.theme.colorScheme.error,
                          //             ),
                          //           )
                          //         ],
                          //       ),
                          //     ],
                          //   )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
