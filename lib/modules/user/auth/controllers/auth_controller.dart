import 'package:get/get.dart';
import '../../../../app/services/auth_service.dart';
import '../../../../app/services/discount_service.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find<AuthController>();

  final _auth = AuthService.to;

  final RxBool isLogin = true.obs;
  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxString errorMessage = ''.obs;

  void toggleMode() => isLogin.value = !isLogin.value;
  void toggleObscure() => obscurePassword.value = !obscurePassword.value;

  Future<void> signIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      errorMessage.value = 'Please fill all fields';
      return;
    }
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _auth.signInWithEmail(email.trim(), password);
      _postLoginNav();
    } catch (e) {
      errorMessage.value = _friendlyError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String name, String email, String password) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      errorMessage.value = 'Please fill all fields';
      return;
    }
    if (password.length < 6) {
      errorMessage.value = 'Password must be at least 6 characters';
      return;
    }
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _auth.registerWithEmail(
        email: email.trim(),
        password: password,
        displayName: name.trim(),
      );
      _postLoginNav();
    } catch (e) {
      errorMessage.value = _friendlyError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _auth.signInWithGoogle();
      _postLoginNav();
    } catch (e) {
      errorMessage.value = _friendlyError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void _postLoginNav() {
    if (_auth.isAdmin) {
      Get.offAllNamed('/admin');
    } else {
      Get.find<DiscountService>();
      Get.offAllNamed('/user');
    }
  }

  String _friendlyError(String raw) {
    if (raw.contains('user-not-found')) return 'No account found with this email';
    if (raw.contains('wrong-password')) return 'Incorrect password';
    if (raw.contains('invalid-email')) return 'Invalid email address';
    if (raw.contains('email-already-in-use')) return 'Email is already registered';
    if (raw.contains('weak-password')) return 'Password is too weak';
    if (raw.contains('network-request-failed')) return 'Network error. Check your connection';
    if (raw.contains('cancelled')) return 'Sign-in cancelled';
    return 'Something went wrong. Please try again';
  }
}
