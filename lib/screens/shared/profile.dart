import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool editMode = false;

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);
    final emailController = TextEditingController(text: app.email);
    final phoneController = TextEditingController(text: app.phone);
    final addressController = TextEditingController(text: app.address);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(editMode ? Icons.check : Icons.edit),
            onPressed: () {
              if (editMode) {
                app.email = emailController.text;
                app.phone = phoneController.text;
                app.address = addressController.text;
              }
              setState(() => editMode = !editMode);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              enabled: editMode,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
              enabled: editMode,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Address'),
              enabled: editMode,
            ),
          ],
        ),
      ),
    );
  }
}
