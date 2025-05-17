class TopicModel {
  final String id;
  final String name;
  final String description;

  TopicModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory TopicModel.fromMap(String id, Map<String, dynamic> data) {
    return TopicModel(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
    );
  }
}
