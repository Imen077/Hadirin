import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hadirin/core/constant.dart';
import 'package:hadirin/models/target_location_model.dart';
import 'package:hadirin/utils/helper.dart';

class TargetLocationService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Observable
  Rxn<TargetLocationModel> targetLocation = Rxn<TargetLocationModel>();

  @override
  void onReady() {
    super.onReady();
    loadTargetLocationDoc();
  }

  Future<void> loadTargetLocationDoc() async {
    try {
      final querySnapshot = await _firestore
          .collection(Constant.configCollection)
          .limit(1)
          .get();

      final doc = querySnapshot.docs.first;
      targetLocation.value = TargetLocationModel.fromMap(doc.data());
      log(
        'Target location document loaded successfully. ${targetLocation.value?.coords.latitude}, ${targetLocation.value?.coords.longitude}, ${targetLocation.value?.radius}',
      );
      if (doc.exists) {
      } else {
        throw 'Target location document not found. Please contact support.';
      }
    } on FirebaseException catch (e) {
      log(e.message ?? 'Failed to load target location document');
      Helper.showError(
        e.message ??
            'Something went wrong. Error loading target location data.',
      );
    }
  }
}
