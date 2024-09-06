class EditLocalActionResourceInput {
  final String id;
  final String? title;
  final String? url;
  final String? description;

  EditLocalActionResourceInput({
    required this.id,
    this.title,
    this.url,
    this.description,
  });
}