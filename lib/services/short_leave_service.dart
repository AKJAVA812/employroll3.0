const int shortLeaveCreditMinutes = 120;
const String shortLeaveRelaxationHours = '02:00';

int? attendanceWorkingMinutes(String? value) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) return null;

  final clock = RegExp(
    r'^(\d{1,3}):(\d{1,2})(?::\d{1,2})?$',
  ).firstMatch(text);
  if (clock != null) {
    return int.parse(clock.group(1)!) * 60 + int.parse(clock.group(2)!);
  }

  final hours = RegExp(
    r'(\d+(?:\.\d+)?)\s*h',
    caseSensitive: false,
  ).firstMatch(text);
  final minutes = RegExp(
    r'(\d+)\s*m',
    caseSensitive: false,
  ).firstMatch(text);
  if (hours != null) {
    final hourMinutes = (double.parse(hours.group(1)!) * 60).round();
    return hourMinutes + (int.tryParse(minutes?.group(1) ?? '') ?? 0);
  }

  final decimalHours = double.tryParse(text);
  return decimalHours == null ? null : (decimalHours * 60).round();
}

int? _attendanceClockMinutes(String? value) {
  final text = value?.trim().toUpperCase() ?? '';
  final match = RegExp(
    r'(\d{1,2}):(\d{2})(?::\d{2})?\s*(AM|PM)?',
  ).firstMatch(text);
  if (match == null) return null;

  var hour = int.tryParse(match.group(1) ?? '');
  final minute = int.tryParse(match.group(2) ?? '');
  final period = match.group(3);
  if (hour == null || minute == null || minute > 59) return null;

  if (period != null) {
    if (hour < 1 || hour > 12) return null;
    if (period == 'AM' && hour == 12) hour = 0;
    if (period == 'PM' && hour != 12) hour += 12;
  } else if (hour > 23) {
    return null;
  }
  return hour * 60 + minute;
}

int? shortLeaveActualWorkingMinutes(
  String? workingHours, {
  String? inTime,
  String? outTime,
}) {
  final suppliedMinutes = attendanceWorkingMinutes(workingHours);
  if (suppliedMinutes != null) return suppliedMinutes;

  final inMinutes = _attendanceClockMinutes(inTime);
  final outMinutes = _attendanceClockMinutes(outTime);
  if (inMinutes == null || outMinutes == null) return null;

  final difference = outMinutes - inMinutes;
  return difference >= 0 ? difference : difference + (24 * 60);
}

String _formatWorkingMinutes(int? minutes) {
  if (minutes == null) return '--:--';
  final safeMinutes = minutes < 0 ? 0 : minutes;
  final hours = safeMinutes ~/ 60;
  final remainingMinutes = safeMinutes % 60;
  return '${hours.toString().padLeft(2, '0')}:${remainingMinutes.toString().padLeft(2, '0')}';
}

String shortLeaveActualWorkingHours(
  String? workingHours, {
  String? inTime,
  String? outTime,
}) {
  return _formatWorkingMinutes(
    shortLeaveActualWorkingMinutes(
      workingHours,
      inTime: inTime,
      outTime: outTime,
    ),
  );
}

String shortLeaveTotalWorkingHours(
  String? workingHours, {
  String? inTime,
  String? outTime,
}) {
  final baseMinutes = shortLeaveActualWorkingMinutes(
    workingHours,
    inTime: inTime,
    outTime: outTime,
  );
  if (baseMinutes == null) return '--:--';
  final totalMinutes = baseMinutes + shortLeaveCreditMinutes;
  return _formatWorkingMinutes(totalMinutes);
}
