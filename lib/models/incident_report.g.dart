// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incident_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IncidentReportImpl _$$IncidentReportImplFromJson(Map<String, dynamic> json) =>
    _$IncidentReportImpl(
      id: json['id'] as String,
      reporterId: json['reporterId'] as String,
      reporterName: json['reporterName'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: $enumDecode(_$IncidentTypeEnumMap, json['type']),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
      reportedAt: DateTime.parse(json['reportedAt'] as String),
      status: $enumDecode(_$ReportStatusEnumMap, json['status']),
      imageUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      videoUrls: (json['videoUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      audioUrl: json['audioUrl'] as String?,
      severity: (json['severity'] as num?)?.toInt(),
      assignedVolunteerId: json['assignedVolunteerId'] as String?,
      authorityNotes: json['authorityNotes'] as String?,
      resolvedAt: json['resolvedAt'] == null
          ? null
          : DateTime.parse(json['resolvedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$IncidentReportImplToJson(
        _$IncidentReportImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reporterId': instance.reporterId,
      'reporterName': instance.reporterName,
      'title': instance.title,
      'description': instance.description,
      'type': _$IncidentTypeEnumMap[instance.type]!,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'reportedAt': instance.reportedAt.toIso8601String(),
      'status': _$ReportStatusEnumMap[instance.status]!,
      'imageUrls': instance.imageUrls,
      'videoUrls': instance.videoUrls,
      'audioUrl': instance.audioUrl,
      'severity': instance.severity,
      'assignedVolunteerId': instance.assignedVolunteerId,
      'authorityNotes': instance.authorityNotes,
      'resolvedAt': instance.resolvedAt?.toIso8601String(),
      'metadata': instance.metadata,
    };

const _$IncidentTypeEnumMap = {
  IncidentType.fire: 'fire',
  IncidentType.flood: 'flood',
  IncidentType.earthquake: 'earthquake',
  IncidentType.landslide: 'landslide',
  IncidentType.cyclone: 'cyclone',
  IncidentType.medical: 'medical',
  IncidentType.accident: 'accident',
  IncidentType.other: 'other',
};

const _$ReportStatusEnumMap = {
  ReportStatus.pending: 'pending',
  ReportStatus.verified: 'verified',
  ReportStatus.inProgress: 'inProgress',
  ReportStatus.resolved: 'resolved',
  ReportStatus.falseAlarm: 'falseAlarm',
};
