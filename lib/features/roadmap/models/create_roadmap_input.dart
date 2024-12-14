class CreateRoadmapInput {
  final String subjectName;
  final String goal;

  CreateRoadmapInput({
    required this.subjectName,
    required this.goal,
  });

  Map<String, String> toMap() {
    return {
      "subjectName": subjectName,
      "goal": goal,
    };
  }

  Map<String, dynamic> toJson() => {
    "subjectName": subjectName,
  };
}