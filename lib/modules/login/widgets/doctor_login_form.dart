import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/extensions/size_extension.dart';
import '../controllers/login_controller.dart';
import 'login_title.dart';

class DoctorLoginForm extends GetView<LoginController> {
  const DoctorLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: controller.doctorFormKey,
        child: Column(
          children: [
            SizedBox(height: 20.h),

            const LoginTitle(),

            SizedBox(height: 20.h),

            TextFormField(
              controller: controller.usernameController,
              validator: (v) => v!.isEmpty ? "Username required" : null,
              decoration: const InputDecoration(hintText: "Username"),
            ),

            SizedBox(height: 15.h),

            Obx(
              () => TextFormField(
                controller: controller.passwordController,
                obscureText: controller.isPasswordHidden.value,
                validator: (v) => v!.isEmpty ? "Password required" : null,
                decoration: InputDecoration(
                  hintText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordHidden.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: controller.togglePassword,
                  ),
                ),
              ),
            ),

            SizedBox(height: 35.h),

            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.doctorLogin,
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("Login as Doctor"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
