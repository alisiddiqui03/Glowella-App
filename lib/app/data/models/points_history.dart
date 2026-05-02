import 'package:cloud_firestore/cloud_firestore.dart';

class PointHistoryItem {
  final String id;
  final String type; // 'order', 'redeem'
  final int points;
  final DateTime createdAt;
  final String? referenceId;
  final String source; // always "glowvella"

  const PointHistoryItem({
    required this.id,
    required this.type,
    required this.points,
    required this.createdAt,
    this.referenceId,
    this.source = 'glowvella',
  });

  factory PointHistoryItem.fromMap(String id, Map<String, dynamic> data) =>
      PointHistoryItem(
        id: id,
        type: data['type'] as String? ?? 'order',
        points: (data['points'] as num?)?.toInt() ?? 0,
        createdAt:
            (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        referenceId: data['referenceId'] as String?,
        source: data['source'] as String? ?? 'glowvella',
      );

  Map<String, dynamic> toMap() => {
        'type': type,
        'points': points,
        'createdAt': Timestamp.fromDate(createdAt),
        'referenceId': referenceId,
        'source': 'glowvella',
      };
}
