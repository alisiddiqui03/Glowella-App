import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../config/google_auth_config.dart';
import '../data/models/app_user.dart';

class AuthService extends GetxService {
  AuthService();

  static AuthService get to => Get.find<AuthService>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  GoogleSignIn? _googleSignIn;

  GoogleSignIn get _googleSignInClient {
    _googleSignIn ??= GoogleSignIn(
      scopes: const <String>['email', 'profile'],
      serverClientId:
          kGoogleOAuthWebClientId.isEmpty ? null : kGoogleOAuthWebClientId,
      forceCodeForRefreshToken: true,
    );
    return _googleSignIn!;
  }

  final Rxn<User> firebaseUser = Rxn<User>();
  final Rxn<AppUser> currentUser = Rxn<AppUser>();

  bool get isLoggedIn => firebaseUser.value != null;
  bool get isAdmin => currentUser.value?.isAdmin ?? false;

  Future<AuthService> init() async {
    firebaseUser.bindStream(_auth.authStateChanges());
    ever<User?>(firebaseUser, _onFirebaseUserChanged);

    final user = _auth.currentUser;
    if (user != null) {
      await _loadUserProfile(user);
    }
    return this;
  }

  Future<void> _onFirebaseUserChanged(User? user) async {
    if (user == null) {
      currentUser.value = null;
      return;
    }
    await _loadUserProfile(user);
  }

  Future<void> refreshProfile() async {
    final u = _auth.currentUser;
    if (u == null) return;
    await _loadUserProfile(u);
  }

  Future<void> _loadUserProfile(User user) async {
    final doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .get(const GetOptions(source: Source.serverAndCache));

    if (doc.exists) {
      currentUser.value = AppUser.fromMap(user.uid, doc.data());
    } else {
      final fallback = AppUser(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        role: 'user',
        points: 0,
        isVip: false,
      );
      await _firestore.collection('users').doc(user.uid).set({
        ...fallback.toMap(),
        'walletBalance': 0.0,
        'wallet': {'balance': 0.0, 'pendingRewards': 0.0},
      }, SetOptions(merge: true));
      currentUser.value = fallback;
    }
  }

  Future<UserCredential> signInWithEmail(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await _loadUserProfile(credential.user!);
    return credential;
  }

  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user!;
    if (displayName != null && displayName.isNotEmpty) {
      await user.updateDisplayName(displayName);
    }
    final profile = AppUser(
      uid: user.uid,
      email: user.email,
      displayName: displayName ?? user.displayName,
      role: 'user',
      points: 0,
      isVip: false,
    );
    await _firestore.collection('users').doc(user.uid).set({
      ...profile.toMap(),
      'walletBalance': 0.0,
      'wallet': {'balance': 0.0, 'pendingRewards': 0.0},
    }, SetOptions(merge: true));
    currentUser.value = profile;
    return credential;
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      try {
        await _googleSignInClient.signOut();
      } catch (_) {}
      try {
        await _googleSignInClient.disconnect();
      } catch (_) {}

      final GoogleSignInAccount? googleUser = await _googleSignInClient.signIn();
      if (googleUser == null) {
        throw FirebaseAuthException(
          code: 'google-sign-in-aborted',
          message: 'Google sign-in was cancelled by the user.',
        );
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken == null || googleAuth.idToken!.isEmpty) {
        throw FirebaseAuthException(
          code: 'invalid-credential',
          message: 'Google did not return an ID token.',
        );
      }

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      await _loadUserProfile(result.user!);
      return result;
    } catch (e) {
      if (e.toString().contains('10')) {
        throw 'Google Config Error: Check SHA-1 & Support Email in Firebase Console.';
      } else if (e.toString().contains('12500')) {
        throw 'Google Sign-In failed (12500): Check your project configuration.';
      }
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> signOut() async {
    try { await _googleSignIn?.signOut(); } catch (_) {}
    await _auth.signOut();
    currentUser.value = null;
    firebaseUser.value = null;
  }
}
