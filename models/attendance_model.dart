class AttendanceModel {
  final String id;
  final String workerId;
  final String date;
  final String checkInTime;
  final String checkOutTime;

  AttendanceModel({
    required this.id,
    required this.workerId,
    required this.date,
    required this.checkInTime,
    required this.checkOutTime,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'],
      workerId: json['workerId'],
      date: json['date'],
      checkInTime: json['checkInTime'],
      checkOutTime: json['checkOutTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workerId': workerId,
      'date': date,
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
    };
  }
}
