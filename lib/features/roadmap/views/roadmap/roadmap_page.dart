import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studybean/common/extensions/context_theme.dart';

import '../../../../common/di/get_it.dart';
import 'bloc/get_roadmap_cubit/get_roadmap_cubit.dart';
import 'widgets/roadmap_widget.dart';

class RoadmapPage extends StatefulWidget {
  const RoadmapPage({super.key});

  @override
  State<RoadmapPage> createState() => _RoadmapPageState();
}

class _RoadmapPageState extends State<RoadmapPage>
    with AutomaticKeepAliveClientMixin<RoadmapPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => getIt<GetRoadmapCubit>()..getRoadmaps(),
      lazy: false,
      child: Scaffold(
        floatingActionButton: BlocBuilder<GetRoadmapCubit, GetRoadmapState>(
          builder: (context, state) {
            switch (state) {
              case GetRoadmapSuccess():
                return ElevatedButton(
                  style: context.theme.elevatedButtonTheme.style?.copyWith(
                    minimumSize: MaterialStateProperty.all(const Size(160, 60)),
                    maximumSize: MaterialStateProperty.all(const Size(208, 60)),
                  ),
                  onPressed: () async {
                    await context.push('/home/createRoadmap');
                    if (context.mounted) {
                      context.read<GetRoadmapCubit>().getRoadmaps();
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
              case GetRoadmapInitial():
              case GetRoadmapLoading():
              case GetRoadmapError():
                return const SizedBox.shrink();
            }
          },
        ),
        body: BlocBuilder<GetRoadmapCubit, GetRoadmapState>(
          builder: (context, state) {
            switch (state) {
              case GetRoadmapInitial():
              case GetRoadmapLoading():
                return const Center(child: CircularProgressIndicator());
              case GetRoadmapSuccess():
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
                              await context.push('/home/createRoadmap');
                              if (context.mounted) {
                                context.read<GetRoadmapCubit>().getRoadmaps();
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
                        context.read<GetRoadmapCubit>().getRoadmaps();
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
                          return RoadmapWidget(roadmap: roadmap, onTap: () {
                              context.push('/home/roadmap/${roadmap.id}');
                          },);
                        },
                      ),
                    ),
                  ),
                );
              case GetRoadmapError():
                return const Center(child: Text('Error'));
            }
          },
        ),
      ),
    );
  }
}
