import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/project_model.dart';
import '../../providers/project_provider.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  String _projectName = "";
  String _description = "";
  DateTime? _startDate;
  DateTime? _endDate;

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          _startDateController.text = "${picked.toLocal()}".split(' ')[0];
        } else {
          _endDate = picked;
          _endDateController.text = "${picked.toLocal()}".split(' ')[0];
        }
      });
    }
  }

  Future<void> _saveProject() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final projectProvider = context.read<ProjectProvider>();

    // 🔹 Right now our ProjectModel in Firestore only stores basic info.
    //     Dates are used only in UI (like earlier when you popped a Map).
    //     If you later add start/end to ProjectModel, you can extend this.
    final project = ProjectModel(
      id: '',                 // Firestore doc.id will replace this
      name: _projectName,
      description: _description,
      startDate: _startDateController.text, // 👈 added
      endDate: _endDateController.text, 
      // employerId is filled inside ProjectService using FirebaseAuth uid
    );

    final ok = await projectProvider.addProject(project);

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Project created successfully')),
      );
      Navigator.pop(context); // back to previous screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(projectProvider.error ?? 'Failed to create project'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // light background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        title: const Text(
          "Create Project",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputField(
                label: "Project Name",
                validator: (value) =>
                    value!.isEmpty ? "Enter project name" : null,
                onSaved: (value) => _projectName = value!,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                label: "Description",
                maxLines: 3,
                validator: (value) =>
                    value!.isEmpty ? "Enter description" : null,
                onSaved: (value) => _description = value!,
              ),
              const SizedBox(height: 16),
              _buildDateField(
                controller: _startDateController,
                label: "Start Date",
                onTap: () => _pickDate(context, true),
              ),
              const SizedBox(height: 16),
              _buildDateField(
                controller: _endDateController,
                label: "End Date",
                onTap: () => _pickDate(context, false),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _saveProject,
                child: const Text(
                  "Save Project",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    int maxLines = 1,
    String? Function(String?)? validator,
    Function(String?)? onSaved,
  }) {
    return TextFormField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required VoidCallback onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
      onTap: onTap,
    );
  }
}
