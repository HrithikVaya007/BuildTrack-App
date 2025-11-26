import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/worker_model.dart';
import '../../providers/worker_provider.dart';

class AddWorkerScreen extends StatefulWidget {
  const AddWorkerScreen({super.key});

  @override
  State<AddWorkerScreen> createState() => _AddWorkerScreenState();
}

class _AddWorkerScreenState extends State<AddWorkerScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _wageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _phoneController.dispose();
    _wageController.dispose();
    super.dispose();
  }

  Future<void> _saveWorker() async {
    if (!_formKey.currentState!.validate()) return;

    final workerProvider = context.read<WorkerProvider>();
    final wage = double.tryParse(_wageController.text.trim()) ?? 0;


    final worker = WorkerModel(
      id: '', // Firestore will assign doc.id
      name: _nameController.text.trim(),
      position: _roleController.text.trim(),
      phone: _phoneController.text.trim(),
      assignedProject: "", // initially unassigned
      dailyWage: wage, // 👈 now stored in Firestore
    );

    final success = await workerProvider.addWorker(worker);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Worker Added Successfully")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(workerProvider.error ?? "Failed to add worker"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "Add Worker",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1565C0),
        elevation: 6,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          color: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Worker Details",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E2E2E),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Worker Name
                  _CustomTextField(
                    label: "Full Name",
                    icon: Icons.person,
                    controller: _nameController,
                    validator: (v) =>
                        v!.isEmpty ? "Enter worker name" : null,
                  ),

                  // Worker Role
                  _CustomTextField(
                    label: "Role / Position",
                    icon: Icons.work,
                    controller: _roleController,
                    validator: (v) =>
                        v!.isEmpty ? "Enter worker role/position" : null,
                  ),

                  // Contact Number
                  _CustomTextField(
                    label: "Contact Number",
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    controller: _phoneController,
                    validator: (v) =>
                        v!.isEmpty ? "Enter contact number" : null,
                  ),

                  // Daily Wage
                 _CustomTextField(
  controller: _wageController,
  label: "Daily Wage (₹)",
  icon: Icons.attach_money,
  keyboardType: TextInputType.number,
),

                  const SizedBox(height: 30),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: const Color(0xFF1565C0),
                      shadowColor: Colors.black.withOpacity(0.3),
                      elevation: 6,
                    ),
                    onPressed: _saveWorker,
                    child: const Text(
                      "Add Worker",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom TextField widget updated to accept controller + validator
class _CustomTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const _CustomTextField({
    required this.label,
    required this.icon,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        style: const TextStyle(color: Color(0xFF2E2E2E)),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black54),
          prefixIcon: Icon(icon, color: Color(0xFF1565C0)),
          filled: true,
          fillColor: const Color(0xFFF9F9F9),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
          ),
        ),
      ),
    );
  }
}
