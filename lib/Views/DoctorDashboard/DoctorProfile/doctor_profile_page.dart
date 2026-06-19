import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixievet/APIManager/DoctorProfileDetails/doctor_profile_details_request_model.dart';
import 'package:pixievet/APIManager/DoctorProfileDetails/doctor_profile_details_response_model.dart';
import 'package:pixievet/APIManager/DoctorProfileDetails/doctor_profile_details_service.dart';
import 'package:pixievet/APIManager/SessionManager/session_manager.dart';
import 'package:pixievet/Utilities/device_utils.dart';
import 'package:pixievet/Utilities/app_colors.dart';
import 'package:pixievet/Views/Login/login_page.dart';

class DoctorProfilePage extends StatefulWidget {
  const DoctorProfilePage({super.key});

  @override
  State<DoctorProfilePage> createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  bool isLoading = true;
  bool isEditMode = false;
  bool hasChanges = false;

  DoctorProfileData? profile;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController specializationController =
      TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProfile();
    _attachListeners();
  }

  void _attachListeners() {
    nameController.addListener(_onFieldChanged);
    emailController.addListener(_onFieldChanged);
    specializationController.addListener(_onFieldChanged);
    experienceController.addListener(_onFieldChanged);
    licenseController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    if (!isEditMode || profile == null) return;

    final changed =
        nameController.text != profile!.name ||
        emailController.text != profile!.email ||
        specializationController.text != profile!.specialization ||
        experienceController.text != profile!.experienceYears.toString() ||
        licenseController.text != profile!.licenseNumber;

    setState(() => hasChanges = changed);
  }

  // ---------------- FETCH PROFILE ----------------
  Future<void> _fetchProfile() async {
    final session = SessionManager();
    final userId = await session.getUserId();
    final token = await session.getToken();
    final deviceId = await DeviceUtils.getDeviceId();

    final request = DoctorProfileDetailsRequestModel(
      userId: userId ?? '',
      token: token ?? '',
      deviceId: deviceId,
    );

    final service = DoctorProfileDetailsService();
    final response = await service.fetchDoctorProfile(request);

    if (!mounted) return;

    if (response.status && response.doctor != null) {
      profile = response.doctor!;
      _fillControllers();
    }

    setState(() => isLoading = false);
  }

  void _fillControllers() {
    nameController.text = profile!.name;
    emailController.text = profile!.email;
    specializationController.text = profile!.specialization;
    experienceController.text = profile!.experienceYears.toString();
    licenseController.text = profile!.licenseNumber;
  }

  // ---------------- LOGOUT ----------------
  Future<void> _logout() async {
    final session = SessionManager();
    await session.clearSession();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Doctor Profile',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: Icon(isEditMode ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() {
                isEditMode = !isEditMode;
                hasChanges = false;
                if (!isEditMode) _fillControllers();
              });
            },
          ),
        ],
      ),
      body: isLoading ? _loader() : _body(),
    );
  }

  // ---------------- BODY ----------------
  Widget _body() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _profileAvatar(),
          const SizedBox(height: 24),
          _formField('Name', nameController),
          _formField('Email', emailController),
          _formField(
            'Mobile Number',
            TextEditingController(text: profile!.mobileNumber),
            enabled: false,
          ),
          _formField('Specialization', specializationController),
          _formField(
            'Experience (Years)',
            experienceController,
            keyboardType: TextInputType.number,
          ),
          _formField('License Number', licenseController),
          const SizedBox(height: 24),

          if (isEditMode && hasChanges) _saveButton(),
          if (isEditMode && hasChanges) SizedBox(height: 24),
          _logoutButton(),
        ],
      ),
    );
  }

  // ---------------- UI COMPONENTS ----------------
  Widget _profileAvatar() {
    return CircleAvatar(
      radius: 48,
      backgroundColor: AppColors.primary.withOpacity(0.2),
      child: Icon(Icons.person, size: 50, color: AppColors.primary),
    );
  }

  Widget _formField(
    String label,
    TextEditingController controller, {
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        enabled: isEditMode && enabled,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: enabled ? Colors.white : Colors.grey.shade200,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          // 🔜 Call UPDATE PROFILE API here
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
          setState(() {
            isEditMode = false;
            hasChanges = false;
          });
        },
        child: Text('Save Changes', style: GoogleFonts.poppins(fontSize: 16)),
      ),
    );
  }

  Widget _logoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: _logout,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
        ),
        child: const Text('Logout'),
      ),
    );
  }

  Widget _loader() {
    return const Center(child: CircularProgressIndicator());
  }
}
