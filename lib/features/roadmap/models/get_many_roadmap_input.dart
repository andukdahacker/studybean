class GetManyRoadmapInput {
  final int take;
  final String? cursor;

  GetManyRoadmapInput({required this.take, this.cursor});

  Map<String, String> toJson() => {
    'take': take.toString(),
    'cursor': cursor ?? ''
  };
}