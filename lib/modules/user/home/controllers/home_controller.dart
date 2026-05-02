import 'package:get/get.dart';
import '../../../../app/services/product_service.dart';
import '../../../../app/data/models/glow_product.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find<HomeController>();

  final _productService = ProductService.to;

  final RxList<GlowProduct> featuredProducts = <GlowProduct>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadFeatured();
  }

  void _loadFeatured() {
    // These will eventually come from Firestore, but mapping them for the demo
    featuredProducts.assignAll([
      GlowProduct(
        id: 'p1',
        name: 'Barrier Support Serum',
        description: '10% Niacinamide + 1% Zinc. Oil control & blemish correction. 30ml.',
        price: 1850,
        imageUrls: ['assets/images/barrier_serum.png'],
        category: 'serums',
        stock: 50,
        isActive: true,
        app: 'glowvella',
      ),
      GlowProduct(
        id: 'p2',
        name: 'Hydrating Cleanser',
        description: 'Creamy Face Wash with Glycerin + Glycolic Acid. 120ml.',
        price: 1450,
        imageUrls: ['assets/images/hydrating_cleanser.png'],
        category: 'cleansers',
        stock: 100,
        isActive: true,
        app: 'glowvella',
      ),
      GlowProduct(
        id: 'p3',
        name: 'Liquid Exfoliant',
        description: '7% Glycolic Acid Toner. Liquid exfoliant for glowing skin. 100ml.',
        price: 1650,
        imageUrls: ['assets/images/liquid_exfoliant.png'],
        category: 'toners',
        stock: 45,
        isActive: true,
        app: 'glowvella',
      ),
      GlowProduct(
        id: 'p4',
        name: 'Night Repair Complex',
        description: 'Anti-Aging Cream with Retinol + Collagen Peptides. 50g.',
        price: 2250,
        imageUrls: ['assets/images/night_repair.png'],
        category: 'creams',
        stock: 25,
        isActive: true,
        app: 'glowvella',
      ),
      GlowProduct(
        id: 'p5',
        name: 'UV Protector',
        description: 'Sun Block SPF 60. Broad Spectrum UVA/UVB Filters. Non-Greasy & Water Resistant. 50ml.',
        price: 1250,
        imageUrls: ['assets/images/uv_protector.png'],
        category: 'protection',
        stock: 80,
        isActive: true,
        app: 'glowvella',
      ),
      GlowProduct(
        id: 'p6',
        name: 'Advanced Brightener',
        description: 'Lucent Glow Cream with Alpha Arbutin + Glutathione + Vitamin C. Targets Hyperpigmentation. 50g.',
        price: 2450,
        imageUrls: ['assets/images/advanced_brightener.png'],
        category: 'creams',
        stock: 40,
        isActive: true,
        app: 'glowvella',
      ),
      GlowProduct(
        id: 'p7',
        name: 'Hydration Booster',
        description: 'Hyaluronic Acid Serum for intense plumping & hydration. 30ml.',
        price: 1950,
        imageUrls: ['assets/images/hydration_booster.png'],
        category: 'serums',
        stock: 30,
        isActive: true,
        app: 'glowvella',
      ),
    ]);
  }

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
