// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixievet/APIManager/PetDashboard/petdashboard_response_model.dart';
import 'package:pixievet/Views/PetDashboard/BookAppointment/book_appointment_page.dart';
import 'package:pixievet/Views/PetDashboard/PetProfile/pet_profile_page.dart';
import 'package:pixievet/Utilities/app_colors.dart';
import 'package:pixievet/Utilities/app_images.dart';

class PetDashboardPage extends StatefulWidget {
  final PetDashboardResponseModel dashboardData;

  const PetDashboardPage({super.key, required this.dashboardData});

  @override
  State<PetDashboardPage> createState() => _PetDashboardPageState();
}

class _PetDashboardPageState extends State<PetDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: _buildDashboardUI(widget.dashboardData),
    );
  }

  // ---------------- AppBar ----------------

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.background,
      surfaceTintColor: AppColors.background,
      leading: IconButton(
        icon: const Icon(Icons.person_outline),
        color: AppColors.textPrimary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PetProfilePage()),
          );
        },
      ),
      title: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: [AppColors.primary, AppColors.textSecondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
        child: Text(
          'Hi Dr.${widget.dashboardData.ownerName}',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white, // will be replaced by gradient
          ),
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none),
          color: AppColors.textPrimary,
          onPressed: () {},
        ),
      ],
    );
  }

  // ---------------- Main UI ----------------

  Widget _buildDashboardUI(PetDashboardResponseModel dashboardData) {
    final hasAppointments = dashboardData.appointments.isNotEmpty;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                image: DecorationImage(
                  image: AssetImage(AppImages.appBanner),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // ✅ Show only if appointments exist
          if (hasAppointments) ...[
            const SizedBox(height: 28),
            _upcomingAppointmentSection(dashboardData),
          ],

          const SizedBox(height: 28),
          _bookAppointmentButton(),

          const SizedBox(height: 32),
          _dashboardGrid(),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ---------------- Upcoming Appointment ----------------

  Widget _upcomingAppointmentSection(PetDashboardResponseModel dashboardData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Upcoming Appointments',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _upcomingAppointmentCard(dashboardData),
        ),
      ],
    );
  }

  Widget _upcomingAppointmentCard(PetDashboardResponseModel dashboardData) {
    final appointment = dashboardData.appointments.first;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: const Icon(Icons.person, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Dr. Rahul Sharma',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.videocam_outlined,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '24 Dec 2025',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_outlined,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '10:30 AM',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Book Appointment ----------------

  Widget _bookAppointmentButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BookAppointmentPage()),
            );
          },
          child: Text(
            'Book Appointment',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- Dashboard Grid ----------------

  Widget _dashboardGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: const [
          _DashboardGridItem(icon: Icons.receipt_long, title: 'Prescriptions'),
          _DashboardGridItem(icon: Icons.history, title: 'Medical History'),
          _DashboardGridItem(icon: Icons.payments_outlined, title: 'Payments'),
          SizedBox.shrink(),
          _DashboardGridItem(icon: Icons.info_outline, title: 'About Us'),
          SizedBox.shrink(),
        ],
      ),
    );
  }
}

// ---------------- Grid Item ----------------

class _DashboardGridItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const _DashboardGridItem({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 26, color: AppColors.primary),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
