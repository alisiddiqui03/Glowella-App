import 'package:get/get.dart';
import '../../../../app/data/models/glow_product.dart';
import '../../../../app/services/product_service.dart';

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
    Get.snackbar(
      'Added to Cart',
      '${product.name} added',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
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
