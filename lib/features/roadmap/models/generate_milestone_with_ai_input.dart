import 'duration_unit.dart';

class GenerateMilestoneWithAiInput {
  final String subjectName;
  final int duration;
  final DurationUnit durationUnit;
  final String goal;

  GenerateMilestoneWithAiInput({
    required this.subjectName,
    required this.duration,
    required this.durationUnit,
    required this.goal,
  });

  Map<String, dynamic> toMap() => {
    'subjectName': subjectName,
    'duration': duration,
    'durationUnit': durationUnit.value,
    'goal': goal,
  };
}