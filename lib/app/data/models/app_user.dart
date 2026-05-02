import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String? email;
  final String? displayName;
  final String role; // 'admin' or 'user'
  final int points;
  final bool isVip;
  final DateTime? vipEndDate;

  const AppUser({
    required this.uid,
    required this.role,
    this.email,
    this.displayName,
    this.points = 0,
    this.isVip = false,
    this.vipEndDate,
  });

  bool get isAdmin => role == 'admin';

  bool get isVipActive {
    return isVip && vipEndDate != null && vipEndDate!.isAfter(DateTime.now());
  }

  factory AppUser.fromMap(String uid, Map<String, dynamic>? data) {
    final map = data ?? <String, dynamic>{};
    return AppUser(
      uid: uid,
      email: map['email'] as String?,
      displayName: map['displayName'] as String?,
      role: (map['role'] as String?) ?? 'user',
      points: (map['points'] as num?)?.toInt() ?? 0,
      isVip: map['isVip'] as bool? ?? false,
      vipEndDate: (map['vipEndDate'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'role': role,
      'points': points,
      'isVip': isVip,
      'vipEndDate': vipEndDate != null ? Timestamp.fromDate(vipEndDate!) : null,
    };
  }
}
