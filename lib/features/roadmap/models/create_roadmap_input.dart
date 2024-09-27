import 'duration_unit.dart';

class CreateRoadmapInput {
  final String subjectName;
  final String goal;
  final int duration;
  final DurationUnit durationUnit;

  CreateRoadmapInput({
    required this.subjectName,
    required this.goal,
    required this.duration,
    required this.durationUnit,
  });

  Map<String, String> toMap() {
    return {
      "subjectName": subjectName,
      "goal": goal,
      "duration": duration.toString(),
      "durationUnit": durationUnit.value
    };
  }

  Map<String, dynamic> toJson() => {
    "subjectName": subjectName,
  };
}