// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixievet_app/APIManager/BookAppointment/book_appointment_request_model.dart';
import 'package:pixievet_app/APIManager/BookAppointment/book_appointment_service.dart';
import 'package:pixievet_app/APIManager/SessionManager/session_manager.dart';
import 'package:pixievet_app/Utilities/device_utils.dart';
import 'package:pixievet_app/Views/PetDashboard/BookAppointment/booking_success_page.dart';
import 'package:pixievet_app/Utilities/app_colors.dart';
import 'package:intl/intl.dart';

class BookingSummaryPage extends StatelessWidget {
  final DateTime selectedDate;
  final String selectedTime;
  final double amount;
  final String petId;

  const BookingSummaryPage({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
    required this.amount,
    required this.petId,
  });

  @override
  Widget build(BuildContext context) {
    const double gst = 10.0;
    final double totalAmount = amount + gst;
    if (kDebugMode) {
      print("Pettttttt $petId");
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        surfaceTintColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.textPrimary,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Booking Summary',
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
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
                  _summaryCard(
                    title: 'Appointment Details',
                    children: [
                      _rowItem(
                        icon: Icons.calendar_today_outlined,
                        label: 'Date',
                        value:
                            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                      ),
                      _rowItem(
                        icon: Icons.access_time_outlined,
                        label: 'Time',
                        value: selectedTime,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _summaryCard(
                    title: 'Payment Details',
                    children: [
                      _amountRow('Consultation Fee', amount),
                      _amountRow('GST', gst),
                      const Divider(),
                      _amountRow('Total Amount', totalAmount, isTotal: true),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Bottom Payment Button
          _paymentButton(context, totalAmount),
        ],
      ),
    );
  }

  // ---------------- Summary Card ----------------

  Widget _summaryCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  // ---------------- Rows ----------------

  Widget _rowItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _amountRow(String label, double value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: isTotal ? 14 : 13,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            '₹${value.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              fontSize: isTotal ? 16 : 13,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
              color: isTotal ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Payment Button ----------------

  Widget _paymentButton(BuildContext context, double totalAmount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
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
            _makePayment(context, petId);
          },
          child: Text(
            'Make Payment • ₹${totalAmount.toStringAsFixed(2)}',
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

  // ---------------- API CALL ----------------

  Future<void> _makePayment(BuildContext context, String petID) async {
    final session = SessionManager();

    final request = BookAppointmentRequestModel(
      userId: await session.getUserId() ?? '',
      token: await session.getToken() ?? '',
      deviceId: await DeviceUtils.getDeviceId(),
      date:
          '${selectedDate.day.toString().padLeft(2, '0')}/'
          '${selectedDate.month.toString().padLeft(2, '0')}/'
          '${selectedDate.year}',
      time: convertTo24Hour(selectedTime),
      doctorId: await session.getDoctorId() ?? '',
      petId: petID,
    );

    final service = BookAppointmentService();
    final response = await service.bookAppointment(request);

    if (!response.status) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.message)));
      return;
    }

    // ✅ SUCCESS
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BookingSuccessPage()),
    );
  }

  String convertTo24Hour(String time12h) {
    final dateTime = DateFormat('hh:mm a').parse(time12h);
    return DateFormat('HH:mm').format(dateTime);
  }
}
