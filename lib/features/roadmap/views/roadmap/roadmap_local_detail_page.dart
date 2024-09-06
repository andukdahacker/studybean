import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studybean/common/di/get_it.dart';
import 'package:studybean/common/extensions/context_dialog_extension.dart';
import 'package:studybean/common/extensions/context_theme.dart';
import 'package:studybean/features/roadmap/models/create_milestone_input.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/add_milestone_cubit/add_local_milestone_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/get_roadmap_detail_cubit/get_local_roadmap_detail_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/widgets/milestone_dot_widget.dart';
import 'package:studybean/features/roadmap/views/roadmap/widgets/milestone_local_widget.dart';
import 'package:studybean/features/splash/loading_page.dart';

class RoadmapLocalDetailPage extends StatefulWidget {
  const RoadmapLocalDetailPage({super.key, required this.id});

  final String id;

  @override
  State<RoadmapLocalDetailPage> createState() => _RoadmapLocalDetailPageState();
}

class _RoadmapLocalDetailPageState extends State<RoadmapLocalDetailPage> {
  late final TextEditingController _milestoneNameController;
  late final FocusNode _milestoneNameFocusNode;

  bool _isAddingMilestone = false;

  @override
  void initState() {
    _milestoneNameController = TextEditingController();
    _milestoneNameFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _milestoneNameController.dispose();
    _milestoneNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<GetLocalRoadmapDetailCubit>()..getRoadmapDetail(widget.id),
        ),
        BlocProvider(
          create: (context) => getIt<AddLocalMilestoneCubit>(),
          lazy: false,
        )
      ],
      child:
          BlocBuilder<GetLocalRoadmapDetailCubit, GetLocalRoadmapDetailState>(
        builder: (context, state) {
          switch (state) {
            case GetLocalRoadmapDetailInitial():
            case GetLocalRoadmapDetailLoading():
              return const LoadingPage();
            case GetLocalRoadmapDetailSuccess():
              final roadmap = state.roadmap;
              return BlocListener<AddLocalMilestoneCubit,
                  AddLocalMilestoneState>(
                listener: (context, state) async {
                  switch (state) {
                    case AddLocalMilestoneInitial():
                    case AddLocalMilestoneLoading():
                    case AddLocalMilestoneError():
                      break;
                    case AddLocalMilestoneSuccess():
                      await context.push(
                          '/local/home/roadmap/${roadmap.id}/milestone/${state.milestone.id}');
                      if (context.mounted) {
                        context
                            .read<GetLocalRoadmapDetailCubit>()
                            .getRoadmapDetail(widget.id);
                      }
                      break;
                  }
                },
                child: Scaffold(
                  appBar: AppBar(
                    title: Text('${roadmap.subject?.name}'),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Roadmap to "${roadmap.goal}"',
                          style: context.theme.textTheme.headlineLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: _isAddingMilestone
                                ? const EdgeInsets.only(bottom: 64)
                                : null,
                            itemBuilder: (context, index) {
                              if (index == (roadmap.milestones?.length ?? 0)) {
                                return BlocListener<AddLocalMilestoneCubit,
                                    AddLocalMilestoneState>(
                                  listener: (context, state) async {
                                    switch (state) {
                                      case AddLocalMilestoneInitial():
                                      case AddLocalMilestoneLoading():
                                        break;
                                      case AddLocalMilestoneSuccess():
                                        break;
                                      case AddLocalMilestoneError():
                                        context.showErrorDialog(
                                            title: 'Failed to create milestone',
                                            message: 'Please try again.',
                                            onRetry: () {
                                              context
                                                  .read<
                                                      AddLocalMilestoneCubit>()
                                                  .createMilestone(
                                                    CreateMilestoneInput(
                                                      name:
                                                          _milestoneNameController
                                                              .text,
                                                      index: index,
                                                      roadmapId: roadmap.id,
                                                    ),
                                                  );
                                            });
                                        break;
                                    }
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (!_isAddingMilestone)
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _isAddingMilestone = true;
                                              });

                                              _milestoneNameFocusNode
                                                  .requestFocus();
                                            },
                                            child: Container(
                                              width: 48,
                                              height: 48,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: context
                                                    .theme.colorScheme.primary,
                                              ),
                                              child: const Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        )
                                      else
                                        const Expanded(
                                          child: MilestoneDotWidget(),
                                        ),
                                      if (!_isAddingMilestone)
                                        const Spacer(
                                          flex: 7,
                                        ),
                                      if (_isAddingMilestone)
                                        Expanded(
                                          flex: 7,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0),
                                            child: TextField(
                                              controller:
                                                  _milestoneNameController,
                                              focusNode:
                                                  _milestoneNameFocusNode,
                                              onEditingComplete: () {
                                                if (_milestoneNameController
                                                    .text.isNotEmpty) {
                                                  context
                                                      .read<
                                                          AddLocalMilestoneCubit>()
                                                      .createMilestone(
                                                        CreateMilestoneInput(
                                                          name:
                                                              _milestoneNameController
                                                                  .text,
                                                          index: index,
                                                          roadmapId: roadmap.id,
                                                        ),
                                                      );

                                                  setState(() {
                                                    _isAddingMilestone = false;
                                                  });
                                                }
                                              },
                                              decoration:
                                                  const InputDecoration()
                                                      .applyDefaults(context
                                                          .theme
                                                          .inputDecorationTheme)
                                                      .copyWith(
                                                        hintText:
                                                            'Milestone Name',
                                                        suffixIcon:
                                                            GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              _isAddingMilestone =
                                                                  false;
                                                            });
                                                          },
                                                          child: const Icon(
                                                              Icons.remove),
                                                        ),
                                                      ),
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                );
                              }

                              final milestone = roadmap.milestones![index];

                              return SizedBox(
                                height: 192,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          const MilestoneDotWidget(),
                                          Container(
                                            height: 176,
                                            width: 2,
                                            decoration: BoxDecoration(
                                              color: context
                                                  .theme.colorScheme.primary,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 7,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16.0),
                                        child: MilestoneLocalWidget(
                                          onTap: () async {
                                            final shouldReload = await context.push<bool>(
                                                '/local/home/roadmap/${milestone.roadmapId}/milestone/${milestone.id}');

                                            if (context.mounted &&
                                                (shouldReload ?? false)) {
                                              context
                                                  .read<GetLocalRoadmapDetailCubit>()
                                                  .getRoadmapDetail(widget.id);
                                            }
                                          },
                                          milestone: milestone,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            itemCount: (roadmap.milestones?.length ?? 0) + 1,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            case GetLocalRoadmapDetailError():
              return const Scaffold(body: Text('Error'));
          }
        },
      ),
    );
  }
}
