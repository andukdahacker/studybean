import 'duration_unit.dart';

class EditLocalActionInput {
  final String id;
  final String? name;
  final String? description;
  final int? duration;
  final DurationUnit? durationUnit;

  EditLocalActionInput(
      {required this.id,
      this.name,
      this.description,
      this.duration,
      this.durationUnit});
}
