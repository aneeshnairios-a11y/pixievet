import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixievet_app/APIManager/DoctorProfileDetails/doctor_profile_details_request_model.dart';
import 'package:pixievet_app/APIManager/DoctorProfileDetails/doctor_profile_details_response_model.dart';
import 'package:pixievet_app/APIManager/DoctorProfileDetails/doctor_profile_details_service.dart';
import 'package:pixievet_app/APIManager/SessionManager/session_manager.dart';
import 'package:pixievet_app/Utilities/device_utils.dart';
import 'package:pixievet_app/Utilities/app_colors.dart';
import 'package:pixievet_app/Utilities/app_images.dart';
import 'package:pixievet_app/Views/Login/login_page.dart';

import '../../../APIManager/APIUtils/api_constants.dart';

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
      body: Stack(
        children: [
          // ---------------- Background Image ----------------
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.dahboardBg), // full screen bg
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ---------------- Content ----------------
          SafeArea(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Column(
                      children: [
                        // ---------------- Top Row: Back + Edit ----------------
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // 🔹 Edit/Close button aligned to right
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                icon: Icon(
                                  isEditMode ? Icons.close : Icons.edit,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isEditMode = !isEditMode;
                                    hasChanges = false;
                                    if (!isEditMode) _fillControllers();
                                  });
                                },
                              ),
                            ),

                            // 🔹 Centered title
                            Text(
                              'Profile',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),

                            // 🔹 Back button aligned to left
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.logout_rounded,
                                  color: Colors.white,
                                ),
                                onPressed: _showLogoutDialog,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ---------------- Profile Card ----------------
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: AppColors.primary.withOpacity(
                                  0.2,
                                ),
                                child:
                                    profile!.profileImage != null &&
                                        profile!.profileImage!.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          "${ApiConstants.baseUrl}${profile!.profileImage!}",
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) {
                                            return const Icon(
                                              Icons.person,
                                              size: 50,
                                              color: AppColors.primary,
                                            );
                                          },
                                        ),
                                      )
                                    : const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: AppColors.primary,
                                      ),
                              ),
                              const SizedBox(height: 16),
                              _formField('Name', nameController),
                              _formField('Email', emailController),
                              _formField(
                                'Mobile Number',
                                TextEditingController(
                                  text: profile!.mobileNumber,
                                ),
                                enabled: false,
                              ),
                              _formField(
                                'Specialization',
                                specializationController,
                              ),
                              _formField(
                                'Experience (Years)',
                                experienceController,
                                keyboardType: TextInputType.number,
                              ),
                              _formField('License Number', licenseController),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ---------------- Save / Logout ----------------
                        if (isEditMode && hasChanges) _saveButton(),
                        if (isEditMode && hasChanges)
                          const SizedBox(height: 16),
                      ],
                    ),
                  ),
          ),
        ],
      ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Label above field
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),

          // 🔹 Text Field
          TextFormField(
            controller: controller,
            enabled: isEditMode && enabled,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white, // always white background
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
          setState(() {
            isEditMode = false;
            hasChanges = false;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          'Save Changes',
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Logout',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              _logout();
            },
            child: const Text('Logout', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
