import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/worker_provider.dart';
import '../../providers/attendance_provider.dart';
import '../../models/worker_model.dart';
import '../../models/attendance_model.dart';

class AttendanceViewScreen extends StatefulWidget {
  const AttendanceViewScreen({super.key});

  @override
  State<AttendanceViewScreen> createState() => _AttendanceViewScreenState();
}

class _AttendanceViewScreenState extends State<AttendanceViewScreen> {
  DateTime _selectedDate = DateTime.now();

  // workerId -> present? (true / false / null)
  final Map<String, bool?> _marks = {};

   @override
  void initState() {
    super.initState();
    // load workers for current employer
    Future.microtask(
      () => context.read<WorkerProvider>().fetchWorkers(),
    );
  }

 

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1565C0), // Blue theme
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveAttendance() async {
    final workerProvider = context.read<WorkerProvider>();
    final attendanceProvider = context.read<AttendanceProvider>();
    final workers = workerProvider.workers;

    if (workers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No workers to mark attendance.")),
      );
      return;
    }

    final dateStr = _selectedDate.toLocal().toString().split(' ')[0];
    final now = TimeOfDay.now();
    final timeStr = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    // Create attendance records for all PRESENT workers
    bool anyMarked = false;
    for (final w in workers) {
      final present = _marks[w.id];
      if (present == true) {
        anyMarked = true;
        final record = AttendanceModel(
          id: '',
          workerId: w.id,
          date: dateStr,
          checkInTime: timeStr,
          checkOutTime: '',
        );
        await attendanceProvider.addAttendance(record);
      }
    }

    if (!mounted) return;

    if (!anyMarked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mark at least one worker as present.")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Attendance Saved")),
    );
  }



  @override
  Widget build(BuildContext context) {
    final workerProvider = context.watch<WorkerProvider>();
    final workers = workerProvider.workers;
    final loading = workerProvider.loading;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 246, 246), // Light grey
      appBar: AppBar(
        title: const Text(
          "Attendance",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1565C0), // Blue theme
        elevation: 6,
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range, color: Colors.white),
            onPressed: () => _pickDate(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: const Color.fromARGB(255, 244, 241, 241),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Text(
                "Date: ${_selectedDate.toLocal().toString().split(' ')[0]}",
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Divider(color: Colors.grey),
              Expanded(
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : workers.isEmpty
                        ? const Center(
                            child: Text(
                              "No workers found.\nAdd workers to mark attendance.",
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            itemCount: workers.length,
                            itemBuilder: (context, index) {
                              final WorkerModel w = workers[index];
                              final present = _marks[w.id];

                              return _AttendanceTile(
                                name: w.name,
                                present: present,
                                onMark: (bool value) {
                                  setState(() {
                                    _marks[w.id] = value;
                                  });
                                },
                              );
                            },
                          ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF1565C0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 8,
                  ),
                  onPressed: _saveAttendance,
                  child: const Text(
                    "Save Attendance",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttendanceTile extends StatelessWidget {
  final String name;
  final bool? present;
  final Function(bool) onMark;

  const _AttendanceTile({
    required this.name,
    required this.present,
    required this.onMark,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 255, 255, 255),
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFF1565C0),
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(
          name,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.check_circle,
                color: present == true ? Colors.green : Colors.grey,
              ),
              onPressed: () => onMark(true),
            ),
            IconButton(
              icon: Icon(
                Icons.cancel,
                color: present == false ? Colors.red : Colors.grey,
              ),
              onPressed: () => onMark(false),
            ),
          ],
        ),
      ),
    );
  }
}
