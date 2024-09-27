import '../../../common/models/page_info.dart';
import 'roadmap.dart';

class GetManyRoadmapResponse {
  final List<Roadmap> roadmaps;
  final PageInfo pageInfo;

  GetManyRoadmapResponse({
    required this.roadmaps,
    required this.pageInfo
  });

  factory GetManyRoadmapResponse.fromJson(Map<String, dynamic> json) {
    return GetManyRoadmapResponse(
      roadmaps: (json['nodes'] as List)
          .map((e) => Roadmap.fromJson(e))
          .toList(),
      pageInfo: PageInfo.fromJson(json['pageInfo']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['nodes'] = roadmaps.map((e) => e.toJson()).toList();
    json['pageInfo'] = pageInfo.toJson();
    return json;
  }
}