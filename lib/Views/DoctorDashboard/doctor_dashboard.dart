import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixievet/APIManager/DoctorDashboard/doctor_dashboard_response_model.dart';
import 'package:pixievet/Views/DoctorDashboard/DoctorProfile/doctor_profile_page.dart';
import 'package:pixievet/Views/DoctorDashboard/UpdateAvailabilityPage/update_availability_page.dart';
import 'package:pixievet/Utilities/app_colors.dart';

class DoctorDashboardPage extends StatefulWidget {
  final DoctorDashboardResponseModel dashboardData;

  const DoctorDashboardPage({super.key, required this.dashboardData});

  @override
  State<DoctorDashboardPage> createState() => _DoctorDashboardPageState();
}

class _DoctorDashboardPageState extends State<DoctorDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _upcomingAppointmentSection(),
            const SizedBox(height: 28),
            _gridSection(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ---------------- AppBar ----------------
  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.background,
      leading: IconButton(
        icon: const Icon(Icons.person_outline),
        color: AppColors.textPrimary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DoctorProfilePage()),
          );
        },
      ),
      title: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [Colors.blue, Colors.green],
        ).createShader(bounds),
        child: Text(
          'Hi Dr. ${widget.dashboardData.doctorDetails?.name ?? ''}',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
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

  // ---------------- Upcoming Appointment ----------------
  Widget _upcomingAppointmentSection() {
    final appointments = widget.dashboardData.upcomingAppointments;

    if (appointments.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _emptyAppointmentState(),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upcoming Appointment',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          /// Show only the NEXT appointment
          _appointmentCard(appointments.first),

          const SizedBox(height: 10),
          if (appointments.length > 1)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Navigate to All Appointments Page
                },
                child: const Text('View All Appointments'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _appointmentCard(UpcomingAppointment appointment) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: const Icon(Icons.pets, color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Patient: ${appointment.patientName}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Pet: ${appointment.petName} (${appointment.petType})',
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      appointment.formattedDateTime,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Start Video Call
            },
            icon: const Icon(Icons.videocam_outlined, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _emptyAppointmentState() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8)],
      ),
      child: Row(
        children: [
          Icon(Icons.event_busy, color: Colors.grey.shade400, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'No upcoming appointments',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Grid Section ----------------
  Widget _gridSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
        children: [
          _dashboardGridItem(
            icon: Icons.calendar_today,
            title: 'Update Availability',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const UpdateAvailabilityPage(),
                ),
              );
            },
          ),
          _dashboardGridItem(
            icon: Icons.people_outline,
            title: 'Pet List',
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (_) => const PatientListPage()),
              // );
            },
          ),
          _dashboardGridItem(
            icon: Icons.payment,
            title: 'Payments History',
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (_) => const PaymentsHistoryPage()),
              // );
            },
          ),
          _dashboardGridItem(
            icon: Icons.person,
            title: 'Prescriptions',
            onTap: () {
              // Navigate to Doctor Profile
            },
          ),
        ],
      ),
    );
  }

  Widget _dashboardGridItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 32, color: AppColors.primary),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
