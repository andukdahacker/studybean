class EditActionResourceInput {
  final String id;
  final String? title;
  final String? url;
  final String? description;

  EditActionResourceInput({
    required this.id,
    this.title,
    this.url,
    this.description,
  });


  Map<String, String> toMap() {
    return {
      'id': id,
      'title': title ?? '',
      'url': url ?? '',
      'description': description ?? '',
    };
  }
}