import 'package:get/get.dart';
import '../../../../app/data/models/glow_product.dart';
import '../../../../app/services/product_service.dart';
import '../../../../app/routes/app_pages.dart';

class AdminInventoryController extends GetxController {
  static AdminInventoryController get to => Get.find<AdminInventoryController>();

  final _productService = ProductService.to;

  final RxList<GlowProduct> products = <GlowProduct>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    isLoading.value = true;
    try {
      products.assignAll(await _productService.fetchAllAdmin());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleActive(GlowProduct product) async {
    await _productService.toggleActive(product.id, !product.isActive);
    await loadProducts();
  }

  Future<void> deleteProduct(GlowProduct product) async {
    await _productService.deleteProduct(product.id);
    products.remove(product);
    Get.snackbar('Deleted', '${product.name} removed');
  }

  void openAddProduct() =>
      Get.toNamed(Routes.ADMIN_PRODUCT_FORM);

  void openEditProduct(GlowProduct product) =>
      Get.toNamed(Routes.ADMIN_PRODUCT_FORM, arguments: product);
}
