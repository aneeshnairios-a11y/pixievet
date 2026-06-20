import 'package:flutter/material.dart';
import 'package:pixievet_app/Utilities/app_colors.dart';
import 'package:pixievet_app/Views/DoctorDashboard/PetsListPage/doctor_pets_list_page.dart';
import 'package:pixievet_app/Views/DoctorDashboard/UpdateAvailabilityPage/update_availability_page.dart';
import 'package:pixievet_app/Views/DoctorDashboard/doctor_dashboard.dart';

import 'DoctorProfile/doctor_profile_page.dart';

class MainDoctorPage extends StatefulWidget {
  final dynamic dashboardData; // Pass dashboard data here

  const MainDoctorPage({super.key, required this.dashboardData});

  @override
  State<MainDoctorPage> createState() => _MainDoctorPageState();
}

class _MainDoctorPageState extends State<MainDoctorPage> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DoctorDashboardPage(dashboardData: widget.dashboardData),
      UpdateAvailabilityPage(), // Replace with MedicalHistoryPage()
      DoctorPetsListPage(), // Replace with PaymentsPage()
      DoctorProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType
            .fixed, // <-- important to always show labels
        currentIndex: _currentIndex,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_available_outlined),
            label: 'Availability',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services_outlined),
            label: 'Pets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
