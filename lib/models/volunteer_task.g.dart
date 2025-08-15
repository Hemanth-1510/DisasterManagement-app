// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volunteer_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VolunteerTaskImpl _$$VolunteerTaskImplFromJson(Map<String, dynamic> json) =>
    _$VolunteerTaskImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: $enumDecode(_$TaskTypeEnumMap, json['type']),
      incidentReportId: json['incidentReportId'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: $enumDecode(_$TaskStatusEnumMap, json['status']),
      assignedVolunteerId: json['assignedVolunteerId'] as String?,
      assignedVolunteerName: json['assignedVolunteerName'] as String?,
      assignedAt: json['assignedAt'] == null
          ? null
          : DateTime.parse(json['assignedAt'] as String),
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      notes: json['notes'] as String?,
      priority: (json['priority'] as num?)?.toInt(),
      requirements: json['requirements'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$VolunteerTaskImplToJson(_$VolunteerTaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'type': _$TaskTypeEnumMap[instance.type]!,
      'incidentReportId': instance.incidentReportId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'createdAt': instance.createdAt.toIso8601String(),
      'status': _$TaskStatusEnumMap[instance.status]!,
      'assignedVolunteerId': instance.assignedVolunteerId,
      'assignedVolunteerName': instance.assignedVolunteerName,
      'assignedAt': instance.assignedAt?.toIso8601String(),
      'startedAt': instance.startedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'notes': instance.notes,
      'priority': instance.priority,
      'requirements': instance.requirements,
    };

const _$TaskTypeEnumMap = {
  TaskType.rescue: 'rescue',
  TaskType.medical: 'medical',
  TaskType.distribution: 'distribution',
  TaskType.communication: 'communication',
  TaskType.coordination: 'coordination',
  TaskType.other: 'other',
};

const _$TaskStatusEnumMap = {
  TaskStatus.pending: 'pending',
  TaskStatus.assigned: 'assigned',
  TaskStatus.inProgress: 'inProgress',
  TaskStatus.completed: 'completed',
  TaskStatus.cancelled: 'cancelled',
};
