import 'duration_unit.dart';

class UpdateActionInput {
  final String id;
  final String? name;
  final String? description;
  final bool? isCompleted;
  final int? duration;
  final DurationUnit? durationUnit;

  UpdateActionInput({
    required this.id,
    this.name,
    this.description,
    this.isCompleted,
    this.duration,
    this.durationUnit,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isCompleted': isCompleted,
      'duration': duration,
      'durationUnit': durationUnit?.value,
    };
  }
}