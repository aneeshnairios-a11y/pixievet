// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixievet/APIManager/CreateDoctorProfile/doctor_profile_request_model.dart';
import 'package:pixievet/APIManager/CreateDoctorProfile/doctor_profile_service.dart';
import 'package:pixievet/APIManager/SessionManager/session_manager.dart';
import 'package:pixievet/APIManager/APIUtils/api_guard.dart';
import 'package:pixievet/Utilities/app_alert.dart';
import 'package:pixievet/Utilities/app_colors.dart';
import 'package:pixievet/Utilities/device_utils.dart';
import 'package:pixievet/app_init_page.dart';

class CreateDoctorProfilePage extends StatefulWidget {
  const CreateDoctorProfilePage({super.key});

  @override
  State<CreateDoctorProfilePage> createState() =>
      _CreateDoctorProfilePageState();
}

class _CreateDoctorProfilePageState extends State<CreateDoctorProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController specializationCtrl = TextEditingController();
  final TextEditingController experienceCtrl = TextEditingController();
  final TextEditingController licenseCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Doctor Profile',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _profileImagePicker(),
              const SizedBox(height: 50),
              _textField('Name', nameCtrl),
              _textField(
                'Email',
                emailCtrl,
                keyboard: TextInputType.emailAddress,
              ),
              _textField('Specialization', specializationCtrl),
              _textField(
                'Experience Years',
                experienceCtrl,
                keyboard: TextInputType.number,
              ),
              _textField('License Number', licenseCtrl),
              const SizedBox(height: 32),
              _submitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField(
    String label,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _profileImagePicker() {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: const Icon(
              Icons.camera_alt_outlined,
              size: 28,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload Profile Image',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _verifyTokenAndSubmitProfile();
          }
        },
        child: Text(
          'Save Profile',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Future<void> _verifyTokenAndSubmitProfile() async {
    final isValid = await ApiGuard.verifySession(context);
    if (!isValid) return;

    await _submitProfile();
  }

  Future<void> _submitProfile() async {
    final service = DoctorProfileService();

    final userId = await SessionManager().getUserId();
    final token = await SessionManager().getToken();
    if (userId == null || token == null || userId.isEmpty || token.isEmpty) {
      AppAlert.show(
        context: context,
        type: AlertType.warning,
        title: "Session Expired",
        message: "Please login again",
      );
      return;
    }

    final deviceId = await DeviceUtils.getDeviceId();

    final request = DoctorProfileRequestModel(
      userId: userId,
      token: token,
      deviceId: deviceId,
      name: nameCtrl.text,
      email: emailCtrl.text,
      specialization: specializationCtrl.text,
      experienceYears: int.parse(experienceCtrl.text),
      licenseNumber: licenseCtrl.text,
    );

    final response = await service.submitProfile(request);

    if (response.status) {
      AppAlert.show(
        context: context,
        type: AlertType.success,
        title: "Success",
        message: response.message,
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const AppInitPage(fromLoginFlow: true),
        ),
        (_) => false,
      );
    } else {
      AppAlert.show(
        context: context,
        type: AlertType.warning,
        title: "Profile Creation Failed",
        message: response.message,
      );
    }
  }
}
