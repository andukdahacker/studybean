import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studybean/common/extensions/context_dialog_extension.dart';
import 'package:studybean/common/extensions/context_theme.dart';
import 'package:studybean/features/roadmap/views/roadmap/widgets/roadmap_local_widget.dart';

import '../../../../../common/di/get_it.dart';
import 'bloc/get_roadmap_cubit/get_local_roadmap_cubit.dart';

class RoadmapLocalPage extends StatelessWidget {
  const RoadmapLocalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<GetLocalRoadmapCubit>()..getRoadmaps(),
      lazy: false,
      child: Scaffold(
        floatingActionButton:
            BlocBuilder<GetLocalRoadmapCubit, GetLocalRoadmapState>(
          builder: (context, state) {
            switch (state) {
              case GetLocalRoadmapSuccess():
                return ElevatedButton(
                  style: context.theme.elevatedButtonTheme.style?.copyWith(
                    minimumSize: MaterialStateProperty.all(const Size(160, 60)),
                    maximumSize: MaterialStateProperty.all(const Size(208, 60)),
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
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context
                            .read<GetLocalRoadmapCubit>()
                            .getRoadmaps();
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
                          return RoadmapLocalWidget(roadmap: roadmap);
                        },
                      ),
                    ),
                  ),
                );
              case GetLocalRoadmapError():
                return const Center(child: Text('Error'));
            }
          },
        ),
      ),
    );
  }
}
