import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../routes/app_routes.dart';
import '../../providers/inventory_provider.dart';
import '../../models/inventory_model.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  void initState() {
    super.initState();
    // Load inventory from Firestore for current employer
    Future.microtask(
      () => context.read<InventoryProvider>().fetchItems(),
    );
  }

  @override
  Widget build(BuildContext context) {
     final provider = context.watch<InventoryProvider>();
    final List<InventoryModel> items = provider.items;
    final loading = provider.loading;


    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 246, 246), // Dark Grey
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0), // Blue theme
        title: const Text(
          "Inventory",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        elevation: 6,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : items.isEmpty
                ? const Center(
                    child: Text(
                      "No inventory items yet.\nTap + to add one.",
                      textAlign: TextAlign.center,
                    ),
                  )
                : GridView.builder(
                    itemCount: items.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 cards per row
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                    ),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      // we use `location` field as status string ("In Stock", etc.)
                      final status = item.location;
                      final statusColor = _getStatusColor(status);

            return Card(
              color: const Color.fromARGB(255, 244, 241, 241),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.inventory_2,
                      size: 40,
                      color: Colors.blue.shade300,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 26, 7, 7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Qty: ${item.quantity}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(31, 13, 12, 12),
                      ),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Chip(
                        label: Text(
                          status,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 27, 16, 16),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: statusColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1565C0),
        elevation: 8,
        onPressed: () async {
          await Navigator.pushNamed(
            context,
            AppRoutes.addInventory,
          );

          // After returning from AddInventoryScreen, refresh list
          if (!mounted) return;
          context.read<InventoryProvider>().fetchItems();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Inventory updated")),
          );
        },
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "In Stock":
        return Colors.green;
      case "Low Stock":
        return Colors.orange;
      case "Out of Stock":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
