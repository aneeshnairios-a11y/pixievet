// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Utilities/app_colors.dart';
import 'create_pet_profile_page.dart';
import 'owner_profile_model.dart';

class OwnerProfilePage extends StatefulWidget {
  final String phoneNumber;

  const OwnerProfilePage({super.key, required this.phoneNumber});

  @override
  State<OwnerProfilePage> createState() => _OwnerProfilePageState();
}

class _OwnerProfilePageState extends State<OwnerProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  String gender = 'Male';
  File? profileImage;

  @override
  void initState() {
    super.initState();
    phoneCtrl.text = widget.phoneNumber;
  }

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
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source, imageQuality: 80);

    if (image != null) {
      setState(() {
        profileImage = File(image.path);
      });
    }
  }

  void _continue() {
    if (!_formKey.currentState!.validate()) return;

    final owner = OwnerProfileModel(
      fullName: nameCtrl.text.trim(),
      mobile: phoneCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      gender: gender,
      profileImage: profileImage,
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CreatePetProfilePage(owner: owner)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create your Account')),
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

              const SizedBox(height: 12),
              Center(child: _profileImage()),

              const SizedBox(height: 24),
              Text(
                'Please fill in your details',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 16),
              _textField('Full Name *', nameCtrl),
              _textField('Enter your Number *', phoneCtrl, enabled: false),
              _textField(
                'Enter Email ID',
                emailCtrl,
                keyboard: TextInputType.emailAddress,
              ),

              const SizedBox(height: 8),
              Text(
                'Gender *',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
              Row(
                children: ['Male', 'Female', 'Others']
                    .map(
                      (e) => Row(
                        children: [
                          Radio<String>(
                            value: e,
                            activeColor: AppColors.primary,
                            groupValue: gender,
                            onChanged: (v) => setState(() => gender = v!),
                          ),
                          Text(e),
                        ],
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _continue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, // 👈 primary bg
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

  Widget _textField(
    String label,
    TextEditingController controller, {
    bool enabled = true,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (v) =>
            label.contains('*') && (v == null || v.isEmpty) ? 'Required' : null,
      ),
    );
  }
}
