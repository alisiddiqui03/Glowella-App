import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/data/models/glow_product.dart';

class CartItem {
  final GlowProduct product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get lineTotal => product.price * quantity;
}

class CartController extends GetxController {
  static CartController get to => Get.find<CartController>();

  final RxList<CartItem> items = <CartItem>[].obs;

  int get totalItems => items.fold(0, (s, i) => s + i.quantity);
  double get subtotal => items.fold(0, (s, i) => s + i.lineTotal);

  void addToCart(GlowProduct product) {
    final idx = items.indexWhere((i) => i.product.id == product.id);
    if (idx >= 0) {
      items[idx].quantity++;
      items.refresh();
    } else {
      items.add(CartItem(product: product));
    }

    Get.closeAllSnackbars();
    Get.snackbar(
      'Added to Cart 🛒',
      '${product.name} has been added to your cart.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      colorText: const Color(0xFF1E293B),
      borderRadius: 16,
      margin: const EdgeInsets.all(16),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
      icon: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF16A34A).withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check_rounded, color: Color(0xFF16A34A)),
      ),
      duration: const Duration(seconds: 2),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutCirc,
    );
  }

  void increment(String productId) {
    final idx = items.indexWhere((i) => i.product.id == productId);
    if (idx >= 0) {
      items[idx].quantity++;
      items.refresh();
    }
  }

  void decrement(String productId) {
    final idx = items.indexWhere((i) => i.product.id == productId);
    if (idx >= 0) {
      if (items[idx].quantity <= 1) {
        items.removeAt(idx);
      } else {
        items[idx].quantity--;
        items.refresh();
      }
    }
  }

  void remove(String productId) {
    items.removeWhere((i) => i.product.id == productId);
  }

  void clear() => items.clear();
}
