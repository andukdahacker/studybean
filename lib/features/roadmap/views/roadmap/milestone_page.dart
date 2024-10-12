import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studybean/common/extensions/context_dialog_extension.dart';
import 'package:studybean/common/extensions/context_theme.dart';

import '../../../../common/di/get_it.dart';
import '../../../splash/error_page.dart';
import '../../../splash/loading_page.dart';
import '../../models/roadmap.dart';
import 'bloc/delete_milestone_cubit/delete_milestone_cubit.dart';
import 'bloc/get_milestone_cubit/get_milestone_cubit.dart';
import 'bloc/mark_action_complete_cubit/mark_action_complete_cubit.dart';
import 'widgets/action_widget.dart';
import 'widgets/edit_milestone_widget.dart';

class MilestonePage extends StatefulWidget {
  const MilestonePage({super.key, required this.milestoneId});

  final String milestoneId;

  @override
  State<MilestonePage> createState() => _MilestonePageState();
}

class _MilestonePageState extends State<MilestonePage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<GetMilestoneCubit>()..getMilestone(widget.milestoneId),
        ),
        BlocProvider(
          create: (context) => getIt<DeleteMilestoneCubit>(),
        ),
      ],
      child: BlocBuilder<GetMilestoneCubit, GetMilestoneState>(
        builder: (context, getLocalMilestoneState) {
          switch (getLocalMilestoneState) {
            case GetMilestoneInitial():
            case GetMilestoneLoading():
              return const LoadingPage();
            case GetMilestoneSuccess():
              return BlocConsumer<DeleteMilestoneCubit, DeleteMilestoneState>(
                listener: (context, state) {
                  switch (state) {
                    case DeleteMilestoneInitial():
                    case DeleteMilestoneLoading():
                      break;
                    case DeleteMilestoneSuccess():
                      context.pop(true);
                      break;
                    case DeleteMilestoneError():
                      context.showErrorDialog(
                        title: 'Failed to delete milestone',
                        message: 'Something went wrong, please try again later',
                        onRetry: () => context
                            .read<DeleteMilestoneCubit>()
                            .deleteMilestone(widget.milestoneId),
                      );
                      break;
                  }
                },
                builder: (context, state) {
                  if (state is DeleteMilestoneSuccess) {
                    return const LoadingPage();
                  }
                  return Scaffold(
                    appBar: AppBar(
                      actions: [
                        IconButton(
                          onPressed: () async {
                            final shouldReload = await context.push<bool>(
                                '/home/roadmap/${getLocalMilestoneState.milestone.roadmapId}/milestone/${getLocalMilestoneState.milestone.id}/createAction');
                            if (context.mounted && (shouldReload ?? false)) {
                              context
                                  .read<GetMilestoneCubit>()
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
                              builder: (context) => EditMilestoneWidget(
                                milestone: getLocalMilestoneState.milestone,
                              ),
                            );

                            if (context.mounted && updatedMilestone != null) {
                              context
                                  .read<GetMilestoneCubit>()
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
                                  .read<DeleteMilestoneCubit>()
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
                                          '/home/roadmap/${getLocalMilestoneState.milestone.roadmapId}/milestone/${getLocalMilestoneState.milestone.id}/createAction');
                                      if (context.mounted &&
                                          (shouldReload ?? false)) {
                                        context
                                            .read<GetMilestoneCubit>()
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
                                          getIt<MarkActionCompleteCubit>(),
                                    ),
                                  ],
                                  child: BlocConsumer<MarkActionCompleteCubit,
                                      MarkActionCompleteState>(
                                    listener: (markLocalActionCompleteContext,
                                        markLocalActionCompleteState) {
                                      switch (markLocalActionCompleteState) {
                                        case MarkActionCompleteInitial():
                                        case MarkActionCompleteLoading():
                                          break;
                                        case MarkActionCompleteSuccess():
                                          markLocalActionCompleteContext
                                              .read<GetMilestoneCubit>()
                                              .updateMilestoneAction(
                                                  markLocalActionCompleteState
                                                      .action);
                                          break;
                                        case MarkActionCompleteFailure():
                                          markLocalActionCompleteContext
                                              .showErrorDialog(
                                            title:
                                                'Failed to mark action as complete',
                                            message:
                                                'Something went wrong, please try again.',
                                            onRetry: () =>
                                                markLocalActionCompleteContext
                                                    .read<
                                                        MarkActionCompleteCubit>()
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
                                        await context.push(
                                            '/home/roadmap/${getLocalMilestoneState.milestone.roadmapId}/milestone/${getLocalMilestoneState.milestone.id}/action/${action.id}',
                                            );

                                        if (context.mounted) {
                                          context
                                              .read<GetMilestoneCubit>()
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
                                                        MaterialStateProperty
                                                            .all(
                                                      context.theme.primaryColor,
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
                                                      onConfirm: () {},
                                                    );
                                                  },
                                                  style: context.theme
                                                      .elevatedButtonTheme.style
                                                      ?.copyWith(
                                                    backgroundColor:
                                                        MaterialStateProperty
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
                                            .read<MarkActionCompleteCubit>()
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
            case GetMilestoneError():
              return ErrorPage(
                onRetry: () => context
                    .read<GetMilestoneCubit>()
                    .getMilestone(widget.milestoneId),
              );
          }
        },
      ),
    );
  }
}
