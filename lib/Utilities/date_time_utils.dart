import 'package:intl/intl.dart';

class DateTimeUtils {
  /// Convert DateTime to dd/MM/yyyy
  static String formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  static String formatDateLong(String date) {
    final inputFormat = DateFormat('dd-MM-yyyy');
    final outputFormat = DateFormat('MMM d, yyyy');

    final parsed = inputFormat.parse(date);
    return outputFormat.format(parsed);
  }

  /// Convert String (dd/MM/yyyy) to formatted date
  static String formatDateFromString(String dateString) {
    final parts = dateString.split('/');
    if (parts.length != 3) return dateString;

    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);

    final date = DateTime(year, month, day);
    return formatDate(date);
  }

  /// Convert 24-hour time (HH:mm) → 12-hour time
  static String convertTo12Hour(String time24) {
    final parts = time24.split(':');
    int hour = int.parse(parts[0]);
    final minute = parts[1];

    final period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    hour = hour == 0 ? 12 : hour;

    return '$hour:$minute $period';
  }

  /// Convert 12-hour time → 24-hour time
  static String convertTo24Hour(String time) {
    time = time.trim();

    // ✅ Case 1: Already in 24-hour format (HH:mm)
    final is24Hour = RegExp(r'^\d{1,2}:\d{2}$');
    if (is24Hour.hasMatch(time) &&
        !time.toUpperCase().contains('AM') &&
        !time.toUpperCase().contains('PM')) {
      final parts = time.split(':');
      return '${parts[0].padLeft(2, '0')}:${parts[1]}';
    }

    // Normalize → "2:30 PM"
    time = time
        .replaceAll('AM', ' AM')
        .replaceAll('PM', ' PM')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    final parts = time.split(' ');
    if (parts.length != 2) {
      throw FormatException('Invalid time format: $time');
    }

    final timePart = parts[0];
    final period = parts[1].toUpperCase();

    final timeParts = timePart.split(':');
    int hour = int.parse(timeParts[0]);
    final minute = timeParts[1];

    if (period == 'PM' && hour != 12) hour += 12;
    if (period == 'AM' && hour == 12) hour = 0;

    return '${hour.toString().padLeft(2, '0')}:$minute';
  }
}
