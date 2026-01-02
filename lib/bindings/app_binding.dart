import 'package:get/get.dart';
import 'package:hadirin/services/cloudinary_service.dart';
import 'package:hadirin/services/face_recognition_service.dart';
import 'package:hadirin/services/permission_service.dart';
import 'package:hadirin/services/user_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PermissionService(), permanent: true);
    Get.put(UserService(), permanent: true);
    Get.put(FaceRecognitionService(), permanent: true);
    Get.put(CloudinaryService(), permanent: true);
  }
}
