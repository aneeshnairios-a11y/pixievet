// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixievet/APIManager/CreatePetProfile/pet_profile_create_request_model.dart';
import 'package:pixievet/APIManager/CreatePetProfile/pet_profile_create_service.dart';
import 'package:pixievet/APIManager/SessionManager/session_manager.dart';
import 'package:pixievet/APIManager/APIUtils/api_guard.dart';
import 'package:pixievet/Utilities/app_alert.dart';
import 'package:pixievet/Utilities/device_utils.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:pixievet/app_init_page.dart';

class CreatePetPetProfilePage extends StatefulWidget {
  const CreatePetPetProfilePage({super.key});

  @override
  State<CreatePetPetProfilePage> createState() =>
      _CreatePetPetProfilePageState();
}

class _CreatePetPetProfilePageState extends State<CreatePetPetProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController petNameCtrl = TextEditingController();
  final TextEditingController breedCtrl = TextEditingController();
  final TextEditingController ageCtrl = TextEditingController();
  final TextEditingController weightCtrl = TextEditingController();
  final TextEditingController vaccinationCtrl = TextEditingController();
  final TextEditingController notesCtrl = TextEditingController();

  final TextEditingController ownerNameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  File? _petImageFile;

  String selectedSpecies = 'Dog';
  String selectedGender = 'Male';

  final List<String> speciesList = [
    'Dog',
    'Cat',
    'Cow',
    'Goat',
    'Horse',
    'Bird',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile Details',
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
              _sectionTitle('Pet Details'),
              _petImagePicker(),
              _textField('Pet Name', petNameCtrl),
              _speciesDropdown(),
              _textField('Breed', breedCtrl),
              _textField('Age', ageCtrl, keyboard: TextInputType.number),
              _textField(
                'Weight (Optional)',
                weightCtrl,
                keyboard: TextInputType.number,
              ),
              _genderSelector(),
              _vaccinationField(),
              _notesField(),

              const SizedBox(height: 24),
              _sectionTitle('Personal Details'),
              _textField('Name', ownerNameCtrl),
              _textField(
                'Email',
                emailCtrl,
                keyboard: TextInputType.emailAddress,
              ),
              _textField(
                'Phone Number',
                phoneCtrl,
                keyboard: TextInputType.phone,
              ),

              const SizedBox(height: 32),
              _submitButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- UI Components ----------------

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
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
          if (label.contains('Optional')) return null;
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _speciesDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        value: selectedSpecies,
        items: speciesList
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (value) {
          setState(() => selectedSpecies = value!);
        },
        decoration: InputDecoration(
          labelText: 'Species',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _genderSelector() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gender',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          ),
          Row(
            children: [
              Radio<String>(
                value: 'Male',
                groupValue: selectedGender,
                onChanged: (value) {
                  setState(() => selectedGender = value!);
                },
              ),
              const Text('Male'),
              Radio<String>(
                value: 'Female',
                groupValue: selectedGender,
                onChanged: (value) {
                  setState(() => selectedGender = value!);
                },
              ),
              const Text('Female'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _vaccinationField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: vaccinationCtrl,
              decoration: InputDecoration(
                labelText: 'Vaccination History',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(onPressed: () {}, icon: const Icon(Icons.attach_file)),
        ],
      ),
    );
  }

  Widget _notesField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: notesCtrl,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: 'Notes',
          alignLabelWithHint: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _petImageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      AppAlert.show(
        context: context,
        type: AlertType.warning,
        title: "Image Error",
        message: "Failed to pick image",
      );
    }
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
                title: const Text("Take Photo"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from Gallery"),
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

  Widget _petImagePicker() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: GestureDetector(
          onTap: _showImagePickerOptions,
          child: CircleAvatar(
            radius: 45,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: _petImageFile != null
                ? FileImage(_petImageFile!)
                : null,
            child: _petImageFile == null
                ? const Icon(Icons.camera_alt, size: 28, color: Colors.grey)
                : null,
          ),
        ),
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
            _verifyTokenForSubmitProfile();
          }
        },
        child: Text(
          'Save Profile',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Future<void> _verifyTokenForSubmitProfile() async {
    final isValid = await ApiGuard.verifySession(context);
    if (!isValid) return;

    // ✅ Token valid → safe to call API
    await _submitProfile();
  }

  Future<void> _submitProfile() async {
    final service = PetProfileCreateService();

    final userId = await SessionManager().getUserId();
    if (userId == null || userId.isEmpty) {
      AppAlert.show(
        context: context,
        type: AlertType.warning,
        title: "Session Expired",
        message: "Please login again",
      );

      return;
    }

    final deviceId = await DeviceUtils.getDeviceId();

    final response = await service.createProfile(
      PetProfileCreateRequestModel(
        ownerName: ownerNameCtrl.text,
        mobileNumber: phoneCtrl.text,
        email: emailCtrl.text,
        petName: petNameCtrl.text,
        species: selectedSpecies,
        breed: breedCtrl.text,
        age: int.parse(ageCtrl.text),
        gender: selectedGender,
        weight: int.parse(weightCtrl.text),
        vaccinationHistory: vaccinationCtrl.text,
        notes: notesCtrl.text,
        photoUrl: _petImageFile?.path ?? '',
        documentsUrl: '',
        userId: userId,
        deviceId: deviceId,
      ),
    );

    if (response.status && response.isProfileCreated) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AppInitPage()),
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
