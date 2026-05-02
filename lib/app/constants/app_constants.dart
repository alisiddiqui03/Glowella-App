class AppConstants {
  AppConstants._();

  static const String appName = 'Glowella';
  static const String appTag = 'glowvella'; // field: app: "glowvella"
  static const String appVersion = '1.0.0';

  // Firestore collections
  static const String colUsers = 'users';
  static const String colProducts = 'products';
  static const String colOrders = 'orders';
  static const String colDiscounts = 'discounts';
  static const String colAdminPushTargets = 'admin_push_targets';

  // Subcollections
  static const String subOrders = 'orders';
  static const String subPointsHistory = 'points_history';

  // Points
  static const int pointsPerPkr = 200;       // 1 point per 200 PKR
  static const int vipPointsMultiplier = 2;  // VIP: 2x points
  static const int redeemMinPoints = 500;
  static const double pointToPkr = 5.0;      // 1 point = 5 PKR

  // Discount
  static const double welcomeDiscount = 5.0;
  static const double bankTransferBonus = 5.0;
  static const double maxAdDiscount = 20.0;

  // COD limit
  static const double codMaxAmount = 10000.0;

  // Routine IDs
  static const String routineMaster = 'master';
  static const String routineMorning = 'morning';
  static const String routineNight = 'night';
}
