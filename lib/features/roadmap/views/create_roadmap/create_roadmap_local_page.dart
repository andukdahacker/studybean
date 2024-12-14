import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studybean/common/extensions/context_dialog_extension.dart';
import 'package:studybean/common/extensions/context_theme.dart';
import 'package:studybean/features/roadmap/models/generate_milestone_with_ai_input.dart';
import 'package:studybean/features/roadmap/views/create_roadmap/bloc/check_user_credit/check_local_user_credit_cubit.dart';
import 'package:studybean/features/roadmap/views/create_roadmap/bloc/create_local_roadmap_cubit/create_local_roadmap_cubit.dart';
import 'package:studybean/features/roadmap/views/create_roadmap/bloc/create_local_roadmap_cubit/create_local_roadmap_with_ai_cubit.dart';
import 'package:studybean/features/roadmap/views/create_roadmap/widgets/choose_create_roadmap_method.dart';
import 'package:studybean/features/roadmap/views/create_roadmap/widgets/choose_goals_duration_widget.dart';
import 'package:studybean/features/roadmap/views/create_roadmap/widgets/choose_subject_widget.dart';

import '../../../../common/di/get_it.dart';
import '../../models/create_local_roadmap_input.dart';

class CreateRoadmapLocalPage extends StatefulWidget {
  const CreateRoadmapLocalPage({super.key, this.isFirstTime = false});

  final bool isFirstTime;

  @override
  State<CreateRoadmapLocalPage> createState() => _CreateRoadmapLocalPageState();
}

class _CreateRoadmapLocalPageState extends State<CreateRoadmapLocalPage> {
  late PageController _pageController;
  double _progress = 1 / 3;

  String? subjectName;
  String? _goal;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Create Roadmap',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: _progress,
              backgroundColor: context.theme.colorScheme.surface,
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _progress = (index + 1) / 3.0;
                  });
                },
                children: [
                  ChooseSubjectWidget(
                    selectedSubjectName: subjectName,
                    onNext: (subject) {
                      setState(() {
                        subjectName = subject;
                      });
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                  DescribeGoalsWidget(
                    subjectName: subjectName,
                    onNext: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    onBack: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    onGoalChanged: (goal) {
                      setState(() {
                        _goal = goal;
                      });
                    },
                    goal: _goal,
                  ),
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => getIt<CreateLocalRoadmapCubit>(),
                      ),
                      BlocProvider(
                        create: (context) =>
                            getIt<CreateLocalRoadmapWithAiCubit>(),
                      ),
                      BlocProvider(
                        create: (context) => getIt<CheckLocalUserCreditCubit>()
                          ..checkUserCredit(),
                      )
                    ],
                    child: Builder(builder: (context) {
                      return MultiBlocListener(
                        listeners: [
                          BlocListener<CreateLocalRoadmapWithAiCubit,
                              CreateLocalRoadmapWithAiState>(
                            listener: (context, state) {
                              switch (state) {
                                case CreateLocalRoadmapWithAiInitial():
                                  break;
                                case CreateLocalRoadmapWithAiLoading():
                                  context.showLoading();
                                  break;
                                case CreateLocalRoadmapWithAiSuccess():
                                  context.pop();
                                  if (widget.isFirstTime) {
                                    context.go('/local/home');
                                  } else {
                                    context.pop();
                                  }
                                  break;
                                case CreateLocalRoadmapWithAiError():
                                  context.pop();
                                  context.showErrorDialog(
                                    title: 'Failed to create roadmap',
                                    message: 'Please try again later',
                                  );
                                  break;
                              }
                            },
                          ),
                          BlocListener<CreateLocalRoadmapCubit,
                              CreateLocalRoadmapState>(
                            listener: (context, state) {
                              switch (state) {
                                case CreateLocalRoadmapInitial():
                                  break;
                                case CreateLocalRoadmapLoading():
                                  break;
                                case CreateLocalRoadmapSuccess():
                                  if (widget.isFirstTime) {
                                    context.go('/local/home');
                                  } else {
                                    context.pop();
                                  }
                                  break;
                                case CreateLocalRoadmapError():
                                  context.showErrorDialog(
                                    title: 'Failed to create roadmap',
                                    message: 'Please try again later',
                                  );
                                  break;
                              }
                            },
                          ),
                        ],
                        child: BlocBuilder<CheckLocalUserCreditCubit,
                            CheckLocalUserCreditState>(
                          builder: (context, state) {
                            return ChooseCreateRoadmapMethodWidget(
                              credits: (state is CheckLocalUserCreditSuccess)
                                  ? state.totalCredits
                                  : 0,
                              goal: _goal,
                              subjectName: subjectName,
                              onBack: () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              onCreateRoadmapManually: () {
                                context
                                    .read<CreateLocalRoadmapCubit>()
                                    .createLocalRoadmap(
                                      CreateLocalRoadmapInput(
                                        subject: subjectName ?? '',
                                        goal: _goal ?? '',
                                      ),
                                    );
                              },
                              onCreateRoadmapWithAI: () {
                                context
                                    .read<CreateLocalRoadmapWithAiCubit>()
                                    .createLocalRoadmapWithAI(
                                      GenerateMilestoneWithAiInput(
                                        subjectName: subjectName ?? '',
                                        goal: _goal ?? '',
                                      ),
                                    );
                              },
                            );
                          },
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
