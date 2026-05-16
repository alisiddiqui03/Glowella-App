import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/models/glow_product.dart';
import 'firestore_service.dart';

class ProductService extends GetxService {
  ProductService();

  static ProductService get to => Get.find<ProductService>();

  final RxList<GlowProduct> products = <GlowProduct>[].obs;
  final RxBool isLoading = true.obs;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _sub;

  @override
  void onInit() {
    super.onInit();
    _loadLocalMockProducts(); // Load mock data immediately as a fallback
    _bindStream();
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }

  void _bindStream() {
    _sub = FirestoreService.productsCollection
        .where('app', isEqualTo: 'glowvella')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .listen(
          (snap) {
            debugPrint('Product Snapshot: ${snap.docs.length} docs found');
            if (snap.docs.isNotEmpty) {
              products.assignAll(
                snap.docs
                    .map((d) => GlowProduct.fromMap(d.id, d.data()))
                    .toList(),
              );
            } else {
              // If Firestore is empty, we keep the mock data loaded in onInit
              debugPrint('Firestore empty or untagged, keeping mock products');
              if (products.isEmpty) _loadLocalMockProducts();
            }
            isLoading.value = false;
          },
          onError: (err) {
            debugPrint('Product Stream Error: $err');
            if (products.isEmpty) _loadLocalMockProducts();
            isLoading.value = false;
          },
        );
  }

  Future<void> seedProductsIfNeeded() async {
    final batch = FirebaseFirestore.instance.batch();

    final seedData = [
      {
        'name': 'Glowella Hydrating Cleanser',
        'description':
            'Creamy Face Wash\nVolume: 120ml\nMain Actives: Glycerin + Glycolic Acid',
        'price': 2200.0,
        'imageUrls': [
          'assets/images/Hydrating Cleanser.jpeg',
          'assets/images/Hydrating Cleanser2.jpeg',
        ],
        'category': 'cleanser',
      },
      {
        'name': 'Glowella Liquid Exfoliant',
        'description':
            'Glycolic Acid Toner\nVolume: 100ml\nMain Actives: 7% Glycolic Acid',
        'price': 2400.0,
        'imageUrls': [
          'assets/images/Liquid Exfoliant.jpeg',
          'assets/images/Liquid Exfoliant2.jpeg',
        ],
        'category': 'toner',
      },
      {
        'name': 'Glowella Hydration Booster',
        'description':
            'Hyaluronic Acid Serum\nVolume: 30ml\nMain Actives: Pure Sodium Hyaluronate',
        'price': 2400.0,
        'imageUrls': [
          'assets/images/Hydration Booster.jpeg',
          'assets/images/Hydration Booster2.jpeg',
        ],
        'category': 'serum',
      },
      {
        'name': 'Glowella Barrier Support',
        'description':
            'Niacinamide Serum\nVolume: 30ml\nMain Actives: 10% Niacinamide + 1% Zinc',
        'price': 2400.0,
        'imageUrls': [
          'assets/images/Barrier Support.jpeg',
          'assets/images/Barrier Support2.jpeg',
        ],
        'category': 'serum',
      },
      {
        'name': 'Glowella Advanced Brightener',
        'description':
            'Lucent Glow Cream\nWeight: 50g\nMain Actives: Alpha Arbutin + Glutathione + Vitamin C (SAP)',
        'price': 2200.0,
        'imageUrls': [
          'assets/images/Advanced Brightener.jpeg',
          'assets/images/Advanced Brightener2.jpeg',
        ],
        'category': 'cream',
      },
      {
        'name': 'Glowella Night Repair Complex',
        'description':
            'Anti-Aging Cream\nWeight: 50g\nMain Actives: Retinol + Collagen Peptides',
        'price': 2500.0,
        'imageUrls': [
          'assets/images/Night Repair Complex.jpeg',
          'assets/images/Night Repair Complex2.jpeg',
        ],
        'category': 'cream',
      },
      {
        'name': 'Glowella UV Protector',
        'description':
            'Sun Block SPF 60\nVolume: 50ml\nMain Actives: Broad Spectrum UVA/UVB Filters',
        'price': 2500.0,
        'imageUrls': [
          'assets/images/UV Protector.jpeg',
          'assets/images/UV Protector2.jpeg',
        ],
        'category': 'sunblock',
      },
    ];

    for (var prod in seedData) {
      final docRef = FirestoreService.productsCollection.doc();
      batch.set(docRef, {
        ...prod,
        'stock': 100,
        'isActive': true,
        'app': 'glowvella',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    try {
      await batch.commit();
    } catch (e) {
      // Ignore if permission denied or fails
    }
  }

  void _loadLocalMockProducts() {
    final mockData = [
      {
        'id': 'prod_cleanser',
        'name': 'Glowella Hydrating Cleanser',
        'description':
            'Creamy Face Wash\nVolume: 120ml\nMain Actives: Glycerin + Glycolic Acid',
        'price': 2200.0,
        'imageUrls': [
          'assets/images/Hydrating Cleanser.jpeg',
          'assets/images/Hydrating Cleanser2.jpeg',
        ],
        'category': 'cleanser',
      },
      {
        'id': 'prod_toner',
        'name': 'Glowella Liquid Exfoliant',
        'description':
            'Glycolic Acid Toner\nVolume: 100ml\nMain Actives: 7% Glycolic Acid',
        'price': 2400.0,
        'imageUrls': [
          'assets/images/Liquid Exfoliant.jpeg',
          'assets/images/Liquid Exfoliant2.jpeg',
        ],
        'category': 'toner',
      },
      {
        'id': 'prod_serum_hb',
        'name': 'Glowella Hydration Booster',
        'description':
            'Hyaluronic Acid Serum\nVolume: 30ml\nMain Actives: Pure Sodium Hyaluronate',
        'price': 2400.0,
        'imageUrls': [
          'assets/images/Hydration Booster.jpeg',
          'assets/images/Hydration Booster2.jpeg',
        ],
        'category': 'serum',
      },
      {
        'id': 'prod_serum_bs',
        'name': 'Glowella Barrier Support',
        'description':
            'Niacinamide Serum\nVolume: 30ml\nMain Actives: 10% Niacinamide + 1% Zinc',
        'price': 2400.0,
        'imageUrls': [
          'assets/images/Barrier Support.jpeg',
          'assets/images/Barrier Support2.jpeg',
        ],
        'category': 'serum',
      },
      {
        'id': 'prod_cream_ab',
        'name': 'Glowella Advanced Brightener',
        'description':
            'Lucent Glow Cream\nWeight: 50g\nMain Actives: Alpha Arbutin + Glutathione + Vitamin C (SAP)',
        'price': 2200.0,
        'imageUrls': [
          'assets/images/Advanced Brightener.jpeg',
          'assets/images/Advanced Brightener2.jpeg',
        ],
        'category': 'cream',
      },
      {
        'id': 'prod_cream_nr',
        'name': 'Glowella Night Repair Complex',
        'description':
            'Anti-Aging Cream\nWeight: 50g\nMain Actives: Retinol + Collagen Peptides',
        'price': 2500.0,
        'imageUrls': [
          'assets/images/Night Repair Complex.jpeg',
          'assets/images/Night Repair Complex2.jpeg',
        ],
        'category': 'cream',
      },
      {
        'id': 'prod_sunblock_uv',
        'name': 'Glowella UV Protector',
        'description':
            'Sun Block SPF 60\nVolume: 50ml\nMain Actives: Broad Spectrum UVA/UVB Filters',
        'price': 2500.0,
        'imageUrls': [
          'assets/images/UV Protector.jpeg',
          'assets/images/UV Protector2.jpeg',
        ],
        'category': 'sunblock',
      },
    ];

    products.assignAll(
      mockData.map((d) {
        final id = d['id'] as String;
        return GlowProduct.fromMap(id, {
          ...d,
          'stock': 100,
          'isActive': true,
          'app': 'glowvella',
          'createdAt': Timestamp.now(),
          'updatedAt': Timestamp.now(),
        });
      }).toList(),
    );
  }

  // Admin: all products (including inactive)
  Future<List<GlowProduct>> fetchAllAdmin() async {
    final snap = await FirestoreService.productsCollection
        .where('app', isEqualTo: 'glowvella')
        .orderBy('name')
        .get(const GetOptions(source: Source.server));
    return snap.docs.map((d) => GlowProduct.fromMap(d.id, d.data())).toList();
  }

  Future<String> addProduct(GlowProduct product) async {
    final doc = await FirestoreService.productsCollection.add({
      ...product.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Future<void> updateProduct(GlowProduct product) async {
    await FirestoreService.productsCollection
        .doc(product.id)
        .update(product.toMap());
  }

  Future<void> toggleActive(String productId, bool isActive) async {
    await FirestoreService.productsCollection.doc(productId).update({
      'isActive': isActive,
    });
  }

  Future<void> updateStock(String productId, int stock) async {
    await FirestoreService.productsCollection.doc(productId).update({
      'stock': stock,
    });
  }

  Future<void> deleteProduct(String productId) async {
    await FirestoreService.productsCollection.doc(productId).delete();
  }
}
