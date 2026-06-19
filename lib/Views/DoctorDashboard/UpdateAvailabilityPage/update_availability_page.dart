import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixievet/APIManager/CalendarUpdate/doctor_calendar_update_request_model.dart';
import 'package:pixievet/APIManager/CalendarUpdate/doctor_calendar_update_service.dart';
import 'package:pixievet/APIManager/SessionManager/session_manager.dart';
import 'package:pixievet/Utilities/device_utils.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pixievet/Utilities/app_colors.dart';
import 'package:pixievet/APIManager/DoctorSlots/doctor_slots_service.dart';
import 'package:pixievet/APIManager/DoctorSlots/doctor_slots_request_model.dart';
import 'package:pixievet/APIManager/DoctorSlots/doctor_slots_response_model.dart';

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

  Future<void> loadSlotsForDate(DateTime date) async {
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
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _calendarSection(),
            const SizedBox(height: 20),

            /// Show slots ONLY if exactly one date selected AND not full-day off
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Availability',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        TableCalendar(
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(const Duration(days: 365)),
          focusedDay: focusedDay,
          selectedDayPredicate: (day) {
            if (slotOffDate != null && _isSameDay(slotOffDate!, day)) {
              return true;
            }
            return dayOffDates.any((d) => _isSameDay(d, day));
          },
          onDaySelected: _onDayTapped,
          calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: Colors.red.shade400,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  void _onDayTapped(DateTime selectedDay, DateTime focused) {
    setState(() {
      focusedDay = focused;

      /// CASE 1: Slot mode active (single date with slots)
      if (slotOffDate != null) {
        // If same date tapped → deselect everything
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

        // 🔥 LOAD SLOTS FROM API
        loadSlotsForDate(slotOffDate!);
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
            crossAxisCount: 3, // 👈 number of columns
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.6, // 👈 width / height ratio
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
                      ? Colors.red.shade400
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
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
        datesOff.add(
          DoctorDateOff(
            date: _formatDate(date), // ✅ dd/MM/yyyy
            slots: [],
          ),
        );
      }
    }

    /// SLOT OFF (single date)
    if (slotOffDate != null) {
      datesOff.add(
        DoctorDateOff(
          date: _formatDate(slotOffDate!), // ✅ dd/MM/yyyy
          slots: selectedSlots.map(_convertTo24Hour).toList(),
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
      Navigator.pop(context);
    }
  }

  String _convertTo24Hour(String time) {
    // If already in 24-hour format (e.g. "09:30")
    if (!time.contains(' ')) {
      return time;
    }

    // 12-hour format (e.g. "02:30 PM")
    final parts = time.split(' ');
    final timeParts = parts[0].split(':');

    int hour = int.parse(timeParts[0]);
    final int minute = int.parse(timeParts[1]);
    final String period = parts[1].toUpperCase(); // AM / PM

    if (period == 'PM' && hour != 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  String _convertTo12Hour(String time24) {
    final parts = time24.split(':');
    int hour = int.parse(parts[0]);
    final minute = parts[1];

    final period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    hour = hour == 0 ? 12 : hour;

    return '$hour:$minute $period';
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }
}
