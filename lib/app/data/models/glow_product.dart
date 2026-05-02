import 'package:cloud_firestore/cloud_firestore.dart';

class GlowProduct {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> imageUrls;
  final String category;
  final int stock;
  final bool isActive;
  final String app; // always "glowvella"
  final DateTime? createdAt;
  final DateTime? updatedAt;

  String get imageUrl => imageUrls.isNotEmpty ? imageUrls.first : '';

  const GlowProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrls,
    required this.category,
    this.stock = 0,
    this.isActive = true,
    this.app = 'glowvella',
    this.createdAt,
    this.updatedAt,
  });

  factory GlowProduct.fromMap(String id, Map<String, dynamic> data) {
    final raw = data['imageUrls'];
    List<String> urls = [];
    if (raw is List) {
      urls = raw.map((e) => e.toString()).where((s) => s.isNotEmpty).toList();
    } else {
      final legacy = data['imageUrl'] as String?;
      if (legacy != null && legacy.isNotEmpty) urls = [legacy];
    }
    return GlowProduct(
      id: id,
      name: data['name'] as String? ?? 'Unnamed',
      description: data['description'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0,
      imageUrls: urls,
      category: data['category'] as String? ?? 'skincare',
      stock: (data['stock'] as num?)?.toInt() ?? 0,
      isActive: data['isActive'] as bool? ?? true,
      app: data['app'] as String? ?? 'glowvella',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrls': imageUrls,
      'imageUrl': imageUrl,
      'category': category,
      'stock': stock,
      'isActive': isActive,
      'app': 'glowvella',
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  GlowProduct copyWith({
    String? name,
    String? description,
    double? price,
    List<String>? imageUrls,
    String? category,
    int? stock,
    bool? isActive,
  }) {
    return GlowProduct(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrls: imageUrls ?? this.imageUrls,
      category: category ?? this.category,
      stock: stock ?? this.stock,
      isActive: isActive ?? this.isActive,
      app: app,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
