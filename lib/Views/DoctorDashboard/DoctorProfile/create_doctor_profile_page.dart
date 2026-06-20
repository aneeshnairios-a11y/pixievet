// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:pixievet_app/APIManager/CreateDoctorProfile/doctor_profile_request_model.dart';
import 'package:pixievet_app/APIManager/CreateDoctorProfile/doctor_profile_service.dart';
import 'package:pixievet_app/APIManager/SessionManager/session_manager.dart';
import 'package:pixievet_app/APIManager/APIUtils/api_guard.dart';
import 'package:pixievet_app/Utilities/app_alert.dart';
import 'package:pixievet_app/Utilities/app_colors.dart';
import 'package:pixievet_app/Utilities/app_loader.dart';
import 'package:pixievet_app/Utilities/device_utils.dart';
import 'package:pixievet_app/app_init_page.dart';

class CreateDoctorProfilePage extends StatefulWidget {
  const CreateDoctorProfilePage({super.key});

  @override
  State<CreateDoctorProfilePage> createState() =>
      _CreateDoctorProfilePageState();
}

class _CreateDoctorProfilePageState extends State<CreateDoctorProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final specializationCtrl = TextEditingController();
  final experienceCtrl = TextEditingController();
  final licenseCtrl = TextEditingController();

  File? profileImage;
  final ImagePicker _picker = ImagePicker();
  String? selectedGender;

  // ---------------- IMAGE PICKER ----------------

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final image = await _picker.pickImage(source: source, imageQuality: 80);
    if (image != null) {
      setState(() => profileImage = File(image.path));
    }
  }

  // ---------------- SUBMIT ----------------

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final isValid = await ApiGuard.verifySession(context);
    if (!isValid) return;
    // if (selectedGender == null) {
    //   AppAlert.show(
    //     context: context,
    //     type: AlertType.warning,
    //     title: "Required",
    //     message: "Please select gender",
    //   );
    //   return;
    // }
    AppLoader().show(context, message: "Please wait...");

    try {
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
        name: nameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        specialization: specializationCtrl.text.trim(),
        experienceYears: int.tryParse(experienceCtrl.text) ?? 0,
        licenseNumber: licenseCtrl.text.trim(),
        profileImage: profileImage,
      );

      final response = await DoctorProfileService().submitProfile(request);

      if (!mounted) return;

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
            builder: (_) => const AppInitPage(fromLoginFlow: false),
          ),
          (_) => false,
        );
      } else {
        AppAlert.show(
          context: context,
          type: AlertType.warning,
          title: "Failed",
          message: response.message,
        );
      }
    } catch (_) {
      if (!mounted) return;
      AppAlert.show(
        context: context,
        type: AlertType.failure,
        title: "Error",
        message: "Something went wrong. Please try again.",
      );
    } finally {
      AppLoader().hide();
    }
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Create Your Account'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please add your image',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 15),
              Center(child: _profileImage()),

              const SizedBox(height: 24),
              Text(
                'Please fill in your details',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 20),
              _field('Full Name *', nameCtrl, keyboardType: TextInputType.name),
              _field(
                'Email *',
                emailCtrl,
                keyboardType: TextInputType.emailAddress,
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gender *',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _genderRadio('Male'),
                      const SizedBox(width: 12),
                      _genderRadio('Female'),
                      const SizedBox(width: 12),
                      _genderRadio('Other'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const SizedBox(height: 14),
              _field(
                'Specialization *',
                specializationCtrl,
                keyboardType: TextInputType.name,
              ),
              _field(
                'Experience in Years *',
                experienceCtrl,
                keyboardType: TextInputType.name,
              ),
              _field(
                'License Number *',
                licenseCtrl,
                keyboardType: TextInputType.name,
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Save Your Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- COMMON WIDGETS ----------------

  Widget _profileImage() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: profileImage != null
              ? FileImage(profileImage!)
              : null,
          child: profileImage == null
              ? const Icon(Icons.person, size: 40)
              : null,
        ),
        InkWell(
          onTap: _showImagePickerOptions,
          child: CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _field(
    String title,
    TextEditingController controller, {
    String? hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final isRequired = title.contains('*');

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                hintText: hint ?? title.replaceAll('*', ''),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
              ),
              validator: (v) =>
                  isRequired && (v == null || v.isEmpty) ? 'Required' : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _genderRadio(String value) {
    final isSelected = selectedGender == value;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => setState(() => selectedGender = value),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Radio<String>(
                value: value,
                groupValue: selectedGender,
                onChanged: (v) => setState(() => selectedGender = v),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact, // 👈 reduces spacing
                activeColor: AppColors.primary,
              ),
              const SizedBox(width: 6), // 👈 control gap manually
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
