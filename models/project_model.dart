class ProjectModel {
  final String id;
  final String name;
  final String description;
  final String startDate;
  final String endDate;

  ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}
