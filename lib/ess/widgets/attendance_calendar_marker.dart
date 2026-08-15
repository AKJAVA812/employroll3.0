import 'package:flutter/material.dart';

class AttendanceCalendarMarker extends StatelessWidget {
  const AttendanceCalendarMarker({
    super.key,
    required this.event,
    this.size = 42,
  });

  final Map<String, dynamic> event;
  final double size;

  @override
  Widget build(BuildContext context) {
    final segments = _mapList(event['segments']);
    final firstColor = attendanceCalendarColor(
      segments.isNotEmpty ? segments.first['mobColor'] : event['mobColor'],
    );
    final secondColor =
        segments.length > 1
            ? attendanceCalendarColor(segments[1]['mobColor'])
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
