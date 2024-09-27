class CreateMilestoneInput {
  final String name;
  final String roadmapId;
  final int index;

  CreateMilestoneInput({required this.name, required this.index, required this.roadmapId});

  Map<String, String> toMap() {
    return {
      'name': name,
      'index': index.toString(),
      'roadmapId': roadmapId
    };
  }
}