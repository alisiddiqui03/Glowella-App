import 'package:get/get.dart';
import 'package:glowella/modules/user/cart/controllers/cart_controller.dart';
import '../../../../app/data/models/glow_product.dart';

class ProductDetailController extends GetxController {
  static ProductDetailController get to => Get.find<ProductDetailController>();

  late GlowProduct product;

  @override
  void onInit() {
    super.onInit();
    product = Get.arguments as GlowProduct;
  }

  void addToCart() {
    Get.find<CartController>().addToCart(product);
  }
}
