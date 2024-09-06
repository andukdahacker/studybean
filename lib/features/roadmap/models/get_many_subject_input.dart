class GetManySubjectInput {
  final String name;
  final int take;
  final String? cursor;

  GetManySubjectInput({
    required this.name,
    required this.take,
    required this.cursor,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "take": take,
    "cursor": cursor,
  };
}