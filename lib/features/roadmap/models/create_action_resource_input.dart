import 'package:studybean/features/roadmap/models/roadmap.dart';

class CreateActionResourceInput {
  final String title;
  final String? url;
  final String? description;
  final String actionId;
  final ResourceType resourceType;

  CreateActionResourceInput({
    required this.title,
    this.url,
    this.description,
    required this.actionId,
    required this.resourceType,
  });

  Map<String, String> toMap() {
    return {
      'title': title,
      'url': url ?? '',
      'description': description ?? '',
      'actionId': actionId,
      'resourceType': resourceType.value,
    };
  }
}
