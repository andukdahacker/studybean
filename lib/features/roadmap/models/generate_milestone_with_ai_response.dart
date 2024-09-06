import 'duration_unit.dart';

class GenerateMilestoneWithAiResponse {
  final List<GeneratedMilestone> milestones;

  GenerateMilestoneWithAiResponse({
    required this.milestones,
  });

  factory GenerateMilestoneWithAiResponse.fromJson(Map<String, dynamic> json) {
    return GenerateMilestoneWithAiResponse(
      milestones: List<GeneratedMilestone>.from(json['milestones']
          .map((milestone) => GeneratedMilestone.fromJson(milestone))),
    );
  }

  Map<String, dynamic> toJson() => {
        'milestones':
            milestones.map((milestone) => milestone.toJson()).toList(),
      };
}

class GeneratedActionResource {
  final String title;
  final String description;
  final String url;

  GeneratedActionResource(
      {required this.title, required this.description, required this.url});

  factory GeneratedActionResource.fromJson(Map<String, dynamic> json) {
    return GeneratedActionResource(
        title: json['title'],
        description: json['description'],
        url: json['url']);
  }

  Map<String, dynamic> toJson() =>
      {'title': title, 'description': description, 'url': url};
}

class GeneratedAction {
  final String name;
  final String description;
  final int duration;
  final DurationUnit durationUnit;
  final List<GeneratedActionResource> resource;

  GeneratedAction(
      {required this.name,
      required this.description,
      required this.duration,
      required this.durationUnit,
      required this.resource});

  factory GeneratedAction.fromJson(Map<String, dynamic> json) {
    return GeneratedAction(
        name: json['name'],
        description: json['description'],
        duration: json['duration'],
        durationUnit: DurationUnit.values
            .firstWhere((unit) => unit.value == json['durationUnit']),
        resource: List<GeneratedActionResource>.from(json['resource']
            .map((resource) => GeneratedActionResource.fromJson(resource))));
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'duration': duration,
        'durationUnit': durationUnit.value,
        'resource': resource.map((resource) => resource.toJson()).toList()
      };
}

class GeneratedMilestone {
  final int index;
  final String name;
  final List<GeneratedAction> actions;

  GeneratedMilestone(
      {required this.index, required this.name, required this.actions});

  factory GeneratedMilestone.fromJson(Map<String, dynamic> json) {
    return GeneratedMilestone(
        index: json['index'],
        name: json['name'],
        actions: List<GeneratedAction>.from(
            json['actions'].map((action) => GeneratedAction.fromJson(action))));
  }

  Map<String, dynamic> toJson() => {
        'index': index,
        'name': name,
        'actions': actions.map((action) => action.toJson()).toList()
      };
}
