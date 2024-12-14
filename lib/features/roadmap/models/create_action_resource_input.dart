class CreateActionResourceInput {
  final String title;
  final String? url;
  final String? description;
  final String actionId;

  CreateActionResourceInput({
    required this.title,
    this.url,
    this.description,
    required this.actionId,
  });

  Map<String, String> toMap() {
    return {
      'title': title,
      'url': url ?? '',
      'description': description ?? '',
      'actionId': actionId,
    };
  }
}
