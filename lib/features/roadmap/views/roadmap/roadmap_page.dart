import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studybean/common/extensions/context_dialog_extension.dart';
import 'package:studybean/common/extensions/context_error_handling.dart';
import 'package:studybean/common/extensions/context_theme.dart';
import 'package:studybean/features/home/bloc/check_user_credit_cubit/check_user_credit_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/delete_roadmap_cubit/delete_roadmap_cubit.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<GetRoadmapCubit>()..getRoadmaps(),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => getIt<DeleteRoadmapCubit>(),
          lazy: false,
        ),
      ],
      child: Scaffold(
        floatingActionButton: BlocBuilder<GetRoadmapCubit, GetRoadmapState>(
          builder: (context, state) {
            switch (state) {
              case GetRoadmapSuccess():
                return ElevatedButton(
                  style: context.theme.elevatedButtonTheme.style?.copyWith(
                    minimumSize: WidgetStateProperty.all(const Size(160, 60)),
                    maximumSize: WidgetStateProperty.all(const Size(208, 60)),
                  ),
                  onPressed: () async {
                    await context.push('/home/createRoadmap');
                    if (context.mounted) {
                      context.read<GetRoadmapCubit>().getRoadmaps();
                      context.read<CheckUserCreditCubit>().checkUserCredit();
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
                                context
                                    .read<CheckUserCreditCubit>()
                                    .checkUserCredit();
                              }
                            },
                            child: const Text('Create a new roadmap'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return BlocListener<DeleteRoadmapCubit, DeleteRoadmapState>(
                  listener: (context, state) {
                    switch (state) {
                      case DeleteRoadmapInitial():
                        break;
                      case DeleteRoadmapLoading():
                        context.showLoading();
                        break;
                      case DeleteRoadmapSuccess():
                        context.hideLoading();
                        context.read<GetRoadmapCubit>().getRoadmaps();
                        break;
                      case DeleteRoadmapError():
                        context.hideLoading();
                        context.handleError(state.error);
                        break;
                    }
                  },
                  child: SafeArea(
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
                            return RoadmapWidget(
                              roadmap: roadmap,
                              onTap: () {
                                context.push('/home/roadmap/${roadmap.id}');
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
                                                              DeleteRoadmapCubit>()
                                                          .deleteRoadmap(
                                                              roadmap.id);
                                                    });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: context
                                                      .theme.colorScheme.error),
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
              case GetRoadmapError():
                return const Center(child: Text('Error'));
            }
          },
        ),
      ),
    );
  }
}
