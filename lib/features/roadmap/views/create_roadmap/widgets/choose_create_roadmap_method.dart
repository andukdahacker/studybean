import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/common/di/get_it.dart';
import 'package:studybean/features/roadmap/views/create_roadmap/bloc/create_local_roadmap_cubit/create_local_roadmap_cubit.dart';

import '../../../models/duration_unit.dart';

class ChooseCreateRoadmapMethodWidget extends StatefulWidget {
  const ChooseCreateRoadmapMethodWidget({
    super.key,
    required this.onBack,
    required this.subjectName,
    required this.selectedGoalDuration,
    required this.selectedGoalDurationUnit,
    required this.goal,
    required this.onCreateRoadmapManually,
    required this.onCreateRoadmapWithAI,
  });

  final VoidCallback onBack;
  final String? subjectName;
  final int selectedGoalDuration;
  final DurationUnit selectedGoalDurationUnit;
  final String? goal;
  final VoidCallback onCreateRoadmapManually;
  final VoidCallback onCreateRoadmapWithAI;

  @override
  State<ChooseCreateRoadmapMethodWidget> createState() =>
      _ChooseCreateRoadmapMethodWidgetState();
}

class _ChooseCreateRoadmapMethodWidgetState
    extends State<ChooseCreateRoadmapMethodWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CreateLocalRoadmapCubit>(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => widget.onBack.call(),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Back to Choose Goals & Duration',
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Create Roadmap, with AI',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            Text('You can spend Credits to generate new roadmap effortlessly.',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(
              height: 8,
            ),
            Text(
              'You have 10 credits',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                widget.onCreateRoadmapWithAI.call();
              },
              child: const Text('Create Roadmap with AI (-1 credit)'),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'Or, create it manually using no Credits',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                widget.onCreateRoadmapManually.call();
              },
              child: const Text('Create Roadmap manually'),
            ),
          ],
        ),
      ),
    );
  }
}
