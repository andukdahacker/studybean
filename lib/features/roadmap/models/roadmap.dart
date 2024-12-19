import 'dart:convert';

import 'package:studybean/features/roadmap/models/dummy.dart';
import 'package:studybean/features/roadmap/models/subject.dart';

import '../../auth/models/user.dart';
import 'duration_unit.dart';

class Roadmap {
  final String id;
  final String subjectId;
  final Subject? subject;
  final List<Milestone>? milestones;
  final String? userId;
  final User? user;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String goal;

  Roadmap({
    required this.id,
    required this.subjectId,
    required this.goal,
    required this.createdAt,
    required this.updatedAt,
    this.userId,
    this.user,
    this.subject,
    this.milestones,
  });

  Roadmap copyWith({
    String? id,
    String? userId,
    Subject? subject,
    String? deadline,
    List<Milestone>? milestones,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? goal,
    String? subjectId,
  }) =>
      Roadmap(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        subject: subject ?? this.subject,
        subjectId: subjectId ?? this.subjectId,
        milestones: milestones ?? this.milestones,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        goal: goal ?? this.goal,
      );

  factory Roadmap.fromRawJson(String str) => Roadmap.fromJson(json.decode(str));

  static List<Roadmap> get examples {
    return [Roadmap.fromJson(dsaExample), Roadmap.fromJson(bassGuitarExample)];
  }

  String toRawJson() => json.encode(toJson());

  factory Roadmap.fromJson(Map<String, dynamic> json) => Roadmap(
        id: json["id"],
        subjectId: json["subjectId"],
        subject:
            json["subject"] == null ? null : Subject.fromJson(json["subject"]),
        milestones: json["milestone"] == null
            ? []
            : List<Milestone>.from(
                json["milestone"]!.map((x) => Milestone.fromJson(x))),
        userId: json["userId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        goal: json["goal"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subjectId": subjectId,
        "goal": goal,
        "subject": subject,
        "milestone": milestones == null
            ? []
            : List<dynamic>.from(milestones!.map((x) => x.toJson())),
        "userId": userId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };

  Map<String, String> toMap() => {
        'id': id,
        'subjectId': subjectId,
        'goal': goal,
        'userId': userId ?? '',
        'subject': subject?.toMap().toString() ?? '',
        'milestone':
            milestones?.map((milestone) => milestone.toMap()).toString() ?? '',
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

class Milestone {
  final String id;
  final int index;
  final String name;
  final String roadmapId;
  final List<MilestoneAction>? actions;

  int get duration {
    if (actions == null || actions!.isEmpty) {
      return 0;
    }
    int sumOfDays = 0;
    for (var goal in actions!) {
      final durationUnit = goal.durationUnit;
      switch (durationUnit) {
        case DurationUnit.day:
          sumOfDays += goal.duration;
          break;
        case DurationUnit.week:
          sumOfDays += goal.duration * 7;
          break;
        case DurationUnit.month:
          sumOfDays += goal.duration * 30;
        case DurationUnit.year:
          sumOfDays += goal.duration * 365;
          break;
      }
    }

    return sumOfDays;
  }

  String get durationText {
    if (actions == null || actions!.isEmpty) {
      return '';
    }
    int sumOfDays = 0;
    for (var goal in actions!) {
      final durationUnit = goal.durationUnit;
      switch (durationUnit) {
        case DurationUnit.day:
          sumOfDays += goal.duration;
          break;
        case DurationUnit.week:
          sumOfDays += goal.duration * 7;
          break;
        case DurationUnit.month:
          sumOfDays += goal.duration * 30;
        case DurationUnit.year:
          sumOfDays += goal.duration * 365;
          break;
      }
    }

    final yearNum = sumOfDays ~/ 365;
    final remainDaysAfterYear = sumOfDays % 365;

    final monthNum = remainDaysAfterYear ~/ 30;
    final remainDaysAfterMonth = remainDaysAfterYear % 30;

    final weekNum = remainDaysAfterMonth ~/ 7;
    final remainDaysAfterWeek = remainDaysAfterMonth % 7;

    return '${yearNum > 0 ? '$yearNum years' : ''} ${monthNum > 0 ? '$monthNum months' : ''} ${weekNum > 0 ? '$weekNum weeks' : ''} ${remainDaysAfterWeek > 0 ? '$remainDaysAfterWeek days' : ''}';
  }

  Milestone({
    required this.id,
    required this.index,
    required this.name,
    required this.roadmapId,
    this.actions,
  });

  Milestone copyWith({
    String? id,
    int? index,
    String? name,
    String? roadmapId,
    List<MilestoneAction>? actions,
  }) =>
      Milestone(
        id: id ?? this.id,
        index: index ?? this.index,
        name: name ?? this.name,
        actions: actions ?? this.actions,
        roadmapId: roadmapId ?? this.roadmapId,
      );

  factory Milestone.fromRawJson(String str) =>
      Milestone.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Milestone.fromJson(Map<String, dynamic> json) => Milestone(
        id: json['id'],
        index: json['index'] ?? json['position'],
        name: json["name"],
        actions: json["action"] == null
            ? []
            : List<MilestoneAction>.from(
                json["action"]!.map((x) => MilestoneAction.fromJson(x))),
        roadmapId: json["roadmapId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "index": index,
        "name": name,
        "action": actions == null
            ? []
            : List<dynamic>.from(actions!.map((x) => x.toJson())),
        "roadmapId": roadmapId,
      };

  Map<String, String> toMap() => {
        'id': id,
        'index': index.toString(),
        'name': name,
        'roadmapId': roadmapId,
        'actions': actions!.map((e) => e.toMap()).toList().toString(),
      };
}

class MilestoneAction {
  final String id;
  final String milestoneId;
  final String name;
  final String? description;
  final List<ActionResource>? resource;
  final DateTime? deadline;
  final bool completed;
  final int duration;
  final DurationUnit durationUnit;

  MilestoneAction({
    required this.id,
    required this.name,
    required this.milestoneId,
    required this.duration,
    required this.durationUnit,
    required this.completed,
    this.description,
    this.resource,
    this.deadline,
  });

  MilestoneAction copyWith({
    String? id,
    String? milestoneId,
    String? description,
    String? name,
    List<ActionResource>? resource,
    DateTime? deadline,
    bool? completed,
    int? duration,
    DurationUnit? durationUnit,
  }) =>
      MilestoneAction(
        id: id ?? this.id,
        milestoneId: milestoneId ?? this.milestoneId,
        description: description ?? this.description,
        name: name ?? this.name,
        resource: resource ?? this.resource,
        deadline: deadline ?? this.deadline,
        completed: completed ?? this.completed,
        duration: duration ?? this.duration,
        durationUnit: durationUnit ?? this.durationUnit,
      );

  factory MilestoneAction.fromRawJson(String str) =>
      MilestoneAction.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MilestoneAction.fromJson(Map<String, dynamic> json) {
    bool completed = false;

    if (json['isCompleted'] != null) {
      if (json['isCompleted'] is bool) {
        completed = json['isCompleted'];
      } else if (json['isCompleted'] is int) {
        completed = json['isCompleted'] == 1;
      }
    }

    return MilestoneAction(
      id: json["id"],
      milestoneId: json["milestoneId"],
      description: json["description"],
      name: json["name"],
      resource: json["resource"] == null
          ? []
          : List<ActionResource>.from(
              json["resource"]!.map((x) => ActionResource.fromJson(x))),
      deadline:
          json["deadline"] == null ? null : DateTime.parse(json["deadline"]),
      completed: completed,
      duration: json["duration"],
      durationUnit: DurationUnit.fromValue(json["durationUnit"])!,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "milestoneId": milestoneId,
        "description": description,
        "resource": resource == null
            ? []
            : List<dynamic>.from(resource!.map((x) => x.toJson())),
        "deadline": deadline?.toIso8601String(),
        "completed": completed,
        "duration": duration,
        "durationUnit": durationUnit.value,
      };

  Map<String, String> toMap() => {
        'id': id,
        'milestoneId': milestoneId,
        'name': name,
        'description': description ?? '',
        'duration': duration.toString(),
        'durationUnit': durationUnit.value,
        'deadline': deadline?.toIso8601String() ?? '',
        'completed': completed ? '1' : '0',
        'resource': resource == null
            ? ''
            : resource!.map((x) => x.toMap()).toList().toString(),
      };
}

class ActionResource {
  final String id;
  final String actionId;
  final String title;
  final String? description;
  final String url;
  final ResourceType resourceType;

  ActionResource({
    required this.id,
    required this.title,
    required this.actionId,
    this.description,
    required this.url,
    required this.resourceType,
  });

  ActionResource copyWith({
    String? id,
    String? title,
    String? description,
    String? url,
    String? actionId,
    ResourceType? resourceType,
  }) =>
      ActionResource(
        id: id ?? this.id,
        actionId: actionId ?? this.actionId,
        title: title ?? this.title,
        description: description ?? this.description,
        url: url ?? this.url,
        resourceType: resourceType ?? this.resourceType,
      );

  factory ActionResource.fromRawJson(String str) =>
      ActionResource.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ActionResource.fromJson(Map<String, dynamic> json) => ActionResource(
        id: json["id"],
        actionId: json["actionId"],
        title: json["title"],
        description: json["description"],
        url: json["url"],
        resourceType: ResourceType.of(json["resourceType"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "actionId": actionId,
        "title": title,
        "description": description,
        "url": url,
        "resourceType": resourceType,
      };

  Map<String, String> toMap() => {
        'id': id,
        'actionId': actionId,
        'title': title,
        'description': description ?? '',
        'url': url,
        'resourceType': resourceType.value,
      };
}

enum ResourceType {
  pdf(label: 'Select a PDF', value: 'PDF'),
  image(
    label: 'Select an image',
    value: 'IMAGE',
  ),
  websiteLink(label: 'Paste a website link', value: 'WEBSITE'),
  youtubeLink(label: 'Paste a YouTube link', value: 'YOUTUBE'),
  ;

  const ResourceType({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  static ResourceType of(String value) {
    return ResourceType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ResourceType.websiteLink,
    );
  }
}
