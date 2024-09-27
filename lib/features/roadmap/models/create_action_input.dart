import 'duration_unit.dart';

class CreateActionInput {
  final String milestoneId;
  final String name;
  final String? description;
  final int duration;
  final DurationUnit durationUnit;

  CreateActionInput(
      {required this.milestoneId,
      required this.name,
      required this.duration,
      required this.durationUnit,
      this.description});

  Map<String, String> toMap() {
    return {
      'milestoneId': milestoneId,
      'name': name,
      'description': description ?? '',
      'duration': duration.toString(),
      'durationUnit': durationUnit.value
    };
  }
}
