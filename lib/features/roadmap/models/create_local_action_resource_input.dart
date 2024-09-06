class CreateLocalActionResourceInput {
  final String title;
  final String url;
  final String? description;
  final String actionId;

  CreateLocalActionResourceInput({
    required this.title,
    required this.url,
    this.description,
    required this.actionId,
  });
}