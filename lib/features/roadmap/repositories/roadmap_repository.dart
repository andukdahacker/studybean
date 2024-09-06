import 'package:http_interceptor/http/http_methods.dart';
import 'package:studybean/features/roadmap/models/create_roadmap_input.dart';
import 'package:studybean/features/roadmap/models/roadmap.dart';

import '../../../common/api/api_client.dart';
import '../models/generate_milestone_with_ai_input.dart';
import '../models/generate_milestone_with_ai_response.dart';

class RoadmapRepository {
  final APIClient _client;

  RoadmapRepository(this._client);

  Future<Roadmap> createRoadmap(CreateRoadmapInput input) async {
    final response = await _client.call(
      HttpMethod.POST,
      path: '/roadmaps',
      body: input.toMap(),
    );

    if (response.data == null) {
      throw Exception('Failed to create roadmap');
    }

    return Roadmap.fromJson(response.data!);
  }

  Future<Roadmap> createRoadmapWithAI(CreateRoadmapInput input) async {
    final response = await _client.call(
      HttpMethod.POST,
      path: '/roadmaps/generateWithAI',
      body: input.toMap(),
    );

    if (response.data == null) {
      throw Exception('Failed to create roadmap');
    }

    return Roadmap.fromJson(response.data!);
  }
  
  Future<GenerateMilestoneWithAiResponse> generateMilestoneWithAI(GenerateMilestoneWithAiInput input) async {
    final response = await _client.call(HttpMethod.POST, path: '/roadmaps/generateMilestonesWithAI', body: input.toMap());

    if (response.data == null) {
      throw Exception('Failed to create roadmap');
    }

    return GenerateMilestoneWithAiResponse.fromJson(response.data!);
  }
}
