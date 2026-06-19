import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixievet/APIManager/PatientSlots/patient_slots_request_model.dart';
import 'package:pixievet/APIManager/PatientSlots/patient_slots_response_model.dart';
import 'package:pixievet/APIManager/PatientSlots/patient_slots_service.dart';
import 'package:pixievet/Utilities/app_colors.dart';
import 'package:pixievet/APIManager/SessionManager/session_manager.dart';
import 'package:pixievet/Utilities/device_utils.dart';
import 'package:pixievet/Views/PetDashboard/BookAppointment/booking_summary_page.dart';

class BookAppointmentPage extends StatefulWidget {
  const BookAppointmentPage({super.key});

  @override
  State<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  DateTime selectedDate = DateTime.now();

  List<PatientSlot> apiSlots = [];
  bool isLoadingSlots = false;
  PatientSlot? selectedSlot;

  @override
  void initState() {
    super.initState();
    _loadSlotsForDate(selectedDate); // ✅ Load today slots on entry
  }

  // ---------------- API CALL ----------------

  Future<void> _loadSlotsForDate(DateTime date) async {
    setState(() {
      isLoadingSlots = true;
      apiSlots.clear();
      selectedSlot = null;
    });

    final session = SessionManager();

    final request = PatientSlotsRequestModel(
      userId: await session.getUserId() ?? '',
      token: await session.getToken() ?? '',
      deviceId: await DeviceUtils.getDeviceId(),
      date:
          '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
      doctorId: '',
    );

    final service = PatientSlotsService();
    final response = await service.fetchPatientSlots(request);

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
              _loadSlotsForDate(date); // ✅ Fetch slots on date change
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
            final isSelected = selectedSlot == slot;
            final isDisabled = !slot.isAvailable;

            return GestureDetector(
              onTap: isDisabled
                  ? null
                  : () {
                      setState(() => selectedSlot = slot);
                    },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDisabled
                      ? Colors.grey.shade300
                      : isSelected
                      ? AppColors.primary
                      : AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  _convertTo12Hour(slot.slotTime),
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDisabled
                        ? Colors.grey
                        : isSelected
                        ? Colors.white
                        : AppColors.textPrimary,
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
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SizedBox(
        height: 48,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: selectedSlot == null
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingSummaryPage(
                        selectedDate: selectedDate,
                        selectedTime: _convertTo12Hour(selectedSlot!.slotTime),
                        amount: 500,
                      ),
                    ),
                  );
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
    );
  }

  // ---------------- UTILS ----------------

  String _convertTo12Hour(String time24) {
    final parts = time24.split(':');
    int hour = int.parse(parts[0]);
    final minute = parts[1];

    final period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    hour = hour == 0 ? 12 : hour;

    return '$hour:$minute $period';
  }
}
