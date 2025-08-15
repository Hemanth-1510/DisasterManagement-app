// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shelter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShelterImpl _$$ShelterImplFromJson(Map<String, dynamic> json) =>
    _$ShelterImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: $enumDecode(_$ShelterTypeEnumMap, json['type']),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
      status: $enumDecode(_$ShelterStatusEnumMap, json['status']),
      capacity: (json['capacity'] as num).toInt(),
      currentOccupancy: (json['currentOccupancy'] as num).toInt(),
      contactNumber: json['contactNumber'] as String?,
      contactPerson: json['contactPerson'] as String?,
      amenities: (json['amenities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      imageUrl: json['imageUrl'] as String?,
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
      additionalInfo: json['additionalInfo'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ShelterImplToJson(_$ShelterImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': _$ShelterTypeEnumMap[instance.type]!,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'status': _$ShelterStatusEnumMap[instance.status]!,
      'capacity': instance.capacity,
      'currentOccupancy': instance.currentOccupancy,
      'contactNumber': instance.contactNumber,
      'contactPerson': instance.contactPerson,
      'amenities': instance.amenities,
      'imageUrl': instance.imageUrl,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
      'additionalInfo': instance.additionalInfo,
    };

const _$ShelterTypeEnumMap = {
  ShelterType.emergency: 'emergency',
  ShelterType.relief: 'relief',
  ShelterType.medical: 'medical',
  ShelterType.food: 'food',
  ShelterType.temporary: 'temporary',
};

const _$ShelterStatusEnumMap = {
  ShelterStatus.open: 'open',
  ShelterStatus.full: 'full',
  ShelterStatus.closed: 'closed',
  ShelterStatus.maintenance: 'maintenance',
};
