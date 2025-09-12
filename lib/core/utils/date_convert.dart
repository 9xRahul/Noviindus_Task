import 'package:intl/intl.dart';

String formatDateTimeForApi(DateTime dt) {
  final date = DateFormat('dd/MM/yyyy').format(dt);
  final time = DateFormat('hh:mm a').format(dt);
  return '$date-$time';
}
