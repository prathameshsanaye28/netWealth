class Job {
  final String id;
  final String title;
  final String description;
  final List<String> requiredSkills;

  Job({
    required this.id,
    required this.title,
    required this.description,
    this.requiredSkills = const [],
  });

  factory Job.fromMap(Map<String, dynamic> map, String id) {
    return Job(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      requiredSkills: List<String>.from(map['requiredSkills'] ?? []),
    );
  }
}