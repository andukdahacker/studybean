import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studybean/common/di/get_it.dart';
import 'package:studybean/common/extensions/context_dialog_extension.dart';
import 'package:studybean/common/extensions/context_theme.dart';
import 'package:studybean/features/roadmap/models/roadmap.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/delete_action_resource_cubit/delete_local_action_resource_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/get_action_cubit/get_local_action_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/mark_action_complete_cubit/mark_local_action_complete_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/widgets/edit_local_action_resource_widget.dart';
import 'package:studybean/features/roadmap/views/roadmap/widgets/edit_local_action_widget.dart';

import '../../../splash/error_page.dart';
import '../../../splash/loading_page.dart';
import 'bloc/delete_action_cubit/delete_local_action_cubit.dart';
import 'widgets/create_local_action_resource_widget.dart';
import 'widgets/action_resource_widget.dart';

class ActionLocalPage extends StatefulWidget {
  const ActionLocalPage({super.key, required this.actionId});

  final String actionId;

  @override
  State<ActionLocalPage> createState() => _ActionLocalPageState();
}

class _ActionLocalPageState extends State<ActionLocalPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<GetLocalActionCubit>()..getAction(widget.actionId),
        ),
        BlocProvider(
          create: (context) => getIt<DeleteLocalActionResourceCubit>(),
        ),
        BlocProvider(
            create: (context) => getIt<MarkLocalActionCompleteCubit>()),
        BlocProvider(
          create: (context) => getIt<DeleteLocalActionCubit>(),
        ),
      ],
      child: BlocBuilder<GetLocalActionCubit, GetLocalActionState>(
        builder: (getLocalActionContext, getLocalActionState) {
          switch (getLocalActionState) {
            case GetLocalActionInitial():
            case GetLocalActionLoading():
              return const LoadingPage();
            case GetLocalActionSuccess():
              return BlocConsumer<DeleteLocalActionCubit,
                  DeleteLocalActionState>(
                listener: (deleteLocalActionContext, deleteLocalActionState) {
                  switch (deleteLocalActionState) {
                    case DeleteLocalActionInitial():
                    case DeleteLocalActionLoading():
                      break;
                    case DeleteLocalActionSuccess():
                      context.pop();
                      break;
                    case DeleteLocalActionError():
                      context.showErrorDialog(
                          title: 'Failed to delete action',
                          message:
                              'Something went wrong, please try again later',
                          onRetry: () => deleteLocalActionContext
                              .read<DeleteLocalActionCubit>()
                              .deleteAction(widget.actionId));
                      break;
                  }
                },
                builder: (deleteLocalActionContext, deleteLocalActionState) {
                  if (deleteLocalActionState is DeleteLocalActionLoading) {
                    return const LoadingPage();
                  }

                  return Scaffold(
                    appBar: AppBar(
                      actions: [
                        IconButton(
                          onPressed: () async {
                            final updatedAction = await deleteLocalActionContext
                                .showBottomSheet<MilestoneAction>(
                              builder: (context) => EditLocalActionWidget(
                                action: getLocalActionState.action,
                              ),
                              heightRatio: 1,
                            );

                            if (updatedAction != null &&
                                deleteLocalActionContext.mounted) {
                              deleteLocalActionContext
                                  .read<GetLocalActionCubit>()
                                  .updateAction(updatedAction);
                            }
                          },
                          icon: Icon(
                            Icons.mode_edit_rounded,
                            color: deleteLocalActionContext
                                .theme.colorScheme.secondary,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            deleteLocalActionContext.showConfirmDialog(
                              title: 'Delete action',
                              message:
                                  'Are you sure you want to delete this action?',
                              onConfirm: () {
                                deleteLocalActionContext
                                    .read<DeleteLocalActionCubit>()
                                    .deleteAction(widget.actionId);
                              },
                            );
                          },
                          icon: Icon(
                            Icons.delete_rounded,
                            color: deleteLocalActionContext
                                .theme.colorScheme.error,
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
                            getLocalActionState.action.name,
                            style: deleteLocalActionContext
                                .theme.textTheme.headlineLarge
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration: getLocalActionState.action.completed
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          BlocConsumer<MarkLocalActionCompleteCubit,
                              MarkLocalActionCompleteState>(
                            listener: (context, markLocalActionCompleteState) {
                              switch (markLocalActionCompleteState) {
                                case MarkLocalActionCompleteInitial():
                                  break;
                                case MarkLocalActionCompleteLoading():
                                  break;
                                case MarkLocalActionCompleteSuccess():
                                  context
                                      .read<GetLocalActionCubit>()
                                      .updateAction(
                                          markLocalActionCompleteState.action);
                                  break;
                                case MarkLocalActionCompleteFailure():
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
                                    'Estimated time: ${getLocalActionState.action.duration} ${getLocalActionState.action.durationUnit.value}',
                                    style: context.theme.textTheme.bodyMedium
                                        ?.copyWith(color: Colors.grey),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      context
                                          .read<MarkLocalActionCompleteCubit>()
                                          .updateActionComplete(
                                            getLocalActionState.action.id,
                                            !getLocalActionState
                                                .action.completed,
                                          );
                                    },
                                    child: Text(
                                      getLocalActionState.action.completed
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
                            style: deleteLocalActionContext
                                .theme.textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            getLocalActionState.action.description ??
                                'No description',
                            style: deleteLocalActionContext
                                .theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          Row(
                            children: [
                              Text(
                                'Resources',
                                style: deleteLocalActionContext
                                    .theme.textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      final resource =
                                          await deleteLocalActionContext
                                              .showBottomSheet<ActionResource>(
                                        heightRatio: 1,
                                        builder: (context) =>
                                            CreateLocalActionResourceWidget(
                                          actionId:
                                              getLocalActionState.action.id,
                                        ),
                                      );

                                      if (resource != null &&
                                          deleteLocalActionContext.mounted) {
                                        deleteLocalActionContext
                                            .read<GetLocalActionCubit>()
                                            .addActionResource(resource);
                                      }
                                    },
                                    icon: Row(
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: deleteLocalActionContext
                                              .theme.colorScheme.tertiary,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          'Add resource',
                                          style: deleteLocalActionContext
                                              .theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      deleteLocalActionContext
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
                          BlocConsumer<DeleteLocalActionResourceCubit,
                              DeleteLocalActionResourceState>(
                            listener: (context, state) {
                              switch (state) {
                                case DeleteLocalActionResourceInitial():
                                case DeleteLocalActionResourceLoading():
                                  break;
                                case DeleteLocalActionResourceSuccess():
                                  context
                                      .read<GetLocalActionCubit>()
                                      .removeActionResource(state.resourceId);
                                  break;
                                case DeleteLocalActionResourceError():
                                  context.showErrorDialog(
                                      title: 'Failed to delete resource',
                                      message:
                                          'Something went wrong. Please try again later',
                                      onRetry: () {
                                        context
                                            .read<
                                                DeleteLocalActionResourceCubit>()
                                            .deleteResource(widget.actionId);
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
                                    final resource = getLocalActionState
                                        .action.resource![index];
                                    return ActionResourceWidget(
                                      resource: resource,
                                      onEditResource: () async {
                                        final updatedResource = await context
                                            .showBottomSheet<ActionResource>(
                                          heightRatio: 1,
                                          builder: (context) =>
                                              EditLocalActionResourceWidget(
                                            resource: resource,
                                          ),
                                        );

                                        if (updatedResource != null &&
                                            context.mounted) {
                                          context
                                              .read<GetLocalActionCubit>()
                                              .updateActionResource(
                                                  updatedResource);
                                        }
                                      },
                                      onDeleteResource: () {
                                        context
                                            .read<
                                                DeleteLocalActionResourceCubit>()
                                            .deleteResource(resource.id);
                                      },
                                    );
                                  },
                                  itemCount: getLocalActionState
                                          .action.resource?.length ??
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
            case GetLocalActionError():
              return ErrorPage(
                onRetry: () => getLocalActionContext
                    .read<GetLocalActionCubit>()
                    .getAction(widget.actionId),
              );
          }
        },
      ),
    );
  }
}
