class CreateLocalRoadmapInput {
  final String subject;
  final String goal;

  CreateLocalRoadmapInput({
    required this.subject,
    required this.goal,
  });

  Map<String, String> toMap() {
    return {
      "subject": subject,
      "goal": goal,
    };
  }
}