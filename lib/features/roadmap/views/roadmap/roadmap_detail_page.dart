import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studybean/common/extensions/context_dialog_extension.dart';
import 'package:studybean/common/extensions/context_theme.dart';

import '../../../../common/di/get_it.dart';
import '../../../splash/loading_page.dart';
import '../../models/create_milestone_input.dart';
import 'bloc/add_milestone_cubit/add_milestone_cubit.dart';
import 'bloc/get_roadmap_detail_cubit/get_roadmap_detail_cubit.dart';
import 'widgets/milestone_dot_widget.dart';
import 'widgets/milestone_widget.dart';

class RoadmapDetailPage extends StatefulWidget {
  const RoadmapDetailPage({super.key, required this.id});

  final String id;

  @override
  State<RoadmapDetailPage> createState() => _RoadmapDetailPageState();
}

class _RoadmapDetailPageState extends State<RoadmapDetailPage> {
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
          getIt<GetRoadmapDetailCubit>()..getRoadmapDetail(widget.id),
        ),
        BlocProvider(
          create: (context) => getIt<AddMilestoneCubit>(),
          lazy: false,
        )
      ],
      child:
      BlocBuilder<GetRoadmapDetailCubit, GetRoadmapDetailState>(
        builder: (context, state) {
          switch (state) {
            case GetRoadmapDetailInitial():
            case GetRoadmapDetailLoading():
              return const LoadingPage();
            case GetRoadmapDetailSuccess():
              final roadmap = state.roadmap;
              return BlocListener<AddMilestoneCubit,
                  AddMilestoneState>(
                listener: (context, state) async {
                  switch (state) {
                    case AddMilestoneInitial():
                    case AddMilestoneLoading():
                    case AddMilestoneError():
                      break;
                    case AddMilestoneSuccess():
                      await context.push(
                          '/home/roadmap/${roadmap.id}/milestone/${state.milestone.id}');
                      if (context.mounted) {
                        context
                            .read<GetRoadmapDetailCubit>()
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
                                return BlocListener<AddMilestoneCubit,
                                    AddMilestoneState>(
                                  listener: (context, state) async {
                                    switch (state) {
                                      case AddMilestoneInitial():
                                      case AddMilestoneLoading():
                                        break;
                                      case AddMilestoneSuccess():
                                        break;
                                      case AddMilestoneError():
                                        context.showErrorDialog(
                                            title: 'Failed to create milestone',
                                            message: 'Please try again.',
                                            onRetry: () {
                                              context
                                                  .read<
                                                  AddMilestoneCubit>()
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
                                                      AddMilestoneCubit>()
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
                                        child: MilestoneWidget(
                                          onTap: () async {
                                            final shouldReload = await context.push<bool>(
                                                '/home/roadmap/${milestone.roadmapId}/milestone/${milestone.id}');

                                            if (context.mounted &&
                                                (shouldReload ?? false)) {
                                              context
                                                  .read<GetRoadmapDetailCubit>()
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
            case GetRoadmapDetailError():
              return const Scaffold(body: Text('Error'));
          }
        },
      ),
    );
  }
}
