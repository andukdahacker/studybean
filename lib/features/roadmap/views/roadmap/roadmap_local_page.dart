import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studybean/common/extensions/context_dialog_extension.dart';
import 'package:studybean/common/extensions/context_error_handling.dart';
import 'package:studybean/common/extensions/context_theme.dart';
import 'package:studybean/features/roadmap/views/create_roadmap/bloc/create_local_roadmap_cubit/create_local_roadmap_with_ai_cubit.dart';
import 'package:studybean/features/splash/loading_page.dart';

import '../../../../../common/di/get_it.dart';
import 'bloc/delete_roadmap_cubit/delete_local_roadmap_cubit.dart';
import 'bloc/get_roadmap_cubit/get_local_roadmap_cubit.dart';
import 'widgets/roadmap_widget.dart';

class RoadmapLocalPage extends StatelessWidget {
  const RoadmapLocalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<GetLocalRoadmapCubit>()..getRoadmaps(),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => getIt<DeleteLocalRoadmapCubit>(),
          lazy: false,
        ),
      ],
      child: BlocConsumer<CreateLocalRoadmapWithAiCubit,
          CreateLocalRoadmapWithAiState>(
        listener: (context, state) {
          switch(state) {
            case CreateLocalRoadmapWithAiInitial():
            case CreateLocalRoadmapWithAiLoading():
              break;
            case CreateLocalRoadmapWithAiSuccess():
              context.read<GetLocalRoadmapCubit>().getRoadmaps();
              break;
            case CreateLocalRoadmapWithAiError():
              break;
          }
        },
        builder: (context, createLocalRoadmapState) {
          switch(createLocalRoadmapState) {
            case CreateLocalRoadmapWithAiLoading():
              return const LoadingPage();
            case CreateLocalRoadmapWithAiInitial():
            case CreateLocalRoadmapWithAiSuccess():
            case CreateLocalRoadmapWithAiError():
          }
          return Scaffold(
          floatingActionButton:
              BlocBuilder<GetLocalRoadmapCubit, GetLocalRoadmapState>(
            builder: (context, state) {
              switch (state) {
                case GetLocalRoadmapSuccess():
                  return ElevatedButton(
                    style: context.theme.elevatedButtonTheme.style?.copyWith(
                      minimumSize: WidgetStateProperty.all(const Size(160, 60)),
                      maximumSize: WidgetStateProperty.all(const Size(208, 60)),
                    ),
                    onPressed: () async {
                      if (state.roadmaps.isNotEmpty) {
                        context.showCustomDialog(
                          builder: (dialogContext) => BlocProvider.value(
                            value: context.read<GetLocalRoadmapCubit>(),
                            child: Dialog(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      'assets/images/not_found.png',
                                      fit: BoxFit.fitWidth,
                                      width: double.infinity,
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      'You will lose your existing roadmap',
                                      textAlign: TextAlign.center,
                                      style: context.theme.textTheme.bodyLarge
                                          ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      'Guest account can only create 1 roadmap at a time.\n\nPlease create an account or sign in to create more than 1 roadmap.',
                                      style: context.theme.textTheme.bodyLarge,
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await context
                                            .push('/local/home/createRoadmap');
                                        if (context.mounted) {
                                          context
                                              .read<GetLocalRoadmapCubit>()
                                              .getRoadmaps();
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Text('Create new'),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    OutlinedButton(
                                      onPressed: () {
                                        context.push('/signIn');
                                      },
                                      child: const Text('Sign in'),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        await context.push('/local/home/createRoadmap');
                        if (context.mounted) {
                          context.read<GetLocalRoadmapCubit>().getRoadmaps();
                        }
                      }
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.add),
                        SizedBox(
                          width: 8,
                        ),
                        Text('New roadmap'),
                      ],
                    ),
                  );
                case GetLocalRoadmapInitial():
                case GetLocalRoadmapLoading():
                case GetLocalRoadmapError():
                  return const SizedBox.shrink();
              }
            },
          ),
          body: BlocConsumer<GetLocalRoadmapCubit, GetLocalRoadmapState>(
            listener: (context, state) {
              switch (state) {
                case GetLocalRoadmapInitial():
                case GetLocalRoadmapLoading():
                case GetLocalRoadmapError():
                  break;
                case GetLocalRoadmapSuccess():
                  break;
              }
            },
            builder: (context, state) {
              switch (state) {
                case GetLocalRoadmapInitial():
                case GetLocalRoadmapLoading():
                  return const Center(child: CircularProgressIndicator());
                case GetLocalRoadmapSuccess():
                  if (state.roadmaps.isEmpty) {
                    return SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('No roadmaps found'),
                            const SizedBox(
                              height: 16,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await context.push('/local/home/createRoadmap');
                                if (context.mounted) {
                                  context
                                      .read<GetLocalRoadmapCubit>()
                                      .getRoadmaps();
                                }
                              },
                              child: const Text('Create a new roadmap'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return BlocListener<DeleteLocalRoadmapCubit,
                      DeleteLocalRoadmapState>(
                    listener: (context, state) {
                      switch (state) {
                        case DeleteLocalRoadmapInitial():
                          break;
                        case DeleteLocalRoadmapSuccess():
                          context.read<GetLocalRoadmapCubit>().getRoadmaps();
                          break;
                        case DeleteLocalRoadmapError():
                          context.handleError(state.error);
                          break;
                      }
                    },
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: RefreshIndicator(
                          onRefresh: () async {
                            context.read<GetLocalRoadmapCubit>().getRoadmaps();
                          },
                          child: ListView.separated(
                            itemCount: state.roadmaps.length,
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 16,
                              );
                            },
                            itemBuilder: (context, index) {
                              final roadmap = state.roadmaps[index];
                              return RoadmapWidget(
                                roadmap: roadmap,
                                onTap: () {
                                  context.push(
                                      '/local/home/roadmap/${roadmap.id}');
                                },
                                onLongPress: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (bottomSheetContext) {
                                        return Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  bottomSheetContext.pop();
                                                  context.showConfirmDialog(
                                                      title: 'Delete roadmap',
                                                      message:
                                                          'Are you sure you want to delete this roadmap?',
                                                      onConfirm: () {
                                                        context
                                                            .read<
                                                                DeleteLocalRoadmapCubit>()
                                                            .deleteRoadmap();
                                                      });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: context
                                                        .theme
                                                        .colorScheme
                                                        .error),
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                case GetLocalRoadmapError():
                  return const Center(child: Text('Error'));
              }
            },
          ),
        );
        },
      ),
    );
  }
}
