import 'package:get/get.dart';
import 'package:hadirin/bindings/auth_binding.dart';
import 'package:hadirin/pages/attendance_page.dart';
import 'package:hadirin/pages/enroll_page.dart';
import 'package:hadirin/pages/home_page.dart';
import 'package:hadirin/pages/login_page.dart';
import 'package:hadirin/pages/register_page.dart';
import 'package:hadirin/pages/request_camera_page.dart';
import 'package:hadirin/pages/request_location_page.dart';
import 'package:hadirin/pages/root_page.dart';

class AppRouter {
  static const String root = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String requestCamera = '/requset-camera';
  static const String enroll = '/enroll';
  static const String requestLocation = '/request-location';
  static const String attendance = '/attendance';

  static const String intialRoute = root;

  static final List<GetPage> routes = [
    GetPage(name: root, page: () => RootPage()),
    GetPage(name: home, page: () => HomePage()),
    GetPage(name: login, page: () => LoginPage(), binding: AuthBinding()),
    GetPage(name: register, page: () => RegisterPage(), binding: AuthBinding()),
    GetPage(
      name: requestCamera,
      page: () {
        final String nextRoute = Get.arguments as String;
        return RequestCameraPage(nextRoute: nextRoute);
      },
    ),
    GetPage(name: enroll, page: () => EnrollPage()),
    GetPage(
      name: requestLocation,
      page: () {
        final ReqLocationProps args = Get.arguments as ReqLocationProps;
        return RequestLocationPage(props: args);
      },
    ),
    GetPage(name: attendance, page: () => AttendancePage()),
  ];
}
