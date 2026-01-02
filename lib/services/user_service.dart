import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:hadirin/core/constant.dart';
import 'package:hadirin/core/routes.dart';
import 'package:hadirin/models/user_model.dart';
import 'package:hadirin/services/permission_service.dart';
import 'package:hadirin/utils/helper.dart';

class UserService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final PermissionService _permissionService = Get.find<PermissionService>();

  Rxn<User> firebaseUser = Rxn<User>();
  Rxn<UserModel> firestroreUser = Rxn<UserModel>();

  @override
  void onReady() {
    super.onReady();
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _onAuthChanged);
  }

  Future<void> _onAuthChanged(User? user) async {
    if (user == null) {
      Get.offAllNamed(AppRouter.login);
    } else {
      await _loadUserDocument(user.uid);

      if (firestroreUser.value == null) {
        Get.offAllNamed(AppRouter.login);
      } else {
        if (firestroreUser.value!.faceEmbedding == null) {
          if (await _permissionService.cameraPermissionStatus ==
              PermissionState.granted) {
            Get.offAllNamed(AppRouter.enroll);
          } else {
            Get.offAllNamed(
              AppRouter.requestCamera,
              arguments: AppRouter.enroll,
            );
          }
          Get.offAllNamed(AppRouter.requestCamera, arguments: AppRouter.enroll);
        } else {
          Get.offAllNamed(AppRouter.home);
        }
      }
    }

    FlutterNativeSplash.remove();
  }

  Future<void> _loadUserDocument(String uid) async {
    try {
      final doc = await _firestore
          .collection(Constant.userCollection)
          .doc(uid)
          .get();

      if (doc.exists) {
        firestroreUser.value = UserModel.fromMap(doc.data()!);
      } else {
        throw 'User document not found. Please contact support.';
      }
    } on FirebaseException catch (e) {
      await logout();
      Helper.showError(
        e.message ?? 'Something went wrong. Error loading user data.',
      );
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> createdUserDocument(User user, String displayName) async {
    try {
      final newUser = UserModel(
        uid: user.uid,
        email: user.email ?? '',
        displayName: displayName,
        createdAt: Timestamp.now(),
      );

      await _firestore
          .collection(Constant.userCollection)
          .doc(user.uid)
          .set(newUser.toMap());
    } on FirebaseException catch (e) {
      log(e.message ?? 'Failed to create user document');
      Helper.showError(e.message ?? 'Something went wrong.');
    }
  }

  Future<void> saveEmbedding(List<double> embedding, String imageUrl) async {
    try {
      if (firebaseUser.value == null) {
        Helper.showError('User not logged in.');
        return;
      }

      await _firestore
          .collection(Constant.userCollection)
          .doc(firebaseUser.value!.uid)
          .update({'faceEmbedding': embedding, 'faceImageUrl': imageUrl});

      _loadUserDocument(firebaseUser.value!.uid);

      Helper.showSuccess('Face Enrollment Complete! Welcome!');
      Get.offAllNamed(AppRouter.home);
    } on Exception catch (e) {
      log('Failed to save embedding: $e');
      throw Exception('Failed to save embedding: $e');
    }
  }
}
