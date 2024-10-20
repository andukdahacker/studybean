import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studybean/common/di/get_it.dart';
import 'package:studybean/common/extensions/context_dialog_extension.dart';
import 'package:studybean/common/extensions/context_theme.dart';
import 'package:studybean/features/roadmap/models/roadmap.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/delete_milestone_cubit/delete_local_milestone_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/get_milestone_cubit/get_local_milestone_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/mark_action_complete_cubit/mark_local_action_complete_cubit.dart';
import 'package:studybean/features/splash/error_page.dart';
import 'package:studybean/features/splash/loading_page.dart';

import 'widgets/action_widget.dart';
import 'widgets/edit_local_milestone_widget.dart';

class MilestoneLocalPage extends StatefulWidget {
  const MilestoneLocalPage({super.key, required this.milestoneId});

  final String milestoneId;

  @override
  State<MilestoneLocalPage> createState() => _MilestoneLocalPageState();
}

class _MilestoneLocalPageState extends State<MilestoneLocalPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<GetLocalMilestoneCubit>()..getMilestone(widget.milestoneId),
        ),
        BlocProvider(
          create: (context) => getIt<DeleteLocalMilestoneCubit>(),
        ),
      ],
      child: BlocBuilder<GetLocalMilestoneCubit, GetLocalMilestoneState>(
        builder: (context, getLocalMilestoneState) {
          switch (getLocalMilestoneState) {
            case GetLocalMilestoneInitial():
            case GetLocalMilestoneLoading():
              return const LoadingPage();
            case GetLocalMilestoneSuccess():
              return BlocConsumer<DeleteLocalMilestoneCubit,
                  DeleteLocalMilestoneState>(
                listener: (context, state) {
                  switch (state) {
                    case DeleteLocalMilestoneInitial():
                    case DeleteLocalMilestoneLoading():
                      break;
                    case DeleteLocalMilestoneSuccess():
                      context.pop(true);
                      break;
                    case DeleteLocalMilestoneError():
                      context.showErrorDialog(
                        title: 'Failed to delete milestone',
                        message: 'Something went wrong, please try again later',
                        onRetry: () => context
                            .read<DeleteLocalMilestoneCubit>()
                            .deleteMilestone(widget.milestoneId),
                      );
                      break;
                  }
                },
                builder: (context, state) {
                  if (state is DeleteLocalMilestoneSuccess) {
                    return const LoadingPage();
                  }
                  return Scaffold(
                    appBar: AppBar(
                      actions: [
                        IconButton(
                          onPressed: () async {
                            final shouldReload = await context.push<bool>(
                                '/local/home/roadmap/${getLocalMilestoneState.milestone.roadmapId}/milestone/${getLocalMilestoneState.milestone.id}/createAction');
                            if (context.mounted && (shouldReload ?? false)) {
                              context
                                  .read<GetLocalMilestoneCubit>()
                                  .getMilestone(widget.milestoneId);
                            }
                          },
                          icon: const Icon(Icons.add),
                        ),
                        IconButton(
                          onPressed: () async {
                            final updatedMilestone =
                                await context.showBottomSheet<Milestone>(
                              heightRatio: 1,
                              builder: (context) => EditLocalMilestoneWidget(
                                milestone: getLocalMilestoneState.milestone,
                              ),
                            );

                            if (context.mounted && updatedMilestone != null) {
                              context
                                  .read<GetLocalMilestoneCubit>()
                                  .updateMilestone(updatedMilestone);
                            }
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () async {
                            context.showConfirmDialog(
                              title: 'Delete milestone',
                              message:
                                  'Are you sure you want to delete this milestone?',
                              onConfirm: () => context
                                  .read<DeleteLocalMilestoneCubit>()
                                  .deleteMilestone(widget.milestoneId),
                            );
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                    body: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getLocalMilestoneState.milestone.name,
                            style: context.theme.textTheme.headlineLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Estimated time: ${getLocalMilestoneState.milestone.durationText}',
                            style: context.theme.textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          Expanded(
                            child: ListView.separated(
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 16,
                                );
                              },
                              itemBuilder: (context, index) {
                                if (index ==
                                    getLocalMilestoneState
                                        .milestone.actions?.length) {
                                  return GestureDetector(
                                    onTap: () async {
                                      final shouldReload = await context.push<
                                              bool>(
                                          '/local/home/roadmap/${getLocalMilestoneState.milestone.roadmapId}/milestone/${getLocalMilestoneState.milestone.id}/createAction');
                                      if (context.mounted &&
                                          (shouldReload ?? false)) {
                                        context
                                            .read<GetLocalMilestoneCubit>()
                                            .getMilestone(widget.milestoneId);
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: context
                                              .theme.colorScheme.tertiary,
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Text(
                                          'New action',
                                          style: context
                                              .theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: context.theme
                                                      .colorScheme.tertiary),
                                        )
                                      ],
                                    ),
                                  );
                                }
                                final action = getLocalMilestoneState
                                    .milestone.actions![index];
                                return MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (context) =>
                                          getIt<MarkLocalActionCompleteCubit>(),
                                    ),
                                  ],
                                  child: BlocConsumer<
                                      MarkLocalActionCompleteCubit,
                                      MarkLocalActionCompleteState>(
                                    listener: (markLocalActionCompleteContext,
                                        markLocalActionCompleteState) {
                                      switch (markLocalActionCompleteState) {
                                        case MarkLocalActionCompleteInitial():
                                        case MarkLocalActionCompleteLoading():
                                          break;
                                        case MarkLocalActionCompleteSuccess():
                                          markLocalActionCompleteContext
                                              .read<GetLocalMilestoneCubit>()
                                              .updateMilestoneAction(
                                                  markLocalActionCompleteState
                                                      .action);
                                          break;
                                        case MarkLocalActionCompleteFailure():
                                          markLocalActionCompleteContext
                                              .showErrorDialog(
                                            title:
                                                'Failed to mark action as complete',
                                            message:
                                                'Something went wrong, please try again.',
                                            onRetry: () =>
                                                markLocalActionCompleteContext
                                                    .read<
                                                        MarkLocalActionCompleteCubit>()
                                                    .updateActionComplete(
                                                      action.id,
                                                      !action.completed,
                                                    ),
                                          );
                                          break;
                                      }
                                    },
                                    builder: (markLocalActionCompleteContext,
                                            markLocalActionCompleteState) =>
                                        ActionWidget(
                                      action: action,
                                      onTap: () async {
                                        await context.pushNamed(
                                            'localActionDetail',
                                            pathParameters: {
                                              'actionId': action.id,
                                              'milestoneId':
                                                  getLocalMilestoneState
                                                      .milestone.id,
                                              'roadmapId':
                                                  getLocalMilestoneState
                                                      .milestone.roadmapId
                                            });

                                        if (context.mounted) {
                                          context
                                              .read<GetLocalMilestoneCubit>()
                                              .getMilestone(widget.milestoneId);
                                        }
                                      },
                                      onLongPress: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) => Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    context.pop();
                                                  },
                                                  style: context.theme
                                                      .elevatedButtonTheme.style
                                                      ?.copyWith(
                                                    backgroundColor:
                                                        WidgetStateProperty
                                                            .all(
                                                      context.theme.colorScheme
                                                          .secondary,
                                                    ),
                                                  ),
                                                  child: const Text('Edit'),
                                                ),
                                                const SizedBox(
                                                  height: 16,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    context.showConfirmDialog(
                                                      title: 'Delete action',
                                                      message:
                                                          'Are you sure you want to delete this action?',
                                                      onConfirm: () {
                                                        // TODO: delete action
                                                      },
                                                    );
                                                  },
                                                  style: context.theme
                                                      .elevatedButtonTheme.style
                                                      ?.copyWith(
                                                    backgroundColor:
                                                        WidgetStateProperty
                                                            .all(
                                                      context.theme.colorScheme
                                                          .error,
                                                    ),
                                                  ),
                                                  child: const Text('Delete'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      onMarkAsComplete: () {
                                        markLocalActionCompleteContext
                                            .read<
                                                MarkLocalActionCompleteCubit>()
                                            .updateActionComplete(
                                              action.id,
                                              !action.completed,
                                            );
                                      },
                                    ),
                                  ),
                                );
                              },
                              itemCount: (getLocalMilestoneState
                                          .milestone.actions?.length ??
                                      0) +
                                  1,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            case GetLocalMilestoneError():
              return ErrorPage(
                onRetry: () => context
                    .read<GetLocalMilestoneCubit>()
                    .getMilestone(widget.milestoneId),
              );
          }
        },
      ),
    );
  }
}
