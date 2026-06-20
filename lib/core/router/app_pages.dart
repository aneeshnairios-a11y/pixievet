import 'package:get/get.dart';
import '../../modules/bottom_nav/doctor_bottom_nav_binding.dart';
import '../../modules/bottom_nav/doctor_bottom_nav_page.dart';
import '../../modules/login/bindings/login_binding.dart';
import '../../modules/login/views/login_view.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.doctorDashboard,
      page: () => const DoctorBottomNavPage(),
      binding: DoctorBottomNavBinding(),
    ),
  ];
}
