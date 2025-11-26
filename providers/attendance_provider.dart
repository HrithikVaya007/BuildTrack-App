import 'package:flutter/material.dart';
import '../models/attendance_model.dart';
import '../services/attendance_service.dart';

class AttendanceProvider with ChangeNotifier {
  final AttendanceService _attendanceService = AttendanceService();

  List<AttendanceModel> _attendanceList = [];
  List<AttendanceModel> get attendanceList => _attendanceList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// 🔄 Helper
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// 🚀 Fetch all attendance
  Future<void> fetchAttendance() async {
    _setLoading(true);

    try {
      _attendanceList = await _attendanceService.getAllAttendance();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _setLoading(false);
  }

  /// 🔍 Fetch attendance for specific worker
  Future<void> fetchAttendanceByWorker(String workerId) async {
    _setLoading(true);

    try {
      _attendanceList =
          await _attendanceService.getAttendanceByWorker(workerId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _setLoading(false);
  }

  /// 🆕 Add new attendance entry
  Future<bool> addAttendance(AttendanceModel attendance) async {
    _setLoading(true);

    try {
      final newRecord =
          await _attendanceService.createAttendance(attendance);

      _attendanceList.add(newRecord);
      notifyListeners();

      _errorMessage = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// ✏️ Update existing attendance
  Future<bool> updateAttendance(String id, AttendanceModel attendance) async {
    _setLoading(true);

    try {
      final updatedRecord =
          await _attendanceService.updateAttendance(id, attendance);

      int index = _attendanceList.indexWhere((a) => a.id == id);
      if (index != -1) {
        _attendanceList[index] = updatedRecord;
      }

      notifyListeners();

      _errorMessage = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// 🗑 Delete attendance record
  Future<bool> deleteAttendance(String id) async {
    _setLoading(true);

    try {
      bool success = await _attendanceService.deleteAttendance(id);

      if (success) {
        _attendanceList.removeWhere((a) => a.id == id);
        notifyListeners();
      }

      _errorMessage = null;
      _setLoading(false);
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }
}
