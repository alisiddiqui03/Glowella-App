import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase_options.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';
import 'app/services/auth_service.dart';
import 'app/services/product_service.dart';
import 'app/services/order_service.dart';
import 'app/services/ad_service.dart';
import 'app/services/discount_service.dart';
import 'app/services/wallet_service.dart';
import 'app/services/points_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  await GetStorage.init();

  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint("Firebase already initialized: $e");
  }

  await AdService.instance.init();

  await Get.putAsync<AuthService>(() async => AuthService().init());

  Get.put<ProductService>(ProductService());
  Get.put<OrderService>(OrderService());
  Get.put<DiscountService>(DiscountService());
  Get.put<WalletService>(WalletService());
  Get.put<PointsService>(PointsService());

  runApp(const GlowellaApp());
}

class GlowellaApp extends StatelessWidget {
  const GlowellaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Glowella',
      debugShowCheckedModeBanner: false,
      navigatorKey: Get.key,
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
