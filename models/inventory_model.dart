class InventoryModel {
  final String id;
  final String name;
  final int quantity;
  final String location;

  InventoryModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.location,
  });

  /// Accept Firestore doc.id OR data['id']
  factory InventoryModel.fromJson(Map<String, dynamic> json, [String? id]) {
    return InventoryModel(
      id: id ?? json['id'] ?? '',
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
      location: json['location'] ?? '',
    );
  }

  /// Firestore document (no id inside)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'location': location,
    };
  }

  InventoryModel copyWith({
    String? id,
    String? name,
    int? quantity,
    String? location,
  }) {
    return InventoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      location: location ?? this.location,
    );
  }
}
