// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixievet/APIManager/SessionManager/session_manager.dart';
import 'package:pixievet/Views/Login/login_page.dart';
import 'package:pixievet/Utilities/app_colors.dart';
import 'package:pixievet/Utilities/app_images.dart';

class PetProfilePage extends StatefulWidget {
  const PetProfilePage({super.key});

  @override
  State<PetProfilePage> createState() => _PetProfilePageState();
}

class _PetProfilePageState extends State<PetProfilePage> {
  // Controllers for text fields
  final TextEditingController petNameController = TextEditingController(
    text: "Buddy",
  );
  final TextEditingController speciesController = TextEditingController(
    text: "Dog",
  );
  final TextEditingController breedController = TextEditingController(
    text: "Golden Retriever",
  );
  final TextEditingController ageController = TextEditingController(text: "3");
  final TextEditingController weightController = TextEditingController(
    text: "12 kg",
  );
  final TextEditingController genderController = TextEditingController(
    text: "Male",
  );
  final TextEditingController notesController = TextEditingController(
    text: "Loves walks",
  );

  final TextEditingController nameController = TextEditingController(
    text: "Aneesh Nair",
  );
  final TextEditingController emailController = TextEditingController(
    text: "aneesh@example.com",
  );
  final TextEditingController phoneController = TextEditingController(
    text: "+91 9876543210",
  );

  bool isEdited = false; // Tracks if any field is edited

  @override
  void dispose() {
    petNameController.dispose();
    speciesController.dispose();
    breedController.dispose();
    ageController.dispose();
    weightController.dispose();
    genderController.dispose();
    notesController.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void onFieldChanged(String value) {
    if (!isEdited) {
      setState(() {
        isEdited = true;
      });
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await SessionManager().clearSession();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (_) => false,
              );
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.textPrimary,
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: AppColors.textPrimary,
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _petAvatar(),
            const SizedBox(height: 20),

            _sectionContainer(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pet Details",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  _buildTextFieldWithIcon(
                    "Pet Name",
                    petNameController,
                    icon: Icons.pets,
                    onChanged: onFieldChanged,
                  ),
                  _buildTextFieldWithIcon(
                    "Species",
                    speciesController,
                    icon: Icons.category,
                    onChanged: onFieldChanged,
                  ),
                  _buildTextFieldWithIcon(
                    "Breed",
                    breedController,
                    onChanged: onFieldChanged,
                  ),
                  _buildTextFieldWithIcon(
                    "Age",
                    ageController,
                    icon: Icons.calendar_today,
                    onChanged: onFieldChanged,
                  ),
                  _buildTextFieldWithIcon(
                    "Weight",
                    weightController,
                    icon: Icons.monitor_weight,
                    onChanged: onFieldChanged,
                  ),
                  _buildTextFieldWithIcon(
                    "Gender",
                    genderController,
                    icon: Icons.male,
                    onChanged: onFieldChanged,
                  ),
                  _buildTextFieldWithIcon(
                    "Notes",
                    notesController,
                    maxLines: 3,
                    onChanged: onFieldChanged,
                  ),
                ],
              ),
            ),

            _sectionContainer(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Person Details",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  _buildTextFieldWithIcon(
                    "Name",
                    nameController,
                    icon: Icons.person,
                    onChanged: onFieldChanged,
                  ),
                  _buildTextFieldWithIcon(
                    "Email",
                    emailController,
                    icon: Icons.email,
                    onChanged: onFieldChanged,
                  ),
                  _buildTextFieldWithIcon(
                    "Phone Number",
                    phoneController,
                    icon: Icons.phone,
                    onChanged: onFieldChanged,
                  ),
                ],
              ),
            ),

            if (isEdited)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    /* Save logic */
                  },
                  child: Text(
                    "Save",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Section container for better visual separation
  Widget _sectionContainer(Widget child) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  // Text field with optional icon
  Widget _buildTextFieldWithIcon(
    String label,
    TextEditingController controller, {
    IconData? icon,
    int maxLines = 1,
    void Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        onChanged: onChanged,
        style: GoogleFonts.poppins(color: AppColors.textPrimary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary),
          prefixIcon: icon != null
              ? Icon(icon, color: AppColors.primary)
              : null,
          filled: true,
          fillColor: AppColors.background,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.border),
          ),
        ),
      ),
    );
  }

  // Gradient circle around pet avatar
  Widget _petAvatar() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage(AppImages.petAvatar),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.edit, size: 18, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
