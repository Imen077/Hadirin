import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:hadirin/services/cloudinary_service.dart';
import 'package:hadirin/services/face_recognition_service.dart';
import 'package:hadirin/services/target_location_service.dart';
import 'package:hadirin/services/user_service.dart';
import 'package:hadirin/utils/helper.dart';

class AttendanceController extends GetxController {
  // Camera
  late final CameraController cameraController;
  late List<CameraDescription> _cameras;
  CameraDescription? _frontCamera;

  // ML Kit Face Detector
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate),
  );

  // Observers
  RxBool isCameraInitialized = false.obs;
  RxString feedbackMessage = 'Loading...'.obs;
  RxBool isProcessing = false.obs;

  // Services
  final FaceRecognitionService _faceRecognitionService =
      Get.find<FaceRecognitionService>();
  // final CloudinaryService _cloudinaryService = Get.find<CloudinaryService>();
  final UserService _userService = Get.find<UserService>();
  final TargetLocationService _targetLocationService =
      Get.find<TargetLocationService>();

  @override
  void onInit() {
    super.onInit();
    _initCamera();
  }

  @override
  void onClose() {
    super.onClose();
    cameraController.dispose();
  }

  void _initCamera() async {
    try {
      _cameras = await availableCameras();
      _frontCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras.first,
      );

      cameraController = CameraController(
        _frontCamera!,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await cameraController.initialize();
      isCameraInitialized(true);
      feedbackMessage('Please place your face in the oval.');
    } catch (e) {
      log('Error initiliazing camera: $e');
      feedbackMessage('Error initiliazing camera.');
    }
  }

  Future<void> capture() async {
    // 1. Check Camera Intialized
    if (!isCameraInitialized.value) return;

    isProcessing(true);
    try {
      feedbackMessage('Getting location...');

      /// get location data (Lat, Long)
      final position = await Geolocator.getCurrentPosition();

      final double locationDistance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        _targetLocationService.targetLocation.value!.coords.latitude,
        _targetLocationService.targetLocation.value!.coords.longitude,
      );

      if (locationDistance >
          _targetLocationService.targetLocation.value!.radius) {
        throw Exception('You are not in the target location. Please try again');
      }

      feedbackMessage('location verified');

      // 2. Capture Image
      final XFile imageXFile = await cameraController.takePicture();
      final File imageFile = File(imageXFile.path);

      // 3. Detect Face - Make Sure 1 Face Detected
      feedbackMessage('Detecting face...');
      final InputImage inputImage = InputImage.fromFilePath(imageFile.path);
      final List<Face> faces = await _faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        throw Exception('No face detected. Please try again.');
      }

      if (faces.length > 1) {
        throw Exception('Multiple faces detected. Please try again.');
      }

      final Face face = faces.first;

      // 4. Get Embedding
      feedbackMessage('Getting embedding...');
      final List<double> newEmbedding = _faceRecognitionService.getEmbedding(
        imageFile,
        face,
      );

      if (newEmbedding.isEmpty) {
        throw Exception('Failed to get embedding. Please try again.');
      }

      /// get saved embedding dari User
      final List<double> savedEmbedding = _userService.getFaceEmbedding;

      if (savedEmbedding.isEmpty) {
        throw Exception('Failed to get saved embedding. Please try again.');
      }

      /// Compare
      /// Create
    } catch (e) {
      log(e.toString());
      Helper.showError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      isProcessing(false);
      feedbackMessage('Please place your face in the oval.');
    }
  }
}
