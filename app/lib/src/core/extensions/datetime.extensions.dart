import 'package:intl/intl.dart';

extension StringFormatExtensions on DateTime {
  /// Formats current [DateTime]-Object to a 'dd.mm.YYYY'-String without time.
  String toDateString() {
    final date = this;
    final formatter = DateFormat('dd.MM.yyyy');
    return formatter.format(date);
  }

  /// Formats current [DateTime]-Object to a 'dd.mm.YYYY hh:mm'-String with time.
  String toDateTimeString() {
    final date = this;
    final formatter = DateFormat('dd.MM.yyyy hh:mm');
    return formatter.format(date);
  }
}
