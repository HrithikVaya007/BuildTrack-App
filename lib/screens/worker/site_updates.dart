import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';

class SiteUpdates extends StatelessWidget {
  const SiteUpdates({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);

    final TextEditingController updateController = TextEditingController();

    void addUpdateDialog() {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Add Site Update'),
          content: TextField(
            controller: updateController,
            decoration: const InputDecoration(labelText: 'Update'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final update = updateController.text.trim();
                if (update.isNotEmpty) {
                  app.addSiteUpdate(update);
                  Navigator.pop(ctx);
                  updateController.clear();
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Site Updates')),
      body: app.siteUpdates.isEmpty
          ? const Center(child: Text('No site updates yet.'))
          : ListView.separated(
              itemCount: app.siteUpdates.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (ctx, i) {
                final update = app.siteUpdates[i];
                return ListTile(
                  leading: const Icon(Icons.announcement),
                  title: Text(update),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => app.removeSiteUpdate(i),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: addUpdateDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
