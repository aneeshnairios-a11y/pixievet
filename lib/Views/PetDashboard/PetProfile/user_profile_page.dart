// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:pixievet_app/APIManager/SessionManager/session_manager.dart';
import 'package:pixievet_app/APIManager/UserProfile/user_profile_details_request_model.dart';
import 'package:pixievet_app/APIManager/UserProfile/user_profile_details_service.dart';
import 'package:pixievet_app/APIManager/UserProfile/user_profile_details_response_model.dart';
import 'package:pixievet_app/Utilities/app_colors.dart';

import '../../../APIManager/APIUtils/api_constants.dart';
import '../../../Utilities/app_images.dart';
import '../../../Utilities/device_utils.dart';
import '../../Login/login_page.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    with TickerProviderStateMixin {
  bool isLoading = true;
  UserProfileDetailsResponseModel? profile;
  TabController? _tabController;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final userId = await SessionManager().getUserId();
    final token = await SessionManager().getToken();
    final deviceId = await DeviceUtils.getDeviceId();

    final request = UserProfileDetailsRequestModel(
      userId: userId!,
      token: token!,
      deviceId: deviceId,
    );

    final response = await UserProfileDetailsService().fetchUserProfile(
      request,
    );

    if (response.status) {
      if (response.pets.length > 1) {
        _tabController = TabController(
          length: response.pets.length,
          vsync: this,
        );
      }
    }

    setState(() {
      profile = response;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // 🔥 IMPORTANT
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            tooltip: 'Logout',
            onPressed: _showLogoutDialog,
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : profile == null
          ? const Center(child: Text('Failed to load profile'))
          : Stack(
              children: [
                // 🔹 Full-page background image
                Positioned.fill(
                  child: Image.asset(AppImages.dahboardBg, fit: BoxFit.cover),
                ),

                // 🔹 Foreground content
                Positioned.fill(child: SafeArea(child: _buildContent())),
              ],
            ),
    );
  }

  Widget _buildContent() {
    final owner = profile!.ownerDetails!;
    final pets = profile!.pets;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _ownerCard(owner),
          const SizedBox(height: 20),

          if (pets.length > 1) _petTabs(pets),
          if (pets.length == 1) _petDetails(pets.first),
        ],
      ),
    );
  }

  // ---------------- OWNER CARD ----------------

  Widget _ownerCard(OwnerDetails owner) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Top Row (Image + Name & Number)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 56,
                  width: 56,
                  color: AppColors.primary.withOpacity(0.15),
                  child:
                      owner.profileImage != null &&
                          owner.profileImage!.isNotEmpty
                      ? Image.network(
                          "${ApiConstants.baseUrl}${owner.profileImage!}",
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return const Icon(
                              Icons.person,
                              size: 32,
                              color: AppColors.primary,
                            );
                          },
                        )
                      : const Icon(
                          Icons.person,
                          size: 32,
                          color: AppColors.primary,
                        ),
                ),
              ),
              const SizedBox(width: 12),

              // Name & Number
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    owner.name,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    owner.number,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),
          Divider(color: AppColors.border.withOpacity(0.5), height: 16),

          // Email
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Email:  ',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: owner.email,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // Gender
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Gender:  ',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: owner.gender,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- PET TABS ----------------

  Widget _petTabs(List pets) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: pets.map<Tab>((p) => Tab(text: p.name)).toList(),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 520,
          child: TabBarView(
            controller: _tabController,
            children: pets.map<Widget>((p) => _petDetails(p)).toList(),
          ),
        ),
      ],
    );
  }

  // ---------------- PET DETAILS ----------------

  Widget _petDetails(PetDetails pet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _petSummaryCard(pet),
        const SizedBox(height: 16),
        _vaccinationCard(pet.vaccination),
        const SizedBox(height: 16),
        if (pet.notes.isNotEmpty)
          _infoTile('Notes', pet.notes, isMultiline: true),
      ],
    );
  }

  Widget _petSummaryCard(PetDetails pet) {
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
          // 🔹 Image Carousel
          _petImages(pet.images),
          const SizedBox(height: 14),

          // 🔹 Name + Gender Badge
          Row(
            children: [
              Expanded(
                child: Text(
                  pet.name,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              _genderBadge(pet.gender),
            ],
          ),

          const SizedBox(height: 12),

          // 🔹 Info Chips
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
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
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

  Widget _vaccinationCard(List<Vaccination> vaccinations) {
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
            String name;

            if (v.rabbies != null) {
              name = 'Rabies';
            } else if (v.ddhp != null) {
              name = 'DDHP';
            } else if (v.kenneCough != null) {
              name = 'Kennel Cough';
            } else {
              name = 'Unknown';
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(name, style: GoogleFonts.poppins(fontSize: 14)),
                  Text(
                    v.expDate.isEmpty ? 'Not taken' : v.expDate,
                    style: GoogleFonts.poppins(
                      color: v.expDate.isEmpty
                          ? Colors.redAccent
                          : AppColors.primary,
                      fontSize: 13,
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
          // 🔹 Image Carousel
          CarouselSlider.builder(
            itemCount: images.length,
            options: CarouselOptions(
              height: 200,
              viewportFraction: 1, // 🔥 Fill container
              enableInfiniteScroll: images.length > 1,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
            ),
            itemBuilder: (context, index, realIndex) {
              final imageUrl = "${ApiConstants.baseUrl}${images[index]}";

              return Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (_, __, ___) {
                  return Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.pets, size: 40),
                  );
                },
              );
            },
          ),

          // 🔹 Page Indicator
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

  // ---------------- INFO TILE ----------------

  Widget _infoTile(String label, String value, {bool isMultiline = false}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: isMultiline
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: GoogleFonts.poppins(fontSize: 14, height: 1.4),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                ),
                Text(value, style: GoogleFonts.poppins(fontSize: 14)),
              ],
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
              Navigator.pop(context);
              await SessionManager().clearSession();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (_) => false,
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
