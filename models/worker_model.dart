class WorkerModel {
  final String id;
  final String name;
  final String phone;
  final String position;
  final String assignedProject;

  WorkerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.position,
    required this.assignedProject,
  });

  factory WorkerModel.fromJson(Map<String, dynamic> json) {
    return WorkerModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      position: json['position'],
      assignedProject: json['assignedProject'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'position': position,
      'assignedProject': assignedProject,
    };
  }
}
