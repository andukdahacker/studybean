class Subject {
  final String id;
  final String name;

  Subject({
    required this.id,
    required this.name,
  });

  Subject copyWith({
    String? id,
    String? name,
  }) =>
      Subject(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
