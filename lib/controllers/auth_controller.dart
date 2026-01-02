import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hadirin/services/user_service.dart';
import 'package:hadirin/utils/helper.dart';

class AuthController extends GetxController {
  final UserService userService = Get.find<UserService>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // observables
  final RxBool _isloading = false.obs;
  final RxBool _isPasswordHidden = true.obs;
  final RxBool _isConfrimPasswordHidden = true.obs;

  // Getters
  bool get isloading => _isloading.value;
  bool get isPasswordHidden => _isPasswordHidden.value;
  bool get isConfrimPasswordHidden => _isConfrimPasswordHidden.value;

  void togglePasswordVisibility() {
    _isPasswordHidden.value = !_isPasswordHidden.value;
  }

  void toggleConfrimPasswordVisibility() {
    _isConfrimPasswordHidden.value = !_isConfrimPasswordHidden.value;
  }

  // Form keys
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  // Text Controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController confrimPasswordController =
      TextEditingController();

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confrimPasswordController.dispose();
  }

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) {
      return;
    }

    _isloading.value = true;

    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      Helper.showError(e.message ?? 'Registration failed.');
    } finally {
      _isloading.value = false;
    }
  }

  Future<void> register() async {
    if (!registerFormKey.currentState!.validate()) {
      return;
    }

    _isloading.value = true;

    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );

      User? user = userCredential.user;
      if (user != null) {
        // create user doc
        await userService.createdUserDocument(user, nameController.text.trim());

        await user.updateDisplayName(nameController.text.trim());
        await user.reload();
      }
    } on FirebaseAuthException catch (e) {
      Helper.showError(e.message ?? 'Registration failed.');
    } finally {
      _isloading.value = false;
    }
  }
}
