import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  /// Форматирует дату из ISO 8601 строки в формат MM/dd/yyyy или MM/dd/yyyy-h:mma
  /// 
  /// Примеры:
  /// - "2025-09-18T00:00:00" -> "09/18/2025"
  /// - "2025-09-18T14:30:00" -> "09/18/2025-2:30pm"
  static String formatActionDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      // Формат: MM/dd/yyyy или MM/dd/yyyy-h:mm a (если есть время)
      if (dateTime.hour == 0 && dateTime.minute == 0) {
        // Только дата без времени
        return DateFormat('MM/dd/yyyy').format(dateTime);
      } else {
        // Дата с временем
        return DateFormat('MM/dd/yyyy-h:mma').format(dateTime).toLowerCase();
      }
    } catch (e) {
      // Если не удалось распарсить, возвращаем исходную строку
      return dateString;
    }
  }

  /// Форматирует DateTime в строку MM/dd/yyyy или MM/dd/yyyy-h:mma
  static String formatActionDateTime(DateTime dateTime) {
    if (dateTime.hour == 0 && dateTime.minute == 0) {
      return DateFormat('MM/dd/yyyy').format(dateTime);
    } else {
      return DateFormat('MM/dd/yyyy-h:mma').format(dateTime).toLowerCase();
    }
  }
}

