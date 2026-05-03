import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../../app/data/models/glow_order.dart';
import '../../../../app/services/auth_service.dart';
import '../../../../app/services/order_service.dart';
import '../../../../app/services/wallet_service.dart';
import '../../../../app/services/discount_service.dart';
import '../../../../app/routes/app_pages.dart';
import '../../../user/cart/controllers/cart_controller.dart';

class CheckoutController extends GetxController {
  static CheckoutController get to => Get.find<CheckoutController>();

  final _auth = AuthService.to;
  final _cart = CartController.to;
  final _wallet = WalletService.to;
  final _discount = DiscountService.to;
  final _orders = OrderService.to;

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final streetCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final postalCtrl = TextEditingController();

  final RxBool isCod = true.obs;
  final RxBool useWallet = false.obs;
  final RxBool isLoading = false.obs;
  final Rxn<File> receiptFile = Rxn<File>();

  final RxString city = ''.obs;

  double get subtotal => _cart.subtotal;
  double get discountAmt => subtotal * (_discount.currentDiscount / 100);
  double get bankBonus => isCod.value ? 0 : subtotal * 0.05;
  
  double get deliveryCharges {
    if (!isCod.value) return 0.0; // Assuming Bank Transfer has free delivery or no COD fee
    String cityLower = city.value.trim().toLowerCase();
    if (cityLower == 'karachi') {
      return 500.0;
    } else if (cityLower.isNotEmpty) {
      return 350.0;
    }
    return 0.0;
  }

  double get afterDiscount => subtotal - discountAmt - bankBonus;
  double get walletDeduction {
    if (!useWallet.value) return 0;
    final available = _wallet.walletBalance.value;
    double totalWithDelivery = afterDiscount + deliveryCharges;
    return available > totalWithDelivery ? totalWithDelivery : available;
  }

  double get finalTotal =>
      (afterDiscount + deliveryCharges - walletDeduction).clamp(0.0, double.infinity);

  double get discountPct => _discount.currentDiscount;


  @override
  void onInit() {
    super.onInit();
    final user = _auth.currentUser.value;
    if (user != null) {
      nameCtrl.text = user.displayName ?? '';
      emailCtrl.text = user.email ?? '';
      phoneCtrl.text = user.phone ?? '';
      streetCtrl.text = user.street ?? '';
      cityCtrl.text = user.city ?? '';
      postalCtrl.text = user.postalCode ?? '';
      city.value = user.city ?? '';
    }
    cityCtrl.addListener(() {
      city.value = cityCtrl.text;
    });
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    streetCtrl.dispose();
    cityCtrl.dispose();
    postalCtrl.dispose();
    super.onClose();
  }

  Future<void> pickReceipt() async {
    final p = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (p != null) receiptFile.value = File(p.path);
  }

  Future<void> placeOrder() async {
    if (nameCtrl.text.trim().isEmpty ||
        phoneCtrl.text.trim().isEmpty ||
        streetCtrl.text.trim().isEmpty ||
        cityCtrl.text.trim().isEmpty) {
      Get.snackbar('Missing Info', 'Please fill all delivery details');
      return;
    }
    if (!isCod.value && receiptFile.value == null) {
      Get.snackbar(
          'Receipt Required', 'Please upload your bank transfer receipt');
      return;
    }
    if (isCod.value && finalTotal > 10000) {
      Get.snackbar('COD Limit',
          'COD is only available for orders under PKR 10,000');
      return;
    }

    isLoading.value = true;
    try {
      final uid = _auth.currentUser.value!.uid;
      String? uploadedUrl;

      if (!isCod.value && receiptFile.value != null) {
        final ref = FirebaseStorage.instance.ref(
            'orders/receipts/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(receiptFile.value!);
        uploadedUrl = await ref.getDownloadURL();
      }

      if (walletDeduction > 0) {
        await _wallet.deductWallet(uid, walletDeduction);
      }

      final items = _cart.items
          .map((i) => GlowOrderItem(
                productId: i.product.id,
                productName: i.product.name,
                quantity: i.quantity,
                price: i.product.price,
              ))
          .toList();

      final order = GlowOrder(
        id: '',
        userId: uid,
        customerName: nameCtrl.text.trim(),
        customerEmail: emailCtrl.text.trim(),
        total: finalTotal,
        createdAt: DateTime.now(),
        status: OrderStatus.pending,
        isCod: isCod.value,
        isPaid: false,
        paymentReceiptUrl: uploadedUrl,
        items: items,
        merchandiseTotal: subtotal,
        walletAppliedAmount: walletDeduction,
        bankTransferDiscountAmount: bankBonus,
        discountPercent: _discount.currentDiscount,
        deliveryPhone: phoneCtrl.text.trim(),
        deliveryStreet: streetCtrl.text.trim(),
        deliveryCity: cityCtrl.text.trim(),
        deliveryPostalCode: postalCtrl.text.trim(),
        app: 'glowvella',
      );

      await _orders.createOrder(order);
      _cart.clear();
      Get.offAllNamed(Routes.ORDER_CONFIRM);
    } catch (e) {
      Get.snackbar('Error', 'Could not place order. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
}
