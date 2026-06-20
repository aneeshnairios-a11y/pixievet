import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pixievet/core/utils/device_controller/device_controller.dart';

import 'core/router/app_pages.dart';
import 'core/router/app_routes.dart';
import 'core/theme/app_theme.dart';

void main() {
  Get.put(DeviceController(), permanent: true);
  // Get.find<DeviceController>().deviceId.value --> Access device ID anywhere in the app after it's loaded
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X design
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          title: "Pixievet",
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          initialRoute: AppRoutes.login,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
