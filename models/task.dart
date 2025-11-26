class TaskModel {
  final String id;
  final String title;
  final String description;
  final String assignedTo; // worker id
  final String projectId;
  final String status; // "Pending", "In Progress", "Completed"

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.projectId,
    required this.status,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      assignedTo: json['assignedTo'],
      projectId: json['projectId'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'assignedTo': assignedTo,
      'projectId': projectId,
      'status': status,
    };
  }
}
