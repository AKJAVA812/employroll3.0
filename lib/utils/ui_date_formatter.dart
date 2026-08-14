String formatUiDate(Object? value, {String fallback = '-'}) {
  if (value == null) return fallback;

  if (value is DateTime) return _formatDate(value);

  final text = value.toString().trim();
  if (text.isEmpty || text.toLowerCase() == 'null') return fallback;

  final date = _parseDate(text);
  if (date != null) return _formatDate(date);

  return text.replaceAllMapped(RegExp(r'\b(\d{4})-(\d{1,2})-(\d{1,2})\b'), (
    match,
  ) {
    final embeddedDate = _date(
      int.parse(match.group(1)!),
      int.parse(match.group(2)!),
      int.parse(match.group(3)!),
    );
    return embeddedDate == null ? match.group(0)! : _formatDate(embeddedDate);
  });
}

DateTime? _parseDate(String value) {
  final isoDate = RegExp(
    r'^(\d{4})-(\d{1,2})-(\d{1,2})(?:[T\s].*)?$',
  ).firstMatch(value);
  if (isoDate != null) {
    return _date(
      int.parse(isoDate.group(1)!),
      int.parse(isoDate.group(2)!),
      int.parse(isoDate.group(3)!),
    );
  }

  final displayDate = RegExp(
    r'^(\d{1,2})[-/](\d{1,2})[-/](\d{4})(?:[T\s].*)?$',
  ).firstMatch(value);
  if (displayDate != null) {
    return _date(
      int.parse(displayDate.group(3)!),
      int.parse(displayDate.group(2)!),
      int.parse(displayDate.group(1)!),
    );
  }

  return null;
}

DateTime? _date(int year, int month, int day) {
  final result = DateTime(year, month, day);
  if (result.year != year || result.month != month || result.day != day) {
    return null;
  }
  return result;
}

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day-$month-${date.year.toString().padLeft(4, '0')}';
}
