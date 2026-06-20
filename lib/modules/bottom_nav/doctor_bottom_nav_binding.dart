import 'package:get/get.dart';

import 'doctor_bottom_nav_controller.dart';

class DoctorBottomNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorBottomNavController>(() => DoctorBottomNavController());
  }
}
