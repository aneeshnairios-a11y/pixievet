// ignore_for_file: avoid_print

import 'package:get/get.dart';
import '../../../core/utils/device_utils.dart';

class DeviceController extends GetxController {
  RxString deviceId = ''.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDeviceId();
  }

  Future<void> fetchDeviceId() async {
    isLoading.value = true;

    final id = await DeviceUtils.getDeviceId();
    deviceId.value = id;

    print("Device ID: $id");

    isLoading.value = false;
  }
}
