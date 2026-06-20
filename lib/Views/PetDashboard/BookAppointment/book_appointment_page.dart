import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixievet_app/APIManager/PatientSlots/patient_slots_request_model.dart';
import 'package:pixievet_app/APIManager/PatientSlots/patient_slots_response_model.dart';
import 'package:pixievet_app/APIManager/PatientSlots/patient_slots_service.dart';
import 'package:pixievet_app/APIManager/SessionManager/session_manager.dart';
import 'package:pixievet_app/Utilities/app_colors.dart';
import 'package:pixievet_app/Utilities/date_time_utils.dart';
import 'package:pixievet_app/Utilities/device_utils.dart';
import 'package:pixievet_app/Views/PetDashboard/BookAppointment/booking_summary_page.dart';

import '../../../APIManager/UserProfile/user_profile_details_request_model.dart';
import '../../../APIManager/UserProfile/user_profile_details_response_model.dart';
import '../../../APIManager/UserProfile/user_profile_details_service.dart';

class BookAppointmentPage extends StatefulWidget {
  const BookAppointmentPage({super.key});

  @override
  State<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  DateTime selectedDate = DateTime.now();

  List<PatientSlot> apiSlots = [];
  bool isLoadingSlots = false;
  String? selectedSlotTime;

  @override
  void initState() {
    super.initState();
    _loadSlotsForDate(selectedDate);
  }

  // ---------------- API CALL ----------------

  Future<void> _loadSlotsForDate(DateTime date) async {
    setState(() {
      isLoadingSlots = true;
      apiSlots.clear();
      selectedSlotTime = null;
    });

    final session = SessionManager();

    final request = PatientSlotsRequestModel(
      userId: await session.getUserId() ?? '',
      token: await session.getToken() ?? '',
      deviceId: await DeviceUtils.getDeviceId(),
      doctorId: await session.getDoctorId() ?? '',
      date:
          '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
    );

    final response = await PatientSlotsService().fetchPatientSlots(request);

    if (!mounted) return;

    setState(() {
      isLoadingSlots = false;
      if (response.status) {
        apiSlots = response.slots;
      }
    });
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Book Appointment',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _dateSection(),
                  const SizedBox(height: 24),
                  _slotSection(),
                ],
              ),
            ),
          ),
          _bottomActionBar(),
        ],
      ),
    );
  }

  // ---------------- DATE PICKER ----------------

  Widget _dateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Date',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: CalendarDatePicker(
            initialDate: selectedDate,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 90)),
            onDateChanged: (date) {
              setState(() => selectedDate = date);
              _loadSlotsForDate(date);
            },
          ),
        ),
      ],
    );
  }

  // ---------------- SLOTS ----------------

  Widget _slotSection() {
    if (isLoadingSlots) {
      return const Center(child: CircularProgressIndicator());
    }

    if (apiSlots.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Text(
          'No slots available for this date',
          style: GoogleFonts.poppins(color: Colors.grey),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Time Slot',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: apiSlots.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.6,
          ),
          itemBuilder: (context, index) {
            final slot = apiSlots[index];
            final isSelected = selectedSlotTime == slot.slotTime;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedSlotTime = slot.slotTime;
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  DateTimeUtils.convertTo12Hour(slot.slotTime),
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ---------------- BOTTOM BAR ----------------

  Widget _bottomActionBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          // -------- AMOUNT --------
          if (selectedSlotTime != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Amount',
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  '₹500',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),

          if (selectedSlotTime != null) const SizedBox(width: 16),

          // -------- BOOK BUTTON --------
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: selectedSlotTime == null
                    ? null
                    : () {
                        _showPetSelector(context);
                      },
                child: Text(
                  'Book Appointment',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showPetSelector(BuildContext context) async {
    final userId = await SessionManager().getUserId();
    final token = await SessionManager().getToken();
    final deviceId = await DeviceUtils.getDeviceId();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return FutureBuilder<UserProfileDetailsResponseModel>(
          future: UserProfileDetailsService().fetchUserProfile(
            UserProfileDetailsRequestModel(
              userId: userId ?? '',
              token: token ?? '',
              deviceId: deviceId,
            ),
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final pets = snapshot.data!.pets;

            if (pets.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: Text('No pets found')),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Pet',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: pets.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final pet = pets[index];

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: const Icon(
                            Icons.pets,
                            color: AppColors.primary,
                          ),
                        ),
                        title: Text(
                          pet.name,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          '${pet.species} • ${pet.breed}',
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BookingSummaryPage(
                                selectedDate: selectedDate,
                                selectedTime: DateTimeUtils.convertTo12Hour(
                                  selectedSlotTime!,
                                ),
                                amount: 500,
                                petId: pet.id,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
