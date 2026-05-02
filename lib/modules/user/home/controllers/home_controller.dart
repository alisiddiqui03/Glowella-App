import 'package:get/get.dart';
import '../../../../app/services/product_service.dart';
import '../../../../app/data/models/glow_product.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find<HomeController>();

  final _productService = ProductService.to;

  List<GlowProduct> get products => _productService.products;
  bool get isLoading => _productService.isLoading.value;

  final RxString selectedCategory = 'all'.obs;

  List<GlowProduct> get filteredProducts {
    if (selectedCategory.value == 'all') return products;
    return products
        .where((p) => p.category == selectedCategory.value)
        .toList();
  }
}
