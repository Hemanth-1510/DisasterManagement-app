// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AlertImpl _$$AlertImplFromJson(Map<String, dynamic> json) => _$AlertImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      issuedAt: DateTime.parse(json['issuedAt'] as String),
      severity: json['severity'] as String,
      type: json['type'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );

Map<String, dynamic> _$$AlertImplToJson(_$AlertImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'issuedAt': instance.issuedAt.toIso8601String(),
      'severity': instance.severity,
      'type': instance.type,
      'lat': instance.lat,
      'lng': instance.lng,
    };
