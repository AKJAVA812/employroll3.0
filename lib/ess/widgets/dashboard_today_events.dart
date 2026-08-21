import '../EventsListModal.dart';

class DashboardTodayEvent {
  const DashboardTodayEvent({
    required this.fullName,
    required this.department,
    required this.date,
    required this.image,
    required this.type,
  });

  final String fullName;
  final String department;
  final String date;
  final String image;
  final String type;

  String get subtitle => department.isEmpty ? type : '$department | $type';
}

List<DashboardTodayEvent> dashboardTodayEvents(
  EssEventsListModal? events, {
  DateTime? today,
}) {
  final currentDate = today ?? DateTime.now();
  final result = <DashboardTodayEvent>[];

  for (final birthday in events?.bdayList ?? const <BdayList>[]) {
    if (!_isSameMonthAndDay(birthday.dob, currentDate)) continue;
    result.add(
      DashboardTodayEvent(
        fullName: birthday.fullName ?? '',
        department: birthday.department ?? '',
        date: birthday.dob ?? '',
        image: birthday.image ?? '',
        type: 'Birthday',
      ),
    );
  }

  for (final anniversary in events?.joblist ?? const <Joblist>[]) {
    if (!_isSameMonthAndDay(anniversary.doj, currentDate)) continue;
    result.add(
      DashboardTodayEvent(
        fullName: anniversary.fullName ?? '',
        department: anniversary.department ?? '',
        date: anniversary.doj ?? '',
        image: anniversary.image ?? '',
        type: 'Work Anniversary',
      ),
    );
  }

  return result;
}

bool _isSameMonthAndDay(String? rawDate, DateTime today) {
  final value = rawDate?.trim() ?? '';
  if (value.isEmpty) return false;

  final parsedIso = DateTime.tryParse(value);
  if (parsedIso != null) {
    return parsedIso.month == today.month && parsedIso.day == today.day;
  }

  final numbers =
      RegExp(r'\d+').allMatches(value).map((match) => match.group(0)!).toList();
  if (numbers.length < 2) return false;

  late final int day;
  late final int month;
  if (numbers.first.length == 4 && numbers.length >= 3) {
    month = int.tryParse(numbers[1]) ?? -1;
    day = int.tryParse(numbers[2]) ?? -1;
  } else {
    day = int.tryParse(numbers[0]) ?? -1;
    month = int.tryParse(numbers[1]) ?? -1;
  }
  return month == today.month && day == today.day;
}
