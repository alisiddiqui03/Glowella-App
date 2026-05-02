import 'dart:async';
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
        products.assignAll(
          snap.docs
              .map((d) => GlowProduct.fromMap(d.id, d.data()))
              .toList(),
        );
        isLoading.value = false;
      },
      onError: (_) => isLoading.value = false,
    );
  }

  // Admin: all products (including inactive)
  Future<List<GlowProduct>> fetchAllAdmin() async {
    final snap = await FirestoreService.productsCollection
        .where('app', isEqualTo: 'glowvella')
        .orderBy('name')
        .get(const GetOptions(source: Source.server));
    return snap.docs
        .map((d) => GlowProduct.fromMap(d.id, d.data()))
        .toList();
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
    await FirestoreService.productsCollection
        .doc(productId)
        .update({'isActive': isActive});
  }

  Future<void> updateStock(String productId, int stock) async {
    await FirestoreService.productsCollection
        .doc(productId)
        .update({'stock': stock});
  }

  Future<void> deleteProduct(String productId) async {
    await FirestoreService.productsCollection.doc(productId).delete();
  }
}
