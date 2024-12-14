class GenerateMilestoneWithAiInput {
  final String subjectName;
  final String goal;

  GenerateMilestoneWithAiInput({
    required this.subjectName,
    required this.goal,
  });

  Map<String, dynamic> toMap() => {
    'subjectName': subjectName,
    'goal': goal,
  };
}