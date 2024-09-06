import 'package:studybean/features/roadmap/models/duration_unit.dart';

class CreateLocalActionInput {
  CreateLocalActionInput({
    required this.milestoneId,
    required this.name,
    required this.duration,
    required this.durationUnit,
    this.description,
  });

  final String milestoneId;
  final String name;
  final String? description;
  final int duration;
  final DurationUnit durationUnit;
}