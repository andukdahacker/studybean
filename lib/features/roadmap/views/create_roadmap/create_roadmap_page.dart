import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studybean/common/di/get_it.dart';
import 'package:studybean/common/extensions/context_dialog_extension.dart';
import 'package:studybean/common/extensions/context_theme.dart';
import 'package:studybean/features/roadmap/views/create_roadmap/bloc/create_roadmap_cubit/create_roadmap_cubit.dart';
import 'package:studybean/features/roadmap/views/create_roadmap/bloc/create_roadmap_cubit/create_roadmap_with_ai_cubit.dart';
import 'package:studybean/features/roadmap/views/create_roadmap/widgets/choose_create_roadmap_method.dart';
import 'package:studybean/features/roadmap/views/create_roadmap/widgets/choose_goals_duration_widget.dart';
import 'package:studybean/features/roadmap/views/create_roadmap/widgets/choose_subject_widget.dart';

import '../../models/create_roadmap_input.dart';

class CreateRoadmapPage extends StatefulWidget {
  const CreateRoadmapPage({super.key});

  @override
  State<CreateRoadmapPage> createState() => _CreateRoadmapPageState();
}

class _CreateRoadmapPageState extends State<CreateRoadmapPage> {
  late PageController _pageController;
  double _progress = 1 / 3;

  String? _subject;
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<CreateRoadmapCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<CreateRoadmapWithAiCubit>(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Create Roadmap',
            style: Theme
                .of(context)
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
                      selectedSubjectName: _subject,
                      onNext: (subject) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                        setState(() {
                          _subject = subject;
                        });
                      },
                    ),
                    DescribeGoalsWidget(
                      subjectName: _subject,
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
                    BlocConsumer<CreateRoadmapWithAiCubit,
                        CreateRoadmapWithAiState>(
                      listener: (context, createRoadmapWithAiState) {
                        switch (createRoadmapWithAiState) {
                          case CreateRoadmapWithAiInitial():
                            break;
                          case CreateRoadmapWithAiLoading():
                            context.showLoading();
                            break;
                          case CreateRoadmapWithAiSuccess():
                            context.hideLoading();
                            context.pop();
                            break;
                          case CreateRoadmapWithAiError():
                            context.hideLoading();
                            context.showErrorDialog(
                                title: 'Failed to create roadmap',
                                message:
                                'Something went wrong, please try again.',
                                onRetry: () {
                                  context
                                      .read<CreateRoadmapWithAiCubit>()
                                      .createRoadmapWithAI(
                                    CreateRoadmapInput(
                                      subjectName: _subject ?? '',
                                      goal: _goal ?? '',
                                    ),
                                  );
                                });
                            break;
                        }
                      },
                      builder: (context, createRoadmapWithAiState) {
                        return BlocConsumer<CreateRoadmapCubit,
                            CreateRoadmapState>(
                          listener: (context, createRoadmapState) {
                            switch (createRoadmapState) {
                              case CreateRoadmapInitial():
                                break;
                              case CreateRoadmapLoading():
                                context.showLoading();
                                break;
                              case CreateRoadmapSuccess():
                                context.hideLoading();
                                context.pop();
                                break;
                              case CreateRoadmapError():
                                context.hideLoading();
                                context.showErrorDialog(
                                    title: 'Failed to create roadmap',
                                    message:
                                    'Something went wrong, please try again.',
                                    onRetry: () {
                                      context
                                          .read<CreateRoadmapCubit>()
                                          .createRoadmap(
                                        CreateRoadmapInput(
                                          subjectName: _subject ?? '',
                                          goal: _goal ?? '',
                                        ),
                                      );
                                    });
                                break;
                            }
                          },
                          builder: (context, createRoadmapState) {
                            return ChooseCreateRoadmapMethodWidget(
                              goal: _goal,
                              subjectName: _subject,
                              onBack: () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              onCreateRoadmapManually: () {
                                context
                                    .read<CreateRoadmapCubit>()
                                    .createRoadmap(
                                  CreateRoadmapInput(
                                    subjectName: _subject ?? '',
                                    goal: _goal ?? '',
                                  ),
                                );
                              },
                              onCreateRoadmapWithAI: () {
                                context
                                    .read<CreateRoadmapWithAiCubit>()
                                    .createRoadmapWithAI(
                                  CreateRoadmapInput(
                                    subjectName: _subject ?? '',
                                    goal: _goal ?? '',
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
