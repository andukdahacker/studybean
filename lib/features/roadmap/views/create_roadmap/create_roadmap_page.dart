import 'package:flutter/material.dart';
import 'package:studybean/features/roadmap/models/duration_unit.dart';
import 'package:studybean/features/roadmap/views/create_roadmap/widgets/choose_create_roadmap_method.dart';
import 'package:studybean/features/roadmap/views/create_roadmap/widgets/choose_goals_duration_widget.dart';
import 'package:studybean/features/roadmap/views/create_roadmap/widgets/choose_subject_widget.dart';

class CreateRoadmapPage extends StatefulWidget {
  const CreateRoadmapPage({super.key});

  @override
  State<CreateRoadmapPage> createState() => _CreateRoadmapPageState();
}

class _CreateRoadmapPageState extends State<CreateRoadmapPage> {
  late PageController _pageController;
  double _progress = 1 / 3;

  String? _subject;
  int _goalDuration = 1;
  DurationUnit _goalDurationUnit = DurationUnit.day;
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
                    },
                  ),
                  ChooseGoalsDurationWidget(
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
                    onDurationChanged: (duration, unit) {
                      setState(() {
                        _goalDuration = duration;
                        _goalDurationUnit = unit;
                      });
                    },
                    goal: _goal,
                    selectedGoalDuration: _goalDuration,
                    selectedGoalDurationUnit: _goalDurationUnit,
                  ),
                  ChooseCreateRoadmapMethodWidget(
                    goal: _goal,
                    selectedGoalDuration: _goalDuration,
                    subjectName: _subject,
                    selectedGoalDurationUnit: _goalDurationUnit,
                    onBack: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    onCreateRoadmapManually: () {},
                    onCreateRoadmapWithAI: () {},
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
