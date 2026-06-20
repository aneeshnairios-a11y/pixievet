import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../device_utils/device_controller.dart';

class DeviceIdWidget extends StatelessWidget {
  DeviceIdWidget({super.key});

  final DeviceController controller = Get.put(DeviceController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const CircularProgressIndicator();
      }

      return Text(
        "Device ID:\n${controller.deviceId.value}",
        textAlign: TextAlign.center,
      );
    });
  }
}
