import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mandala/controllers/exceptionhandling.dart';
import 'package:mandala/view/authview/login.dart';

import '../view/dashboard.dart';
import 'package:firebase_core/firebase_core.dart';

import '../view/splash.dart';

class AuthRepo extends GetxController {
  static AuthRepo get instance => Get.put(AuthRepo());
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> _firebaseUser;
  @override
  void onready() {
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.userChanges());
    ever(_firebaseUser, _setinitialScreen);
  }

  _setinitialScreen(User? user) {
    user == null
        ? Get.offAll(() => SplashScreen())
        : Get.offAll(() => const Home());
  }

  Future<void> createUserWithEmailAndPassword(String email, String pass) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      _firebaseUser.value != null
          ? Get.offAll(() => const Home())
          : Get.offAll(() => SplashScreen());
    } on FirebaseAuthException catch (e) {
      final ex = SignupEmailFailure(e.code);
      print('Firebase Auth Exception - ${ex.message}');
      throw ex;
    } catch (_) {}
  }

  Future<void> loginWithEmailAndPassword(String email, String pass) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: pass);
    } on FirebaseAuthException catch (e) {
    } catch (_) {}
  }

  Future<void> logout() async => await _auth.signOut();
}
