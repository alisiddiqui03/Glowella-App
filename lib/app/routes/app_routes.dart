part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const ROOT = _Paths.ROOT;
  static const AUTH = _Paths.AUTH;
  static const USER_BASE = _Paths.USER_BASE;
  static const USER_HOME = _Paths.USER_HOME;
  static const PRODUCT_DETAIL = _Paths.PRODUCT_DETAIL;
  static const CART = _Paths.CART;
  static const CHECKOUT = _Paths.CHECKOUT;
  static const ROUTINES = _Paths.ROUTINES;
  static const ROUTINE_DETAIL = _Paths.ROUTINE_DETAIL;
  static const DISCOUNT = _Paths.DISCOUNT;
  static const PROFILE = _Paths.PROFILE;
  static const ORDERS = _Paths.ORDERS;
  static const ORDER_CONFIRM = _Paths.ORDER_CONFIRM;
  static const ADMIN_BASE = _Paths.ADMIN_BASE;
  static const ADMIN_DASHBOARD = _Paths.ADMIN_DASHBOARD;
  static const ADMIN_INVENTORY = _Paths.ADMIN_INVENTORY;
  static const ADMIN_PRODUCT_FORM = _Paths.ADMIN_PRODUCT_FORM;
  static const ADMIN_ORDERS = _Paths.ADMIN_ORDERS;
}

abstract class _Paths {
  _Paths._();
  static const ROOT = '/';
  static const AUTH = '/auth';
  static const USER_BASE = '/user';
  static const USER_HOME = '/user/home';
  static const PRODUCT_DETAIL = '/user/product-detail';
  static const CART = '/user/cart';
  static const CHECKOUT = '/user/checkout';
  static const ROUTINES = '/user/routines';
  static const ROUTINE_DETAIL = '/user/routine-detail';
  static const DISCOUNT = '/user/discount';
  static const PROFILE = '/user/profile';
  static const ORDERS = '/user/orders';
  static const ORDER_CONFIRM = '/user/order-confirm';
  static const ADMIN_BASE = '/admin';
  static const ADMIN_DASHBOARD = '/admin/dashboard';
  static const ADMIN_INVENTORY = '/admin/inventory';
  static const ADMIN_PRODUCT_FORM = '/admin/product-form';
  static const ADMIN_ORDERS = '/admin/orders';
}
