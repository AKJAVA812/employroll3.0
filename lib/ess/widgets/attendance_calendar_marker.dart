import 'package:flutter/material.dart';

class AttendanceCalendarMarker extends StatelessWidget {
  const AttendanceCalendarMarker({
    super.key,
    required this.event,
    this.legends = const [],
    this.size = 42,
  });

  final Map<String, dynamic> event;
  final List<Map<String, String>> legends;
  final double size;

  @override
  Widget build(BuildContext context) {
    final segments = _calendarSegments(event);
    final baseColor =
        _resolvedColor(event, legends) ?? attendanceCalendarColor(event['mobColor']);
    final firstColor =
        segments.isNotEmpty
            ? _resolvedColor(segments.first, legends) ?? baseColor
            : baseColor;
    final secondColor =
        segments.length > 1
            ? _resolvedColor(segments[1], legends) ?? firstColor
            : firstColor;
    final dayText = _calendarDay(event);
    final textColor = _bestTextColor(firstColor, secondColor);

    return SizedBox.square(
      dimension: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: _AttendanceCirclePainter(
              firstColor: firstColor,
              secondColor: secondColor,
              split: segments.length > 1,
            ),
          ),
          Center(
            child: Text(
              dayText,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    color:
                        textColor == Colors.white
                            ? Colors.black54
                            : Colors.white70,
                    blurRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _calendarDay(Map<String, dynamic> event) {
  final value = event['logDate'] ?? event['date'] ?? event['attendanceDate'];
  final text = value?.toString().trim() ?? '';
  final parsed = DateTime.tryParse(text);
  if (parsed != null) return parsed.day.toString().padLeft(2, '0');

  final datePart = text.split('T').first;
  final parts = datePart.split(RegExp(r'[-/]'));
  int? day;
  if (parts.length == 3 && parts.first.length != 4) {
    day = int.tryParse(parts.first);
  } else if (parts.isNotEmpty) {
    day = int.tryParse(parts.last);
  }
  return day != null && day >= 1 && day <= 31
      ? day.toString().padLeft(2, '0')
      : '';
}

Color _bestTextColor(Color first, Color second) {
  final blackScore = _minimumContrast(Colors.black, first, second);
  final whiteScore = _minimumContrast(Colors.white, first, second);
  return whiteScore >= blackScore ? Colors.white : Colors.black;
}

double _minimumContrast(Color foreground, Color first, Color second) {
  final firstRatio = _contrastRatio(foreground, first);
  final secondRatio = _contrastRatio(foreground, second);
  return firstRatio < secondRatio ? firstRatio : secondRatio;
}

double _contrastRatio(Color first, Color second) {
  final firstLuminance = first.computeLuminance();
  final secondLuminance = second.computeLuminance();
  final lighter = firstLuminance > secondLuminance
      ? firstLuminance
      : secondLuminance;
  final darker = firstLuminance > secondLuminance
      ? secondLuminance
      : firstLuminance;
  return (lighter + 0.05) / (darker + 0.05);
}

Color attendanceCalendarColor(Object? raw) {
  var value = raw?.toString().trim() ?? '';
  if (value.startsWith('#')) value = value.substring(1);
  if (value.toLowerCase().startsWith('0x')) value = value.substring(2);
  if (value.length == 6) value = 'FF$value';
  final parsed = int.tryParse(value, radix: 16);
  return Color(parsed ?? 0xFF9E9E9E);
}

List<Map<String, dynamic>> _mapList(Object? value) {
  if (value is! List) return const [];
  return value
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList(growable: false);
}

List<Map<String, dynamic>> _calendarSegments(Map<String, dynamic> event) {
  final supplied = _mapList(
    event['segments'] ?? event['halves'] ?? event['halfStatuses'],
  );
  if (supplied.length >= 2) return supplied.take(2).toList(growable: false);

  final first = _firstText(event, const [
    'firstHalfStatusCode',
    'firstHalfStatus',
    'firstHalfAttendanceStatus',
    'sessionOneStatus',
  ]);
  final second = _firstText(event, const [
    'secondHalfStatusCode',
    'secondHalfStatus',
    'secondHalfAttendanceStatus',
    'sessionTwoStatus',
  ]);
  if (first.isNotEmpty && second.isNotEmpty) {
    return [_statusSegment(first), _statusSegment(second)];
  }

  for (final key in const [
    'combinedStatus',
    'statusCode',
    'status',
    'shortStatus',
    'attendanceStatus',
  ]) {
    final value = event[key]?.toString().trim() ?? '';
    final parts = value
        .split(RegExp(r'\s*[/|+]\s*'))
        .where((part) => part.isNotEmpty)
        .toList(growable: false);
    if (parts.length == 2) {
      return [_statusSegment(parts.first), _statusSegment(parts.last)];
    }
  }

  final paidDays = double.tryParse(event['paidDays']?.toString() ?? '');
  final hint = [
    event['status'],
    event['statusCode'],
    event['statusName'],
    event['statusReason'],
    event['leaveType'],
    event['type'],
  ].where((value) => value != null).join(' ').toLowerCase();
  if (paidDays != null && paidDays > 0 && paidDays < 1) {
    return [
      _statusSegment('PRESENT'),
      _statusSegment(hint.contains('leave') ? 'LEAVE' : 'ABSENT'),
    ];
  }
  return const [];
}

Map<String, dynamic> _statusSegment(String status) => {
  'statusCode': status,
  'status': status,
};

String _firstText(Map<String, dynamic> source, List<String> keys) {
  for (final key in keys) {
    final value = source[key]?.toString().trim() ?? '';
    if (value.isNotEmpty) return value;
  }
  return '';
}

Color? _resolvedColor(
  Map<String, dynamic> source,
  List<Map<String, String>> legends,
) {
  for (final key in const ['mobColor', 'color', 'statusColor', 'webColor']) {
    final color = _tryCalendarColor(source[key]);
    if (color != null) return color;
  }

  final aliases = _statusAliases(source);
  if (aliases.isEmpty) return null;
  for (final legend in legends) {
    if (_statusAliases(legend).any(aliases.contains)) {
      final color = _tryCalendarColor(legend['mobColor']);
      if (color != null) return color;
    }
  }
  return null;
}

Set<String> _statusAliases(Map source) {
  final aliases = <String>{};
  for (final key in const [
    'statusCode',
    'status',
    'statusName',
    'shortStatus',
    'attendanceStatus',
    'code',
  ]) {
    final normalized = _normalizeStatus(source[key]);
    if (normalized.isNotEmpty) aliases.add(normalized);
  }
  return aliases;
}

String _normalizeStatus(Object? value) =>
    (value?.toString() ?? '').toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');

Color? _tryCalendarColor(Object? raw) {
  var value = raw?.toString().trim() ?? '';
  if (value.isEmpty) return null;
  if (value.startsWith('#')) value = value.substring(1);
  if (value.toLowerCase().startsWith('0x')) value = value.substring(2);
  if (value.length == 6) value = 'FF$value';
  if (value.length != 8) return null;
  final parsed = int.tryParse(value, radix: 16);
  return parsed == null ? null : Color(parsed);
}

class _AttendanceCirclePainter extends CustomPainter {
  const _AttendanceCirclePainter({
    required this.firstColor,
    required this.secondColor,
    required this.split,
  });

  final Color firstColor;
  final Color secondColor;
  final bool split;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    if (!split) {
      canvas.drawOval(bounds, Paint()..color = firstColor);
      return;
    }

    canvas.save();
    canvas.clipPath(Path()..addOval(bounds));
    canvas.drawRect(bounds, Paint()..color = secondColor);
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..lineTo(0, size.height)
        ..close(),
      Paint()..color = firstColor,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AttendanceCirclePainter oldDelegate) {
    return oldDelegate.firstColor != firstColor ||
        oldDelegate.secondColor != secondColor ||
        oldDelegate.split != split;
  }
}
