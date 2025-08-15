import 'package:freezed_annotation/freezed_annotation.dart';

part 'volunteer_task.freezed.dart';
part 'volunteer_task.g.dart';

enum TaskType {
  rescue,
  medical,
  distribution,
  communication,
  coordination,
  other
}

enum TaskStatus { pending, assigned, inProgress, completed, cancelled }

@freezed
class VolunteerTask with _$VolunteerTask {
  const factory VolunteerTask({
    required String id,
    required String title,
    required String description,
    required TaskType type,
    required String incidentReportId,
    required double latitude,
    required double longitude,
    required String address,
    required DateTime createdAt,
    required TaskStatus status,
    String? assignedVolunteerId,
    String? assignedVolunteerName,
    DateTime? assignedAt,
    DateTime? startedAt,
    DateTime? completedAt,
    String? notes,
    int? priority, // 1-5 scale
    Map<String, dynamic>? requirements,
  }) = _VolunteerTask;

  factory VolunteerTask.fromJson(Map<String, dynamic> json) =>
      _$VolunteerTaskFromJson(json);
} 