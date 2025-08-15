import 'package:freezed_annotation/freezed_annotation.dart';

part 'incident_report.freezed.dart';
part 'incident_report.g.dart';

enum IncidentType {
  fire,
  flood,
  earthquake,
  landslide,
  cyclone,
  medical,
  accident,
  other
}

enum ReportStatus { pending, verified, inProgress, resolved, falseAlarm }

@freezed
class IncidentReport with _$IncidentReport {
  const factory IncidentReport({
    required String id,
    required String reporterId,
    required String reporterName,
    required String title,
    required String description,
    required IncidentType type,
    required double latitude,
    required double longitude,
    required String address,
    required DateTime reportedAt,
    required ReportStatus status,
    List<String>? imageUrls,
    List<String>? videoUrls,
    String? audioUrl,
    int? severity, // 1-5 scale
    String? assignedVolunteerId,
    String? authorityNotes,
    DateTime? resolvedAt,
    Map<String, dynamic>? metadata,
  }) = _IncidentReport;

  factory IncidentReport.fromJson(Map<String, dynamic> json) =>
      _$IncidentReportFromJson(json);
} 