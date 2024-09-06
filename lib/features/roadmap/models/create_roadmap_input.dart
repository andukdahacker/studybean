import 'duration_unit.dart';

class CreateRoadmapInput {
  final String subjectId;
  final String userId;
  final String goal;
  final int duration;
  final DurationUnit durationUnit;

  CreateRoadmapInput({
    required this.subjectId,
    required this.userId,
    required this.goal,
    required this.duration,
    required this.durationUnit,
  });

  Map<String, String> toMap() {
    return {
      "subjectId": subjectId,
      "userId": userId,
      "goal": goal,
      "duration": duration.toString(),
      "durationUnit": durationUnit.value
    };
  }

  Map<String, dynamic> toJson() => {
    "subjectId": subjectId,
    "userId": userId,
  };
}