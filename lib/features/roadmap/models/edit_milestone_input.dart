class EditMilestoneInput {
  final String id;
  final String name;

  EditMilestoneInput({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}