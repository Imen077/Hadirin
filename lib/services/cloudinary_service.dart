import 'dart:developer';
import 'dart:io';

import 'package:cloudinary/cloudinary.dart';
import 'package:get/get.dart';
import 'package:hadirin/env/env.dart';

class CloudinaryService extends GetxService {
  late final Cloudinary _cloudinary;

  @override
  void onInit() {
    super.onInit();
    _cloudinary = Cloudinary.unsignedConfig(cloudName: Env.cloudName);
  }

  // Upload image to Cloudinary
  Future<String> uploadeImage(File imageFile) async {
    try {
      final response = await _cloudinary.unsignedUpload(
        uploadPreset: Env.uploadPreset,
        file: imageFile.path,
        resourceType: CloudinaryResourceType.image,
        folder: 'hadirin',
        fileName: 'selfie_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (response.isResultOk) {
        return response.secureUrl!;
      } else {
        throw Exception(
          'Failed to upload image to Cloudinary: ${response.error ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      log('Error uploading image to Cloudinary: $e');
      throw Exception('Failed to upload image to Cloudinary: $e');
    }
  }
}
