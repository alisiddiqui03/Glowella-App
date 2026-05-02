import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus { pending, packed, shipped, delivered, cancelled }

class GlowOrderItem {
  final String? productId;
  final String productName;
  final int quantity;
  final double price;

  const GlowOrderItem({
    this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  double get lineTotal => price * quantity;

  factory GlowOrderItem.fromMap(Map<String, dynamic> data) => GlowOrderItem(
        productId: data['productId'] as String?,
        productName: data['productName'] as String? ?? '',
        quantity: (data['quantity'] as num?)?.toInt() ?? 0,
        price: (data['price'] as num?)?.toDouble() ?? 0,
      );

  Map<String, dynamic> toMap() => {
        'productId': productId,
        'productName': productName,
        'quantity': quantity,
        'price': price,
      };
}

class GlowOrder {
  final String id;
  final String? userId;
  final String customerName;
  final String customerEmail;
  final double total;
  final DateTime createdAt;
  final OrderStatus status;
  final bool isCod;
  final bool isPaid;
  final String? paymentReceiptUrl;
  final List<GlowOrderItem> items;
  final double merchandiseTotal;
  final double walletAppliedAmount;
  final double bankTransferDiscountAmount;
  final double discountPercent;
  final String deliveryPhone;
  final String deliveryStreet;
  final String deliveryCity;
  final String deliveryPostalCode;
  final String? cancellationReason;
  final DateTime? cancelledAt;
  final bool cancellationUnreadForUser;
  final DateTime? deliveredAt;
  final String? firestorePath;

  // Glowella-specific tag
  final String app; // "glowvella"

  const GlowOrder({
    required this.id,
    this.userId,
    required this.customerName,
    required this.customerEmail,
    required this.total,
    required this.createdAt,
    required this.status,
    required this.isCod,
    required this.isPaid,
    this.paymentReceiptUrl,
    required this.items,
    this.merchandiseTotal = 0,
    this.walletAppliedAmount = 0,
    this.bankTransferDiscountAmount = 0,
    this.discountPercent = 0,
    this.deliveryPhone = '',
    this.deliveryStreet = '',
    this.deliveryCity = '',
    this.deliveryPostalCode = '',
    this.cancellationReason,
    this.cancelledAt,
    this.cancellationUnreadForUser = false,
    this.deliveredAt,
    this.firestorePath,
    this.app = 'glowvella',
  });

  String get deliverySummary {
    return [
      if (deliveryStreet.isNotEmpty) deliveryStreet,
      if (deliveryCity.isNotEmpty) deliveryCity,
      if (deliveryPostalCode.isNotEmpty) deliveryPostalCode,
    ].join(', ');
  }

  GlowOrder copyWith({
    OrderStatus? status,
    bool? isPaid,
    String? paymentReceiptUrl,
  }) {
    return GlowOrder(
      id: id,
      userId: userId,
      customerName: customerName,
      customerEmail: customerEmail,
      total: total,
      createdAt: createdAt,
      status: status ?? this.status,
      isCod: isCod,
      isPaid: isPaid ?? this.isPaid,
      paymentReceiptUrl: paymentReceiptUrl ?? this.paymentReceiptUrl,
      items: items,
      merchandiseTotal: merchandiseTotal,
      walletAppliedAmount: walletAppliedAmount,
      bankTransferDiscountAmount: bankTransferDiscountAmount,
      discountPercent: discountPercent,
      deliveryPhone: deliveryPhone,
      deliveryStreet: deliveryStreet,
      deliveryCity: deliveryCity,
      deliveryPostalCode: deliveryPostalCode,
      cancellationReason: cancellationReason,
      cancelledAt: cancelledAt,
      cancellationUnreadForUser: cancellationUnreadForUser,
      deliveredAt: deliveredAt,
      firestorePath: firestorePath,
      app: app,
    );
  }

  factory GlowOrder.fromMap(
    String id,
    Map<String, dynamic> data, {
    String? firestorePath,
  }) {
    final items = (data['items'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(GlowOrderItem.fromMap)
        .toList();

    final cancelledTs = data['cancelledAt'];
    DateTime? cancelledAt;
    if (cancelledTs is Timestamp) cancelledAt = cancelledTs.toDate();

    return GlowOrder(
      id: id,
      userId: data['userId'] as String?,
      customerName: data['customerName'] as String? ?? '',
      customerEmail: data['customerEmail'] as String? ?? '',
      total: (data['total'] as num?)?.toDouble() ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ??
          DateTime.fromMillisecondsSinceEpoch(0),
      status: _statusFrom(data['status'] as String?),
      isCod: data['isCod'] as bool? ?? false,
      isPaid: data['isPaid'] as bool? ?? false,
      paymentReceiptUrl: data['paymentReceiptUrl'] as String?,
      items: items,
      merchandiseTotal:
          (data['merchandiseTotal'] as num?)?.toDouble() ??
          (data['total'] as num?)?.toDouble() ??
          0,
      walletAppliedAmount:
          (data['walletAppliedAmount'] as num?)?.toDouble() ?? 0,
      bankTransferDiscountAmount:
          (data['bankTransferDiscountAmount'] as num?)?.toDouble() ?? 0,
      discountPercent: (data['discountPercent'] as num?)?.toDouble() ?? 0,
      deliveryPhone: data['deliveryPhone'] as String? ?? '',
      deliveryStreet: data['deliveryStreet'] as String? ?? '',
      deliveryCity: data['deliveryCity'] as String? ?? '',
      deliveryPostalCode: data['deliveryPostalCode'] as String? ?? '',
      cancellationReason: data['cancellationReason'] as String?,
      cancelledAt: cancelledAt,
      cancellationUnreadForUser:
          data['cancellationUnreadForUser'] as bool? ?? false,
      deliveredAt: (data['deliveredAt'] as Timestamp?)?.toDate(),
      firestorePath: firestorePath,
      app: data['app'] as String? ?? 'glowvella',
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'userId': userId,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'total': total,
      'createdAt': Timestamp.fromDate(createdAt),
      'status': status.name,
      'isCod': isCod,
      'isPaid': isPaid,
      'paymentReceiptUrl': paymentReceiptUrl,
      'items': items.map((e) => e.toMap()).toList(),
      'merchandiseTotal': merchandiseTotal,
      'walletAppliedAmount': walletAppliedAmount,
      'bankTransferDiscountAmount': bankTransferDiscountAmount,
      'discountPercent': discountPercent,
      'deliveryPhone': deliveryPhone,
      'deliveryStreet': deliveryStreet,
      'deliveryCity': deliveryCity,
      'deliveryPostalCode': deliveryPostalCode,
      'cancellationUnreadForUser': cancellationUnreadForUser,
      'app': 'glowvella', // always tag with glowvella
    };
    if (cancellationReason != null) map['cancellationReason'] = cancellationReason;
    if (cancelledAt != null) map['cancelledAt'] = Timestamp.fromDate(cancelledAt!);
    if (deliveredAt != null) map['deliveredAt'] = Timestamp.fromDate(deliveredAt!);
    return map;
  }
}

OrderStatus _statusFrom(String? v) {
  switch (v) {
    case 'pending': return OrderStatus.pending;
    case 'packed': return OrderStatus.packed;
    case 'shipped': return OrderStatus.shipped;
    case 'delivered': return OrderStatus.delivered;
    case 'cancelled': return OrderStatus.cancelled;
    default: return OrderStatus.pending;
  }
}
