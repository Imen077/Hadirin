import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:hadirin/core/constant.dart';
import 'package:hadirin/utils/helper.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class FaceRecognitionService extends GetxService {
  Interpreter? _interpreter;
  static const int _inputSize = 112;

  @override
  void onInit() {
    super.onInit();
    _loadModel();
  }

  @override
  void onClose() {
    _interpreter?.close();
    super.onClose();
  }

  Future<File?> downloadModel(String modelName) async {
    final model = await FirebaseModelDownloader.instance.getModel(
      modelName,
      FirebaseModelDownloadType.localModelUpdateInBackground,
      FirebaseModelDownloadConditions(
        iosAllowsCellularAccess: false,
        iosAllowsBackgroundDownloading: true,
        androidChargingRequired: false,
        androidWifiRequired: false,
        androidDeviceIdleRequired: false,
      ),
    );

    return model.file;
  }

  Future<void> _loadModel() async {
    try {
      File? modelFile = await downloadModel(Constant.modelName);

      if (modelFile != null) {
        _interpreter = Interpreter.fromFile(modelFile);
        log('TFLite model loaded successfully.');
      }
    } catch (e) {
      log('Failed to load TFLite model: $e');
      Helper.showError('Failed to load TFLite model.');
    }
  }

  Float32List _preprocessImage(File imageFile, Face face) {
    // Read Iiage and decode
    final Uint8List bytes = imageFile.readAsBytesSync();
    final img.Image? originalImage = img.decodeImage(bytes);

    if (originalImage == null) {
      throw Exception('Failed to decode image');
    }

    // Bounding Box
    final Rect boundingBox = face.boundingBox;

    // Crop
    final img.Image croppedIimage = img.copyCrop(
      originalImage,
      x: boundingBox.left.toInt(),
      y: boundingBox.right.toInt(),
      width: boundingBox.width.toInt(),
      height: boundingBox.height.toInt(),
    );

    // Rezise input model
    final img.Image resizedImage = img.copyResize(
      croppedIimage,
      width: _inputSize,
      height: _inputSize,
    );

    // Normalize 0-255 -> 1 to 1
    final Float32List imageAsList = Float32List(
      1 * _inputSize * _inputSize * 3,
    );
    int pixelIndex = 0;

    for (int y = 0; y < _inputSize; y++) {
      for (int x = 0; x < _inputSize; x++) {
        final img.Pixel pixel = resizedImage.getPixel(x, y);
        imageAsList[pixelIndex++] = (pixel.r - 127.5) / 128;
        imageAsList[pixelIndex++] = (pixel.g - 127.5) / 128;
        imageAsList[pixelIndex++] = (pixel.b - 127.5) / 128;
      }
    }

    return imageAsList;
  }

  List<double> getEmbedding(File imageFile, Face face) {
    if (_interpreter == null) {
      log('Interpreter not loaded');
      return [];
    }

    // 1. Preprocess image
    final Float32List inputList = _preprocessImage(imageFile, face);

    // Reshape
    final input = inputList.reshape([1, _inputSize, _inputSize, 31]);
    // Output buffer
    final output = List.filled(1 * 192, 0.0).reshape([1, 192]);

    // 2. Run inference
    try {
      _interpreter!.run(input, output);
    } catch (e) {
      log('Error running TFLite Model: $e');
      Helper.showError('Error running TFLite Model.');
      return [];
    }

    // 3. Type Conversion/ Type Casting
    final List<dynamic> outputList = output[0] as List<dynamic>;
    final List<double> embeddingList = [];

    for (var i in outputList) {
      embeddingList.add((i as num).toDouble());
    }

    return embeddingList;
  }
}
