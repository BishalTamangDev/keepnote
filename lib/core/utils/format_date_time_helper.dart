import 'package:intl/intl.dart';

class FormatDateTimeHelper {
  static String getString(DateTime dateTime) =>
      DateFormat('yyyy-MM-dd H:m:s').format(dateTime).toString();
}
