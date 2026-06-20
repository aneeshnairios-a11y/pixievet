// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixievet_app/Utilities/app_colors.dart';
import 'package:pixievet_app/Utilities/app_loader.dart';
import 'package:pixievet_app/Utilities/app_alert.dart';

import '../../../APIManager/APIUtils/api_constants.dart';
import '../../../APIManager/DoctorPets/doctor_pets_response_model.dart';
import '../../../APIManager/DoctorPets/doctor_pets_service.dart';
import '../../../Utilities/app_images.dart';
import 'doctor_pet_detail_page.dart';

class DoctorPetsListPage extends StatefulWidget {
  const DoctorPetsListPage({super.key});

  @override
  State<DoctorPetsListPage> createState() => _DoctorPetsListPageState();
}

class _DoctorPetsListPageState extends State<DoctorPetsListPage> {
  final DoctorPetsService _service = DoctorPetsService();
  List<PetModel> pets = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPets();
    });
  }

  Future<void> _loadPets() async {
    AppLoader().show(context, message: "Loading pets...");
    try {
      final response = await _service.fetchDoctorPets();
      if (!mounted) return;
      if (response.status) {
        setState(() => pets = response.pets);
      } else {
        AppAlert.show(
          context: context,
          type: AlertType.warning,
          title: "Error",
          message: response.message,
        );
      }
    } catch (e) {
      AppAlert.show(
        context: context,
        type: AlertType.warning,
        title: "Error",
        message: "Unexpected error occurred",
      );
    } finally {
      AppLoader().hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ---------------- BACKGROUND IMAGE ----------------
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.dahboardBg),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // ---------------- APP BAR ----------------
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Text(
                    'Pets',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ),

                // ---------------- BODY ----------------
                Expanded(
                  child: pets.isEmpty
                      ? _emptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: pets.length,
                          itemBuilder: (_, index) {
                            return _petCard(pets[index]);
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- PET CARD ----------------
  Widget _petCard(PetModel pet) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DoctorPetDetailPage(petId: pet.id)),
        );
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.primary),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Pet Image ----
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: pet.images.isNotEmpty
                  ? Image.network(
                      pet.images.first.startsWith('http')
                          ? pet.images.first
                          : '${ApiConstants.baseUrl}${pet.images.first}',
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 70,
                      height: 70,
                      color: AppColors.primary.withOpacity(0.1),
                      child: const Icon(
                        Icons.pets,
                        color: AppColors.primary,
                        size: 32,
                      ),
                    ),
            ),

            const SizedBox(width: 12),

            // ---- Details ----
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          pet.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          pet.species,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Breed : ${pet.breed}',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Age : ${pet.age}',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- EMPTY STATE ----------------
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pets_outlined,
            size: 60,
            color: AppColors.white.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'No pets found',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Pets assigned to you will appear here',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
