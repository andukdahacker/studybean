import 'package:studybean/common/extensions/list_extension.dart';

enum DurationUnit {
  day('DAY'),
  week('WEEK'),
  month('MONTH'),
  year('YEAR'),;

  final String value;

  const DurationUnit(this.value);

  static DurationUnit? fromValue(String value) {
    return DurationUnit.values
        .firstWhereOrNull((element) => element.value == value);
  }
}