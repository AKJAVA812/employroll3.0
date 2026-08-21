const String compOffAttendanceRequiredMessage =
    'Please handle attendance first, then apply for Comp Off.';

bool hasCompleteAttendancePunches(Object? inTime, Object? outTime) {
  return _hasAttendanceTime(inTime) && _hasAttendanceTime(outTime);
}

bool _hasAttendanceTime(Object? value) {
  final text = value?.toString().trim().toUpperCase() ?? '';
  return text.isNotEmpty && text != 'N/A' && text != '--:--' && text != 'NULL';
}
