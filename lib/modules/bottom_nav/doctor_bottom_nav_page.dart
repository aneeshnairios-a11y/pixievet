import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'doctor_availability/doctor_availability_page.dart';
import 'doctor_bottom_nav_controller.dart';
import 'doctor_home/doctor_home_page.dart';
import 'doctor_pets/doctor_pets_page.dart';
import 'doctor_profile/doctor_profile_page.dart';

class DoctorBottomNavPage extends GetView<DoctorBottomNavController> {
  const DoctorBottomNavPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      const DoctorHomePage(),
      const DoctorAvailabilityPage(),
      const DoctorPetsPage(),
      const DoctorProfilePage(),
    ];

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: pages,
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTab,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.access_time),
              label: "Availability",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.pets), label: "Pets"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
