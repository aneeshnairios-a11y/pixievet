// ignore_for_file: avoid_print

import 'package:get/get.dart';

import '../device_utils.dart';

class DeviceController extends GetxController {
  final RxString deviceId = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadDeviceId();
  }

  Future<void> loadDeviceId() async {
    isLoading.value = true;

    final id = await DeviceUtils.getDeviceId();
    deviceId.value = id;

    print("Device ID: $id");

    isLoading.value = false;
  }
}
