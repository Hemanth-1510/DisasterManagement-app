// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastActive: json['lastActive'] == null
          ? null
          : DateTime.parse(json['lastActive'] as String),
      profileImageUrl: json['profileImageUrl'] as String?,
      emergencyContact: json['emergencyContact'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      address: json['address'] as String?,
      isVerified: json['isVerified'] as bool?,
      preferences: json['preferences'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'phone': instance.phone,
      'role': _$UserRoleEnumMap[instance.role]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastActive': instance.lastActive?.toIso8601String(),
      'profileImageUrl': instance.profileImageUrl,
      'emergencyContact': instance.emergencyContact,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'isVerified': instance.isVerified,
      'preferences': instance.preferences,
    };

const _$UserRoleEnumMap = {
  UserRole.citizen: 'citizen',
  UserRole.volunteer: 'volunteer',
  UserRole.authority: 'authority',
};
