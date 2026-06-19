import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixievet/Views/PetDashboard/BookAppointment/booking_success_page.dart';
import 'package:pixievet/Utilities/app_colors.dart';

class BookingSummaryPage extends StatelessWidget {
  final DateTime selectedDate;
  final String selectedTime;
  final double amount;

  const BookingSummaryPage({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    const double gst = 10.0;
    final double totalAmount = amount + gst;

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
      decoration: BoxDecoration(
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
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const BookingSuccessPage()),
              (route) => false,
            );
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
}
