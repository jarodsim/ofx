sealed class DateTimeAdapter {
  static DateTime stringToDateTime(String dateString) {
    /*20231109163440[-3:GMT] or 20231109 */
    if (dateString.length < 8) return DateTime.now();

    var year = int.tryParse(dateString.substring(0, 4)) ?? 0;
    var month = int.tryParse(dateString.substring(4, 6)) ?? 1;
    var day = int.tryParse(dateString.substring(6, 8)) ?? 1;

    var hour = 0;
    var minute = 0;
    var second = 0;

    if (dateString.length >= 14 &&
        !dateString.substring(8, 10).startsWith('[')) {
      hour = int.tryParse(dateString.substring(8, 10)) ?? 0;
      minute = int.tryParse(dateString.substring(10, 12)) ?? 0;
      second = int.tryParse(dateString.substring(12, 14)) ?? 0;
    }

    return DateTime.utc(year, month, day, hour, minute, second);
  }

  static DateTime stringDateTimeInTimeZoneLocal(String dateString) {
    /*20231109163440[-3:GMT]*/
    var date = stringToDateTime(dateString);
    var timeZone = _getTimeZone(dateString);
    var timeZoneLocal = DateTime.now().timeZoneOffset.inHours;

    Duration diferenceTimeZone = Duration(hours: timeZone);

    DateTime zero;
    DateTime dateTimeLocal;

    if (timeZone < 0) {
      zero = date.add(diferenceTimeZone.abs());
    } else {
      zero = date.subtract(diferenceTimeZone.abs());
    }

    if (timeZoneLocal < 0) {
      dateTimeLocal = zero.add(Duration(hours: timeZoneLocal));
    } else {
      dateTimeLocal = zero.subtract(Duration(hours: timeZoneLocal));
    }

    return dateTimeLocal;
  }

  static int _getTimeZone(String dateTime) {
    RegExp regex = RegExp(r'\[(-?\d+):GMT\]');
    RegExpMatch? match;
    int timeZone = 0;

    if (regex.hasMatch(dateTime.trim())) {
      match = regex.firstMatch(dateTime);

      if (match != null) {
        timeZone = int.parse(match.group(1) ?? '0');
      }
    }

    return timeZone;
  }
}
