class PageInfo {
  final bool hasNextPage;
  final String? cursor;

  PageInfo({
    required this.hasNextPage,
    this.cursor,
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) {
    return PageInfo(
      hasNextPage: json['hasNextPage'],
      cursor: json['cursor'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['hasNextPage'] = hasNextPage;
    json['cursor'] = cursor;
    return json;
  }
}