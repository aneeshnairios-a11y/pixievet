import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../APIManager/APIUtils/api_constants.dart';
import '../../../APIManager/DoctorPetDetails/pet_details_request_model.dart';
import '../../../APIManager/DoctorPetDetails/pet_details_response_model.dart';
import '../../../APIManager/DoctorPetDetails/pet_details_service.dart';
import '../../../APIManager/SessionManager/session_manager.dart';
import '../../../Utilities/app_colors.dart';
import '../../../Utilities/app_images.dart';
import '../../../Utilities/device_utils.dart';

class DoctorPetDetailPage extends StatefulWidget {
  final String petId;

  const DoctorPetDetailPage({super.key, required this.petId});

  @override
  State<DoctorPetDetailPage> createState() => _DoctorPetDetailPageState();
}

class _DoctorPetDetailPageState extends State<DoctorPetDetailPage> {
  PetDetailsData? pet;
  bool isLoading = true;
  String? error;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadPetDetails();
  }

  Future<void> _loadPetDetails() async {
    final userId = await SessionManager().getUserId();
    final token = await SessionManager().getToken();
    final deviceId = await DeviceUtils.getDeviceId();

    try {
      final request = PetDetailsRequestModel(
        userId: userId ?? '',
        token: token ?? '',
        deviceId: deviceId,
        petId: widget.petId,
      );

      final response = await PetDetailsService().fetchPetDetails(request);

      if (response.status && response.pet != null) {
        setState(() {
          pet = response.pet!;
          isLoading = false;
        });
      } else {
        setState(() {
          error = response.message ?? 'Failed to load pet details';
          isLoading = false;
        });
      }
    } catch (_) {
      setState(() {
        error = 'Something went wrong';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // 👈 allows bg under AppBar
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Pet Patient Details'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white, // title & back icon
      ),
      body: Stack(
        children: [
          // ---------- BACKGROUND IMAGE ----------
          Positioned.fill(
            child: Image.asset(
              AppImages.dahboardBg, // 🔁 your image path
              fit: BoxFit.cover,
            ),
          ),

          // ---------- OPTIONAL DARK OVERLAY ----------
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.25)),
          ),

          // ---------- PAGE CONTENT ----------
          SafeArea(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Text(error!, style: GoogleFonts.poppins(color: Colors.red)),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _petSummaryCard(pet!),
          const SizedBox(height: 16),
          _vaccinationCard(pet!.vaccination),
          const SizedBox(height: 16),
          if (pet!.notes.isNotEmpty) ...[
            _infoTile('Notes', pet!.notes, isMultiline: true),
            const SizedBox(height: 16),
            _actionButtons(), // 👈 new buttons
          ],

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ---------------- PET SUMMARY ----------------

  Widget _petSummaryCard(PetDetailsData pet) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _petImages(pet.images),
          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: Text(
                  pet.name,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _genderBadge(pet.gender),
            ],
          ),

          const SizedBox(height: 12),

          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _petInfoChip(Icons.pets, 'Species', pet.species),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _petInfoChip(Icons.category, 'Breed', pet.breed),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _petInfoChip(Icons.cake, 'Age', pet.age)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _petInfoChip(
                      Icons.monitor_weight,
                      'Weight',
                      pet.weight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- PET IMAGES ----------------

  Widget _petImages(List<String> images) {
    if (images.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(child: Icon(Icons.pets, size: 48)),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CarouselSlider.builder(
            itemCount: images.length,
            options: CarouselOptions(
              height: 200,
              viewportFraction: 1,
              enableInfiniteScroll: images.length > 1,
              onPageChanged: (index, _) {
                setState(() => _currentImageIndex = index);
              },
            ),
            itemBuilder: (_, index, __) {
              final imageUrl = '${ApiConstants.baseUrl}${images[index]}';

              return Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.pets, size: 40),
                ),
              );
            },
          ),

          if (images.length > 1)
            Positioned(
              bottom: 10,
              child: Row(
                children: List.generate(
                  images.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentImageIndex == index ? 10 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _currentImageIndex == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ---------------- VACCINATION ----------------

  Widget _vaccinationCard(List<PetDetailVacination> vaccinations) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vaccination',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          ...vaccinations.map((v) {
            final name = v.name;
            final date = v.expDate.isEmpty ? 'Not taken' : v.expDate;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(name, style: GoogleFonts.poppins(fontSize: 14)),
                  Text(
                    date,
                    style: GoogleFonts.poppins(
                      color: date == 'Not taken'
                          ? Colors.redAccent
                          : AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ---------------- UI HELPERS ----------------

  Widget _genderBadge(String gender) {
    final isMale = gender.toLowerCase() == 'male';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isMale
            ? Colors.blue.withOpacity(0.12)
            : Colors.pink.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            isMale ? Icons.male : Icons.female,
            size: 14,
            color: isMale ? Colors.blue : Colors.pink,
          ),
          const SizedBox(width: 4),
          Text(
            gender,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isMale ? Colors.blue : Colors.pink,
            ),
          ),
        ],
      ),
    );
  }

  Widget _petInfoChip(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.poppins(fontSize: 11)),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value, {bool isMultiline = false}) {
    return SizedBox(
      width: double.infinity, // 👈 forces same width as other cards
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            Text(value, style: GoogleFonts.poppins(height: 1.4)),
          ],
        ),
      ),
    );
  }

  Widget _actionButtons() {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // TODO: Navigate to prescriptions
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Prescriptions',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // TODO: Navigate to appointments
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Appointments',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
