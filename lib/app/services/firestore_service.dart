import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();

  static FirebaseFirestore get instance => FirebaseFirestore.instance;

  // Collections
  static CollectionReference<Map<String, dynamic>> get usersCollection =>
      instance.collection('users');

  static CollectionReference<Map<String, dynamic>> get productsCollection =>
      instance.collection('products');

  // User subcollections
  static CollectionReference<Map<String, dynamic>> usersOrdersRef(String uid) =>
      usersCollection.doc(uid).collection('orders');

  static CollectionReference<Map<String, dynamic>> usersPointsHistoryRef(
          String uid) =>
      usersCollection.doc(uid).collection('points_history');

  // Admin: collection group query across all users' orders
  static Query<Map<String, dynamic>> get ordersCollectionGroup =>
      instance.collectionGroup('orders');
}
