// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixievet_app/APIManager/CalendarUpdate/doctor_calendar_update_request_model.dart';
import 'package:pixievet_app/APIManager/CalendarUpdate/doctor_calendar_update_service.dart';
import 'package:pixievet_app/APIManager/SessionManager/session_manager.dart';
import 'package:pixievet_app/Utilities/date_time_utils.dart';
import 'package:pixievet_app/Utilities/device_utils.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pixievet_app/Utilities/app_colors.dart';
import 'package:pixievet_app/APIManager/DoctorSlots/doctor_slots_service.dart';
import 'package:pixievet_app/APIManager/DoctorSlots/doctor_slots_request_model.dart';
import 'package:pixievet_app/APIManager/DoctorSlots/doctor_slots_response_model.dart';

class UpdateAvailabilityPage extends StatefulWidget {
  const UpdateAvailabilityPage({super.key});

  @override
  State<UpdateAvailabilityPage> createState() => _UpdateAvailabilityPageState();
}

class _UpdateAvailabilityPageState extends State<UpdateAvailabilityPage> {
  DateTime focusedDay = DateTime.now();

  /// Multiple full-day offs
  Set<DateTime> dayOffDates = {};

  /// Slot-off date (ONLY ONE DATE)
  DateTime? slotOffDate;
  List<DoctorSlot> apiSlots = [];
  bool isLoadingSlots = false;

  /// Slot offs for selected date
  Set<String> selectedSlots = {};

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  void initState() {
    super.initState();
    // Load slots for today if single-day slot mode
    slotOffDate = focusedDay;
    _loadSlotsForDate(focusedDay);
  }

  Future<void> _loadSlotsForDate(DateTime date) async {
    setState(() {
      isLoadingSlots = true;
      apiSlots.clear();
      selectedSlots.clear();
    });

    final session = SessionManager();

    final request = DoctorSlotsRequestModel(
      userId: await session.getUserId() ?? '',
      token: await session.getToken() ?? '',
      deviceId: await DeviceUtils.getDeviceId(),
      date:
          '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
    );

    final service = DoctorSlotsService();
    final response = await service.fetchDoctorSlots(request);

    if (!mounted) return;

    setState(() {
      isLoadingSlots = false;
      if (response.status) {
        apiSlots = response.slots;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Update Availability',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false, // 🔥 Removes the back arrow
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _calendarSection(),
            const SizedBox(height: 20),
            if (slotOffDate != null && dayOffDates.isEmpty) _slotSection(),
            const SizedBox(height: 32),
            _saveButton(),
          ],
        ),
      ),
    );
  }

  // ---------------- CALENDAR ----------------
  Widget _calendarSection() {
    return Container(
      padding: const EdgeInsets.all(12),
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
      child: TableCalendar(
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) {
          if (slotOffDate != null && _isSameDay(slotOffDate!, day)) return true;
          return dayOffDates.any((d) => _isSameDay(d, day));
        },
        onDaySelected: _onDayTapped,
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.3),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          todayDecoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          defaultTextStyle: const TextStyle(color: Colors.black87),
          weekendTextStyle: const TextStyle(color: Colors.black87),
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(fontWeight: FontWeight.w600),
          leftChevronIcon: Icon(Icons.chevron_left),
          rightChevronIcon: Icon(Icons.chevron_right),
        ),
      ),
    );
  }

  void _onDayTapped(DateTime selectedDay, DateTime focused) {
    setState(() {
      focusedDay = focused;

      /// CASE 1: Slot mode active (single date with slots)
      if (slotOffDate != null) {
        if (_isSameDay(slotOffDate!, selectedDay)) {
          slotOffDate = null;
          selectedSlots.clear();
          apiSlots.clear();
        } else {
          // Switch to multi-day full off
          dayOffDates
            ..clear()
            ..add(slotOffDate!)
            ..add(selectedDay);
          slotOffDate = null;
          selectedSlots.clear();
        }
        return;
      }

      /// CASE 2: Toggle full-day off dates
      if (dayOffDates.any((d) => _isSameDay(d, selectedDay))) {
        dayOffDates.removeWhere((d) => _isSameDay(d, selectedDay));
      } else {
        dayOffDates.add(selectedDay);
      }

      /// CASE 3: Exactly ONE date → enable slot mode
      if (dayOffDates.length == 1) {
        slotOffDate = dayOffDates.first;
        dayOffDates.clear();
        selectedSlots.clear();
        _loadSlotsForDate(slotOffDate!);
      }

      /// CASE 4: MORE THAN ONE date → full-day off mode
      if (dayOffDates.length > 1) {
        slotOffDate = null;
        selectedSlots.clear();
        apiSlots.clear();
      }
    });
  }

  // ---------------- SLOT SECTION ----------------
  Widget _slotSection() {
    if (isLoadingSlots) {
      return const Center(child: CircularProgressIndicator());
    }

    if (apiSlots.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 16),
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
          'Select Slots to Take Off',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: apiSlots.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.6,
          ),
          itemBuilder: (context, index) {
            final slot = apiSlots[index];
            final isSelected = selectedSlots.contains(slot.slotTime);
            final isDisabled = !slot.isAvailable;

            return GestureDetector(
              onTap: isDisabled
                  ? null
                  : () {
                      setState(() {
                        isSelected
                            ? selectedSlots.remove(slot.slotTime)
                            : selectedSlots.add(slot.slotTime);
                      });
                    },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDisabled
                      ? Colors.grey.shade300
                      : isSelected
                      ? AppColors.primary.withOpacity(0.3)
                      : Colors.grey.shade200,
                  border: isSelected
                      ? Border.all(color: AppColors.primary, width: 2)
                      : null,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  DateTimeUtils.convertTo12Hour(slot.slotTime),
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDisabled
                        ? Colors.grey
                        : isSelected
                        ? AppColors.primary
                        : Colors.black,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ---------------- SAVE ----------------
  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _saveAvailability,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          'Save Availability',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Future<void> _saveAvailability() async {
    final session = SessionManager();
    final userId = await session.getUserId();
    final token = await session.getToken();
    final deviceId = await DeviceUtils.getDeviceId();

    final List<DoctorDateOff> datesOff = [];

    /// FULL DAY OFFS (multiple dates)
    if (dayOffDates.isNotEmpty) {
      for (final date in dayOffDates) {
        datesOff.add(DoctorDateOff(date: _formatDate(date), slots: []));
      }
    }

    /// SLOT OFF (single date)
    if (slotOffDate != null) {
      datesOff.add(
        DoctorDateOff(
          date: _formatDate(slotOffDate!),
          slots: selectedSlots.map(DateTimeUtils.convertTo24Hour).toList(),
        ),
      );
    }

    final request = DoctorCalendarUpdateRequestModel(
      userId: userId ?? '',
      token: token ?? '',
      deviceId: deviceId,
      datesOff: datesOff,
    );

    final service = DoctorCalendarUpdateService();
    final response = await service.updateCalendar(request);

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(response.message)));

    if (response.status) {
      // ✅ Clear selections
      selectedSlots.clear();
      dayOffDates.clear();
      // ✅ Reload slots for the focused day
      if (slotOffDate != null) {
        await _loadSlotsForDate(slotOffDate!);
      } else {
        await _loadSlotsForDate(focusedDay);
      }
      setState(() {}); // refresh the UI
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }
}
