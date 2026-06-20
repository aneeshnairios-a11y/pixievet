import 'package:flutter/material.dart';
import 'package:pixievet_app/Views/PetDashboard/dashboard_page.dart';
import 'package:pixievet_app/Utilities/app_colors.dart';

import 'PetProfile/user_profile_page.dart';

class MainPetPage extends StatefulWidget {
  final dynamic dashboardData; // Pass dashboard data here

  const MainPetPage({super.key, required this.dashboardData});

  @override
  State<MainPetPage> createState() => _MainPetPageState();
}

class _MainPetPageState extends State<MainPetPage> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      PetDashboardPage(dashboardData: widget.dashboardData),
      const SizedBox(), // Replace with MedicalHistoryPage()
      const SizedBox(), // Replace with PaymentsPage()
      UserProfilePage(),
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
            icon: Icon(Icons.medical_services_outlined),
            label: 'Prescription',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment_outlined),
            label: 'Payments',
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
