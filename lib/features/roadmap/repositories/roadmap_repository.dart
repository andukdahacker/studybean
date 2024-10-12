import 'package:http_interceptor/http/http_methods.dart';
import 'package:studybean/features/roadmap/models/create_action_input.dart';
import 'package:studybean/features/roadmap/models/create_roadmap_input.dart';
import 'package:studybean/features/roadmap/models/edit_action_resource_input.dart';
import 'package:studybean/features/roadmap/models/get_many_roadmap_input.dart';
import 'package:studybean/features/roadmap/models/get_many_roadmap_response.dart';
import 'package:studybean/features/roadmap/models/roadmap.dart';

import '../../../common/api/api_client.dart';
import '../models/create_action_resource_input.dart';
import '../models/create_milestone_input.dart';
import '../models/edit_milestone_input.dart';
import '../models/generate_milestone_with_ai_input.dart';
import '../models/generate_milestone_with_ai_response.dart';
import '../models/update_action_input.dart';

class RoadmapRepository {
  final APIClient _client;

  RoadmapRepository(this._client);

  Future<Roadmap> getRoadmapById(String id) async {
    final response = await _client.call(
      HttpMethod.GET,
      path: '/roadmaps/$id',
    );

    if (response.data == null) {
      throw Exception('Failed to get roadmap');
    }

    return Roadmap.fromJson(response.data!);
  }

  Future<GetManyRoadmapResponse> getRoadmaps(GetManyRoadmapInput input) async {
    final response = await _client.call(
      HttpMethod.GET,
      path: '/roadmaps/list',
      query: input.toJson(),
    );

    if (response.data == null) {
      throw Exception('Failed to get roadmaps');
    }

    return GetManyRoadmapResponse.fromJson(response.data!);
  }

  Future<Roadmap> createRoadmap(CreateRoadmapInput input) async {
    final response = await _client.call(
      HttpMethod.POST,
      path: '/roadmaps',
      body: input.toMap(),
    );

    if (response.data == null) {
      throw Exception('Failed to create roadmap');
    }

    return Roadmap.fromJson(response.data!['roadmap']);
  }

  Future<Roadmap> createRoadmapWithAI(CreateRoadmapInput input) async {
    final response = await _client.call(
      HttpMethod.POST,
      path: '/roadmaps/createRoadmapWithAI',
      body: input.toMap(),
    );

    if (response.data == null) {
      throw Exception('Failed to create roadmap');
    }

    return Roadmap.fromJson(response.data!['roadmap']);
  }

  Future<GenerateMilestoneWithAiResponse> generateMilestoneWithAI(
      GenerateMilestoneWithAiInput input) async {
    final response = await _client.call(HttpMethod.POST,
        path: '/roadmaps/generateMilestonesWithAI', body: input.toMap());

    if (response.data == null) {
      throw Exception('Failed to create roadmap');
    }

    return GenerateMilestoneWithAiResponse.fromJson(response.data!);
  }

  Future<Milestone> createMilestone(CreateMilestoneInput input) async {
    final response = await _client.call(
      HttpMethod.POST,
      path: '/roadmaps/addMilestone',
      body: input.toMap(),
    );

    if (response.data == null) {
      throw Exception('Failed to create roadmap');
    }

    return Milestone.fromJson(response.data!);
  }

  Future<Milestone> getMilestoneById(String id) async {
    final response = await _client.call(
      HttpMethod.GET,
      path: '/roadmaps/milestone/$id',
    );

    if (response.data == null) {
      throw Exception('Failed to get roadmap');
    }

    return Milestone.fromJson(response.data!);
  }

  Future<void> deleteMilestone(String id) async {
    await _client.call(HttpMethod.DELETE, path: '/roadmaps/milestone/$id');
  }

  Future<MilestoneAction> updateAction(UpdateActionInput input) async {
    final response = await _client.call(
      HttpMethod.PUT,
      path: '/roadmaps/action',
      body: input.toMap(),
    );

    if (response.data == null) {
      throw Exception('Failed to update action');
    }

    return MilestoneAction.fromJson(response.data!);
  }

  Future<Milestone> updateMilestone(EditMilestoneInput input) async {
    final response = await _client.call(HttpMethod.PUT,
        path: '/roadmaps/milestone', body: input.toMap());

    if (response.data == null) {
      throw Exception('Failed to update milestone');
    }

    return Milestone.fromJson(response.data!);
  }

  Future<MilestoneAction> createAction(CreateActionInput input) async {
    final response = await _client.call(HttpMethod.POST,
        path: '/roadmaps/action', body: input.toMap());

    if (response.data == null) {
      throw Exception('Failed to create action');
    }

    return MilestoneAction.fromJson(response.data!);
  }

  Future<MilestoneAction> getAction(String id) async {
    final response =
        await _client.call(HttpMethod.GET, path: '/roadmaps/action/$id');

    if (response.data == null) {
      throw Exception('Failed to get action');
    }

    return MilestoneAction.fromJson(response.data!);
  }

  Future<void> deleteAction(String id) async {
    await _client.call(HttpMethod.DELETE, path: '/roadmaps/action/$id');
  }

  Future<ActionResource> createActionResource(
      CreateActionResourceInput input) async {
    final response = await _client.call(HttpMethod.POST,
        path: '/roadmaps/resource', body: input.toMap());

    if (response.data == null) {
      throw Exception('Failed to create action resource');
    }

    return ActionResource.fromJson(response.data!);
  }

  Future<ActionResource> updateActionResource(
      EditActionResourceInput input) async {
    final response = await _client.call(HttpMethod.PUT,
        path: '/roadmaps/resource', body: input.toMap());

    if (response.data == null) {
      throw Exception('Failed to update action resource');
    }

    return ActionResource.fromJson(response.data!);
  }

  Future<void> deleteResource(String id) async {
    await _client.call(HttpMethod.DELETE, path: '/roadmaps/resource/$id');
  }

  Future<List<Roadmap>> uploadLocalRoadmaps(List<Roadmap> roadmaps) async {
    final response = await _client.call(HttpMethod.POST,
        path: '/roadmaps/uploadLocalRoadmaps', body: {
          'roadmaps': roadmaps.map((e) => e.toMap()).toList().toString(),
        });

    if (response.data == null) {
      throw Exception('Failed to upload roadmaps');
    }

    return List<Roadmap>.from(response.data!['roadmaps'].map((x) => Roadmap.fromJson(x)));
  }
}
