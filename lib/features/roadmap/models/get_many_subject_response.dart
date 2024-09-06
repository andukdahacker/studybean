import 'package:studybean/common/models/page_info.dart';
import 'package:studybean/features/roadmap/models/subject.dart';

class GetManySubjectResponse {
  final List<Subject> nodes;
  final PageInfo pageInfo;

  GetManySubjectResponse({
    required this.nodes,
    required this.pageInfo,
  });

  factory GetManySubjectResponse.fromJson(Map<String, dynamic> json) {
    return GetManySubjectResponse(
      nodes: (json['nodes'] as List).map((e) => Subject.fromJson(e)).toList(),
      pageInfo: PageInfo.fromJson(json['pageInfo']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['nodes'] = nodes.map((e) => e.toJson()).toList();
    json['pageInfo'] = pageInfo.toJson();
    return json;
  }
}