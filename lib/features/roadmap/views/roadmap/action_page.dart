import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studybean/common/di/get_it.dart';
import 'package:studybean/common/extensions/context_dialog_extension.dart';
import 'package:studybean/common/extensions/context_theme.dart';
import 'package:studybean/features/roadmap/models/roadmap.dart';

import '../../../../common/widgets/bottom_sheet_header_widget.dart';
import '../../../splash/error_page.dart';
import '../../../splash/loading_page.dart';
import 'bloc/delete_action_cubit/delete_action_cubit.dart';
import 'bloc/delete_action_resource_cubit/delete_action_resource_cubit.dart';
import 'bloc/get_action_cubit/get_action_cubit.dart';
import 'bloc/mark_action_complete_cubit/mark_action_complete_cubit.dart';
import 'widgets/create_action_resource_widget.dart';
import 'widgets/edit_action_resource_widget.dart';
import 'widgets/edit_action_widget.dart';
import 'widgets/action_resource_widget.dart';
import 'package:file_picker/file_picker.dart';

class ActionPage extends StatefulWidget {
  const ActionPage({super.key, required this.actionId});

  final String actionId;

  @override
  State<ActionPage> createState() => _ActionPageState();
}

class _ActionPageState extends State<ActionPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<GetActionCubit>()..getAction(widget.actionId),
        ),
        BlocProvider(
          create: (context) => getIt<DeleteActionResourceCubit>(),
        ),
        BlocProvider(create: (context) => getIt<MarkActionCompleteCubit>()),
        BlocProvider(
          create: (context) => getIt<DeleteActionCubit>(),
        ),
      ],
      child: BlocBuilder<GetActionCubit, GetActionState>(
        builder: (getActionContext, getActionState) {
          switch (getActionState) {
            case GetActionInitial():
            case GetActionLoading():
              return const LoadingPage();
            case GetActionSuccess():
              return BlocConsumer<DeleteActionCubit, DeleteActionState>(
                listener: (deleteActionContext, deleteActionState) {
                  switch (deleteActionState) {
                    case DeleteActionInitial():
                    case DeleteActionLoading():
                      break;
                    case DeleteActionSuccess():
                      context.pop();
                      break;
                    case DeleteActionError():
                      context.showErrorDialog(
                          title: 'Failed to delete action',
                          message:
                              'Something went wrong, please try again later',
                          onRetry: () => deleteActionContext
                              .read<DeleteActionCubit>()
                              .deleteAction(widget.actionId));
                      break;
                  }
                },
                builder: (deleteActionContext, deleteActionState) {
                  if (deleteActionState is DeleteActionLoading) {
                    return const LoadingPage();
                  }

                  return Scaffold(
                    appBar: AppBar(
                      actions: [
                        IconButton(
                          onPressed: () async {
                            final updatedAction = await deleteActionContext
                                .showBottomSheet<MilestoneAction>(
                              builder: (context) => EditActionWidget(
                                action: getActionState.action,
                              ),
                              heightRatio: 1,
                            );

                            if (updatedAction != null &&
                                deleteActionContext.mounted) {
                              deleteActionContext
                                  .read<GetActionCubit>()
                                  .updateAction(updatedAction);
                            }
                          },
                          icon: const Icon(
                            Icons.mode_edit_rounded,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            deleteActionContext.showConfirmDialog(
                              title: 'Delete action',
                              message:
                                  'Are you sure you want to delete this action?',
                              onConfirm: () {
                                deleteActionContext
                                    .read<DeleteActionCubit>()
                                    .deleteAction(widget.actionId);
                              },
                            );
                          },
                          icon: Icon(
                            Icons.delete_rounded,
                            color: deleteActionContext.theme.colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                    body: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getActionState.action.name,
                            style: deleteActionContext
                                .theme.textTheme.headlineLarge
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration: getActionState.action.completed
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          BlocConsumer<MarkActionCompleteCubit,
                              MarkActionCompleteState>(
                            listener: (context, markActionCompleteState) {
                              switch (markActionCompleteState) {
                                case MarkActionCompleteInitial():
                                  break;
                                case MarkActionCompleteLoading():
                                  break;
                                case MarkActionCompleteSuccess():
                                  context.read<GetActionCubit>().updateAction(
                                      markActionCompleteState.action);
                                  break;
                                case MarkActionCompleteFailure():
                                  context.showErrorDialog(
                                      title: 'Failed to mark as complete',
                                      message:
                                          'Something went wrong, please try again.');
                                  break;
                              }
                            },
                            builder: (context, state) {
                              return Row(
                                children: [
                                  Text(
                                    'Estimated time: ${getActionState.action.duration} ${getActionState.action.durationUnit.value}',
                                    style: context.theme.textTheme.bodyMedium
                                        ?.copyWith(color: Colors.grey),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      context
                                          .read<MarkActionCompleteCubit>()
                                          .updateActionComplete(
                                            getActionState.action.id,
                                            !getActionState.action.completed,
                                          );
                                    },
                                    child: Text(
                                      getActionState.action.completed
                                          ? 'Undo mark as complete'
                                          : 'Mark as complete',
                                      style: context.theme.textTheme.bodyMedium
                                          ?.copyWith(
                                              color: context
                                                  .theme.colorScheme.secondary),
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          Text(
                            'Description',
                            style: deleteActionContext
                                .theme.textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            getActionState.action.description ??
                                'No description',
                            style:
                                deleteActionContext.theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          Row(
                            children: [
                              Text(
                                'Resources',
                                style: deleteActionContext
                                    .theme.textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      final resource =
                                          await deleteActionContext
                                              .showBottomSheet<ActionResource>(
                                        heightRatio: 1,
                                        builder: (context) =>
                                            CreateActionResourceWidget(
                                          actionId: getActionState.action.id,
                                        ),
                                      );

                                      if (resource != null &&
                                          deleteActionContext.mounted) {
                                        deleteActionContext
                                            .read<GetActionCubit>()
                                            .addActionResource(resource);
                                      }

                                    },
                                    icon: Row(
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: deleteActionContext
                                              .theme.colorScheme.tertiary,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          'Add resource',
                                          style: deleteActionContext
                                              .theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: deleteActionContext
                                                      .theme
                                                      .colorScheme
                                                      .tertiary),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          BlocConsumer<DeleteActionResourceCubit,
                              DeleteActionResourceState>(
                            listener: (context, state) {
                              switch (state) {
                                case DeleteActionResourceInitial():
                                case DeleteActionResourceLoading():
                                  break;
                                case DeleteActionResourceSuccess():
                                  context
                                      .read<GetActionCubit>()
                                      .removeActionResource(state.id);
                                  break;
                                case DeleteActionResourceError():
                                  context.showErrorDialog(
                                      title: 'Failed to delete resource',
                                      message:
                                          'Something went wrong. Please try again later',
                                      onRetry: () {
                                        context
                                            .read<DeleteActionResourceCubit>()
                                            .deleteResource(state.resourceId);
                                        context.pop();
                                      });
                                  break;
                              }
                            },
                            builder: (context, state) {
                              return Expanded(
                                child: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    height: 16,
                                  ),
                                  itemBuilder: (context, index) {
                                    final resource =
                                        getActionState.action.resource![index];
                                    return ActionResourceWidget(
                                      resource: resource,
                                      onEditResource: () async {
                                        final updatedResource = await context
                                            .showBottomSheet<ActionResource>(
                                          heightRatio: 1,
                                          builder: (context) =>
                                              EditActionResourceWidget(
                                            resource: resource,
                                          ),
                                        );

                                        if (updatedResource != null &&
                                            context.mounted) {
                                          context
                                              .read<GetActionCubit>()
                                              .updateActionResource(
                                                  updatedResource);
                                        }
                                      },
                                      onDeleteResource: () {
                                        context
                                            .read<DeleteActionResourceCubit>()
                                            .deleteResource(resource.id);
                                      },
                                    );
                                  },
                                  itemCount:
                                      getActionState.action.resource?.length ??
                                          0,
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            case GetActionError():
              return ErrorPage(
                onRetry: () => getActionContext
                    .read<GetActionCubit>()
                    .getAction(widget.actionId),
              );
          }
        },
      ),
    );
  }
}
